--[[
* Addons - Copyright (c) 2021 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

require('common');
local blu = require('blu');
local chat = require('chat');
local data = require('data');
local imgui = require('imgui');
local settings = require('settings');
local vc = require('vcmenu');

-- Give the trait tiers the table helpers and sort the traits for the lists..
local TRAITS = T{ };
for _, v in pairs(data.traits) do
    v.tiers = T(v.tiers);
    TRAITS:append(v);
end
table.sort(TRAITS, function (a, b)
    return a.name < b.name;
end);

-- The section each trait id is listed under in the active traits. Anything else is listed under Other..
local TRAIT_SECTIONS = T{ [54] = 'Other', [127] = 'Physical' };
local TRAIT_CATS = T{ };
for _, v in pairs(data.traits) do
    v.tiers:ieach(function (t)
        TRAIT_SECTIONS[t.trait] = v.group;
        TRAIT_CATS[t.trait] = v;
    end);
end

local SECTION_ORDER = { 'Physical', 'Magic', 'Defense', 'Other' };

-- The trait types offered by the dropdowns. (The first shows every type.)
local TYPES = T{ 'All Types', 'Physical', 'Magic', 'Defense', 'Killer', 'Resistance', 'Utility' };

local C = vc.colors;

-- The colors of the game's own menus..
local MENU_TEXT   = { 1.00, 1.00, 1.00, 1.00 };     -- A spell in use..
local MENU_IDLE   = { 0.70, 0.70, 0.72, 1.00 };     -- A spell not in use..
local MENU_OFF    = { 0.42, 0.42, 0.45, 1.00 };     -- A spell that cannot be used..
local MENU_SHADOW = { 0.00, 0.00, 0.00, 0.90 };

local MENU_FONT_PX = 15;    -- The size of the spell text..
local MENU_ROW_H   = 22;    -- The height of a spell row..

local LEFT_W    = 690;      -- The width of the left side of the spells page..
local LEVEL_CAP = 75;       -- CatsEye's level cap. Spells above it can be learned but not used..
local LIST_MIN  = 140;      -- The shortest the spell list gets to make room for the active traits..
local INFO_H    = 112;      -- The height of the spell information panel..

-- The melee traits listed together at the top of the active traits, by trait id..
local TRAIT_ORDER = { [1] = 1, [3] = 2, [14] = 3, [18] = 4, [15] = 5, [16] = 6 };   -- Accuracy, Attack, Store TP, Dual Wield, Double, Triple

local STAT_ORDER = { 'HP', 'MP', 'STR', 'DEX', 'VIT', 'AGI', 'INT', 'MND', 'CHR' };

-- The ways the spell list sorts. Stats and points sort highest first..
local SORTS = T{ 'Name', 'Set Points', 'Trait Points' };
for _, v in ipairs(STAT_ORDER) do
    SORTS:append(v);
end

local ELEMENTS = { [0] = 'Fire', 'Ice', 'Wind', 'Earth', 'Lightning', 'Water', 'Light', 'Dark' };

local defaults = T{
    -- Set points on top of the level based amount. (Assimilation merits and the Boruko bonus.)
    bonus_points = 34,

    -- The value of VanaCore's menus.ontop to put back. It is only set while the window is open, and is kept here so a
    -- crash with the window open cannot leave the player's setting changed. ('' when the setting was not in the file.)
    ontop_restore = false,

    -- The window scale.
    ui_scale = 1,
};

-- blusets UI Variables
local ui = {
    config  = nil,
    state   = vc.new_state('spells'),

    known   = T{ },     -- The spells the player can set, sorted by name..
    draft   = T{ },     -- The spells selected in the window..
    current = T{ },     -- The spells set on the player..
    refresh = 0,        -- The next time the current spells are read..

    menu_font = nil,    -- The font of the spell text. (nil until loaded, false if unavailable.)
    menu_font_next = nil,

    raise = false,      -- True to bring the window to the front on the next frame..
    holding = false,    -- True while the game's windows are held behind the window..

    info_id = nil,      -- The spell shown in the information panel..
    lock_left = 0,      -- The seconds left before blue magic can be cast..

    show_current = false,
    spell_filter = { '', },
    spell_type = 1,     -- The trait type of the spell list..
    spell_trait = nil,  -- The trait of the spell list. (nil for every trait.)
    spell_sort = 'Name', -- The sort of the spell list..
    trait_filter = { '', },
    trait_type = 1,     -- The trait type of the trait list..
    trait_selected = 0,
    set_name = { '', },
    set_selected = 0,
    sets = T{ },
};

--[[
* Returns the most set points the player can spend.
*
* @return {number} The set point limit.
--]]
local function get_max_points()
    -- The client only knows the limit once the blue magic menu has been opened..
    local known = blu.get_max_points();
    if (known > 0) then
        return known;
    end

    local level = blu.get_level();
    if (level == 0) then
        return 0;
    end

    local points = math.min(55, math.floor((level - 1) / 10) * 5 + 10);
    if (level >= 75) then
        points = points + ui.config.bonus_points;
    end
    return points;
end

--[[
* Returns the set points used by the given spells.
*
* @param {table} ids - The spell ids.
* @return {number} The set points used.
--]]
local function get_points(ids)
    local total = 0;
    ids:ieach(function (id)
        local spell = data.spells[id];
        total = total + (spell ~= nil and spell.points or 0);
    end);
    return total;
end

--[[
* Returns the tier of a job trait the players jobs give.
*
* @param {number} id - The trait id.
* @return {table|nil} The name, effect and job of the tier, nil if no current job gives the trait.
--]]
local function get_job_trait(id)
    local entry = data.job_traits[id];
    if (entry == nil) then
        return nil;
    end

    local ROMAN  = { 'I', 'II', 'III', 'IV', 'V', 'VI' };
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local best   = nil;
    for _, v in ipairs({ { player:GetMainJob(), player:GetMainJobLevel() }, { player:GetSubJob(), player:GetSubJobLevel() } }) do
        local ranks = entry.jobs[v[1]] or { };
        for _, r in ipairs(ranks) do
            if (r[1] <= v[2] and (best == nil or r[2] > best.rank)) then
                local tiered = #ranks > 1 and (' ' .. ROMAN[r[2]]) or '';
                best = {
                    rank   = r[2],
                    name   = entry.name .. tiered,
                    effect = r[3],
                    job    = AshitaCore:GetResourceManager():GetString('jobs.names_abbr', v[1]),
                };
            end
        end
    end
    return best;
end

--[[
* Totals the trait points of the given spells and works out the tier reached in each trait category.
*
* @param {table} ids - The spell ids.
* @return {table} Table of category id to its result. (points, tier, next, name, tiers)
--]]
local function calc_traits(ids)
    local result = T{ };

    ids:ieach(function (id)
        local spell = data.spells[id];
        if (spell ~= nil and data.traits[spell.cat] ~= nil) then
            local r = result[spell.cat];
            if (r == nil) then
                r = T{ points = 0, cat = data.traits[spell.cat] };
                result[spell.cat] = r;
            end
            r.points = r.points + spell.weight;
        end
    end);

    result:each(function (r)
        r.cat.tiers:ieach(function (t)
            if (r.points >= t.points) then
                r.tier = t;
            elseif (r.next == nil) then
                r.next = t;
            end
        end);
    end);

    return result;
end

--[[
* Returns if the given spell search matches the given text.
*
* @param {string} filter - The text being searched for.
* @param {string} text - The text being searched.
* @return {boolean} True if every word of the filter is found.
--]]
local function matches(filter, text)
    for word in filter:lower():gmatch('%S+') do
        if (not text:find(word, 1, true)) then
            return false;
        end
    end
    return true;
end

--[[
* Returns the value a spell is sorted on.
*
* @param {table} v - The spell list entry.
* @return {number} The value.
--]]
local function get_sort_value(v)
    if (ui.spell_sort == 'Set Points') then
        return v.data.points;
    elseif (ui.spell_sort == 'Trait Points') then
        return data.traits[v.data.cat] ~= nil and v.data.weight or 0;
    end
    return tonumber((v.data.stats or ''):match(ui.spell_sort .. '([+-]%d+)')) or 0;
end

--[[
* Sorts the list of spells the player knows.
--]]
local function sort_known()
    table.sort(ui.known, function (a, b)
        if (ui.spell_sort ~= 'Name') then
            local x, y = get_sort_value(a), get_sort_value(b);
            if (x ~= y) then
                return x > y;
            end
        end
        return a.name < b.name;
    end);
end

--[[
* Rebuilds the list of spells the player knows.
--]]
local function refresh_known()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local res    = AshitaCore:GetResourceManager();
    local level  = blu.get_level();

    ui.known = T{ };
    for id, spell in pairs(data.spells) do
        local r = res:GetSpellById(id + 512);
        if (r ~= nil and spell.points > 0 and player:HasSpell(id + 512) and r.LevelRequired[17] > 0 and r.LevelRequired[17] <= level) then
            ui.known:append(T{ id = id, name = r.Name[1], level = r.LevelRequired[17], data = spell });
        end
    end
    sort_known();
end

--[[
* Refreshes the saved spell set list.
--]]
local function refresh_sets()
    ui.sets = blu.list_sets();
end

--[[
* Replaces the selected spells with the spells that are set on the player.
--]]
local function revert_draft()
    ui.draft = T{ };
    blu.get_spells():ieach(function (id)
        if (id ~= 0) then
            ui.draft:append(id);
        end
    end);
end

--[[
* Adds or removes a spell from the selected spells.
*
* @param {number} id - The spell id.
--]]
local function toggle_draft(id)
    local key = ui.draft:find(id);
    if (key ~= nil) then
        ui.draft:remove(key);
    elseif (ui.draft:len() < blu.get_slot_count()) then
        ui.draft:append(id);
    end
end

--[[
* Returns VanaCore's settings.
*
* @return {table|nil} The settings, nil outside VanaCore.
--]]
local function get_vana_config()
    local v = rawget(_G, 'vana');
    if (type(v) == 'table' and type(v.config) == 'table') then
        return v.config;
    end
    return nil;
end

--[[
* Puts the player's menus.ontop setting back.
--]]
local function restore_game_windows()
    local config = get_vana_config();
    if (config ~= nil and ui.config.ontop_restore ~= false) then
        local value = ui.config.ontop_restore;
        config.set('client', 'menus.ontop', value ~= '' and value or nil);
        ui.config.ontop_restore = false;
        settings.save();
    end
    ui.holding = false;
end

--[[
* Stops VanaCore laying the game's windows, such as the chat, over this window while it is open.
--]]
local function hold_game_windows()
    local config = get_vana_config();
    if (config == nil or ui.holding) then
        return;
    end

    ui.holding = true;
    if (ui.config.ontop_restore == false) then
        ui.config.ontop_restore = config.get('client', 'menus.ontop') or '';
        settings.save();
    end
    config.set('client', 'menus.ontop', '0');
end

--[[
* Loads the addon configuration.
--]]
function ui.load()
    ui.config = settings.load(defaults);
    ui.state.scale = ui.config.ui_scale;

    -- Put the setting back if the game closed while the window was open..
    restore_game_windows();
    settings.register('settings', 'settings_update', function (s)
        if (s ~= nil) then
            ui.config = s;
        end
    end);
end

--[[
* Puts everything back when the addon unloads.
--]]
function ui.unload()
    restore_game_windows();
end

--[[
* Opens or closes the window.
--]]
function ui.toggle()
    ui.state.open[1] = not ui.state.open[1];
    if (ui.state.open[1]) then
        ui.raise = true;
        hold_game_windows();
        refresh_known();
        refresh_sets();
        revert_draft();
    end
end

--[[
* Loads the bold face used for the spell text. It only exists under VanaCore, which can add fonts while running; a
* font added this frame is usable from the next.
--]]
local function load_menu_font()
    if (ui.menu_font == nil) then
        ui.menu_font = false;
        if (rawget(_G, 'vana') ~= nil) then
            local path = (os.getenv('WINDIR') or 'C:\\Windows') .. '\\Fonts\\arialbd.ttf';
            local ok, font = pcall(imgui.AddFontFromFileTTF, path, 16);
            ui.menu_font_next = ok and font or nil;
        end
    elseif (ui.menu_font_next ~= nil) then
        ui.menu_font, ui.menu_font_next = ui.menu_font_next, nil;
    end
end

--[[
* Draws text the way the game's menus do; bold with a dark drop shadow.
*
* @param {number} x - The x position inside the window.
* @param {number} y - The y position inside the window.
* @param {string} text - The text.
* @param {table} color - The text color.
--]]
local function menu_text(x, y, text, color)
    local font = ui.menu_font and pcall(imgui.PushFont, ui.menu_font, vc.z(MENU_FONT_PX));
    imgui.SetCursorPos({ x + 1, y + 1 });
    imgui.TextColored(MENU_SHADOW, text);
    imgui.SetCursorPos({ x, y });
    imgui.TextColored(color, text);
    if (font) then
        imgui.PopFont();
    end
end

--[[
* Renders a spell row.
*
* @param {string} id - The row id.
* @param {string} name - The spell name.
* @param {table} color - The spell name color.
* @param {number} name_x - The left of the name inside the row.
* @param {table} cols - The other columns: { x, text, color } inside the row.
* @param {string|nil} tip - The tooltip of the row.
* @param {boolean|nil} selected - True to highlight the row.
* @return {boolean} True if the row was clicked.
* @return {boolean} True if the row was double clicked.
--]]
local function menu_row(id, name, color, name_x, cols, tip, selected)
    local x, y = vc.xy(imgui.GetCursorPos());
    local h = vc.z(MENU_ROW_H);

    imgui.PushStyleColor(ImGuiCol_Header, vc.alpha(C.on, 0.25));
    local clicked = imgui.Selectable('##' .. id, selected == true, 0, { 0, h });
    imgui.PopStyleColor();
    local double = imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0);
    if (tip ~= nil and imgui.IsItemHovered()) then
        imgui.SetTooltip(tip);
    end

    menu_text(x + vc.z(name_x), y + vc.z(3), name, color);
    for _, v in ipairs(cols) do
        imgui.SetCursorPos({ x + vc.z(v[1]), y + vc.z(3) });
        imgui.TextColored(v[3], v[2]);
    end

    imgui.SetCursorPos({ x, y + h });
    imgui.Dummy({ 0, 0 });
    return clicked, double;
end

--[[
* Renders a row for a spell. A click shows the spell, a double click adds or removes it.
*
* @param {string} id - The row id.
* @param {number} spell - The spell id.
* @param {string} name - The spell name.
* @param {table} color - The spell name color.
* @param {number} name_x - The left of the name inside the row.
* @param {table} cols - The other columns.
* @param {boolean} usable - True if the spell can be selected.
* @return {boolean} True if the selected spells changed.
--]]
local function spell_row(id, spell, name, color, name_x, cols, usable)
    local clicked, double = menu_row(id, name, color, name_x, cols, nil, ui.info_id == spell);
    if (clicked) then
        ui.info_id = spell;
    end
    if (double and usable) then
        toggle_draft(spell);
        return true;
    end
    return false;
end

--[[
* Returns the trait points text of a spell.
*
* @param {table|nil} spell - The spell data.
* @return {string} The trait points. Empty for spells without a trait.
--]]
local function trait_points(spell)
    if (spell == nil or data.traits[spell.cat] == nil) then
        return '';
    end
    return ('+%d'):fmt(spell.weight);
end

--[[
* Renders a row of column titles.
*
* @param {table} cols - The columns: { x, title } at 100%.
--]]
local function column_titles(cols)
    local x, y = vc.xy(imgui.GetCursorPos());
    for _, v in ipairs(cols) do
        imgui.SetCursorPos({ x + vc.z(v[1]), y });
        imgui.TextColored(C.dim, v[2]);
    end
    imgui.SetCursorPos({ x, y + vc.z(20) });
    imgui.Dummy({ 0, 0 });
end

--[[
* Renders a framed scrolling panel with the given width, matching vc.list.
*
* @param {string} id - The panel id.
* @param {number} w - The panel width at 100%. (0 fills the row.)
* @param {number} reserve - The space to leave below the panel at 100%.
* @param {function} fn - The panel contents.
--]]
local function pane(id, w, reserve, fn)
    imgui.PushStyleColor(ImGuiCol_ChildBg, C.side);
    imgui.PushStyleColor(ImGuiCol_Border, C.line);
    imgui.PushStyleVar(ImGuiStyleVar_ChildRounding, vc.z(6));
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { vc.z(4), vc.z(4) });
    imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, { 0, 0 });
    if (imgui.BeginChild(id, { vc.z(w), -vc.z(reserve) }, true)) then
        vc.safe(fn);
    end
    imgui.EndChild();
    imgui.PopStyleVar(3);
    imgui.PopStyleColor(2);
end

--[[
* Returns if a trait belongs to the given trait type.
*
* @param {table|nil} cat - The trait category.
* @param {number} index - The index into TYPES.
* @return {boolean} True if the trait matches.
--]]
local function is_type(cat, index)
    return index == 1 or (cat ~= nil and cat.group == TYPES[index]);
end

--[[
* Renders a trait type dropdown.
*
* @param {string} id - The dropdown id.
* @param {number} w - The dropdown width at 100%.
* @param {number} current - The index into TYPES.
* @return {number|nil} The picked index, nil if nothing was picked.
--]]
local function type_dropdown(id, w, current)
    local picked = nil;
    imgui.PushItemWidth(vc.z(w));
    if (imgui.BeginCombo(id, TYPES[current])) then
        TYPES:ieach(function (v, k)
            if (imgui.Selectable(v, k == current)) then
                picked = k;
            end
        end);
        imgui.EndCombo();
    end
    imgui.PopItemWidth();
    return picked;
end

--[[
* Renders the spell list's search box and dropdowns.
--]]
local function render_spell_filters()
    vc.search_box('##spellfilter', ui.spell_filter, 'Filter by spell, trait or stat', 170);
    imgui.SameLine();

    local picked = type_dropdown('##spelltype', 104, ui.spell_type);
    if (picked ~= nil) then
        ui.spell_type  = picked;
        ui.spell_trait = nil;
    end
    imgui.SameLine();

    imgui.PushItemWidth(vc.z(170));
    if (imgui.BeginCombo('##spelltrait', ui.spell_trait ~= nil and ui.spell_trait.name or 'All Traits')) then
        if (imgui.Selectable('All Traits', ui.spell_trait == nil)) then
            ui.spell_trait = nil;
        end
        TRAITS:ieach(function (v)
            if (is_type(v, ui.spell_type) and imgui.Selectable(v.name, ui.spell_trait == v)) then
                ui.spell_trait = v;
            end
        end);
        imgui.EndCombo();
    end
    imgui.PopItemWidth();
    imgui.SameLine();

    imgui.PushItemWidth(vc.z(LEFT_W - 472));
    if (imgui.BeginCombo('##spellsort', ('Sort: %s'):fmt(ui.spell_sort))) then
        SORTS:ieach(function (v)
            if (imgui.Selectable(v, ui.spell_sort == v)) then
                ui.spell_sort = v;
                sort_known();
            end
        end);
        imgui.EndCombo();
    end
    imgui.PopItemWidth();
end

--[[
* Renders the panel showing the game's information on the clicked spell.
--]]
local function render_spell_info()
    local res = AshitaCore:GetResourceManager();
    local r   = ui.info_id ~= nil and res:GetSpellById(ui.info_id + 512) or nil;

    pane('spellinfo', 0, ui.info_reserve, function ()
        local x, y = vc.xy(imgui.GetCursorPos());
        if (r == nil) then
            imgui.SetCursorPos({ x + vc.z(6), y + vc.z(4) });
            imgui.TextColored(C.dim, 'Click a spell to read about it. Double click to add or remove it.');
            return;
        end

        local on     = ui.draft:hasval(ui.info_id);
        local usable = AshitaCore:GetMemoryManager():GetPlayer():HasSpell(ui.info_id + 512) and r.LevelRequired[17] <= blu.get_level();

        menu_text(x + vc.z(6), y + vc.z(3), r.Name[1], MENU_TEXT);
        if (on or usable) then
            imgui.SetCursorPos({ vc.avail_w() - vc.z(76), y + vc.z(2) });
            if (vc.button(on and 'Remove' or 'Add', on and 'danger' or 'primary', 76)) then
                toggle_draft(ui.info_id);
            end
        end

        local stats = T{
            ('MP %d'):fmt(r.ManaCost),
            ('Cast %.2fs'):fmt(r.CastTime / 4),
            ('Recast %.2fs'):fmt(r.RecastDelay / 4),
            ('Lv %d'):fmt(r.LevelRequired[17]),
        };
        if (ELEMENTS[r.Element] ~= nil) then
            stats:append(ELEMENTS[r.Element]);
        end
        imgui.SetCursorPos({ x + vc.z(6), y + vc.z(25) });
        imgui.TextColored(C.teal, stats:concat('   '));

        local spell = data.spells[ui.info_id];
        local lines = T{ };
        if (spell ~= nil) then
            local cat = data.traits[spell.cat];
            lines:append(('Blue Magic Points %d'):fmt(spell.points));
            lines:append(cat ~= nil and ('Job Trait: %s (%d)'):fmt(cat.name, spell.weight) or 'Job Trait: None');
            if (spell.stats ~= nil) then
                lines:append(spell.stats);
            end
        end

        imgui.SetCursorPos({ x + vc.z(6), y + vc.z(44) });
        imgui.TextColored(C.gold, lines:concat('   '));

        imgui.SetCursorPos({ x + vc.z(6), y + vc.z(63) });
        imgui.PushTextWrapPos(0);
        imgui.TextColored(C.text, r.Description[1]);
        imgui.PopTextWrapPos();
    end);
end

--[[
* Returns the lock time as text.
*
* @return {string} The time left. (m:ss)
--]]
local function get_lock_text()
    local left = math.ceil(ui.lock_left);
    return ('%d:%02d'):fmt(math.floor(left / 60), left % 60);
end

--[[
* Renders the bar showing how long blue magic stays locked.
--]]
local function render_lock()
    if (ui.lock_left <= 0) then
        return;
    end
    imgui.TextColored(C.gold, ('Blue magic locked after changing spells: %s'):fmt(get_lock_text()));
    vc.progress(ui.lock_left / math.max(ui.lock_left, blu.LOCK_SECONDS));
end

--[[
* Renders the loader status at the top of a page.
--]]
local function render_status()
    if (blu.loader ~= nil) then
        local done, total = blu.get_load_progress();
        imgui.TextColored(C.acc, ('Setting spells: %d of %d confirmed'):fmt(done, total));
        imgui.SameLine();
        vc.right(70);
        if (vc.button('Stop', 'danger', 70)) then
            blu.loader_finish('Stopped by the player.');
        end
        vc.progress(total > 0 and done / total or 0);
    elseif (blu.last_result ~= nil and blu.last_result.failed:len() > 0) then
        imgui.TextColored(C.bad, ('The last load missed %d spell(s):'):fmt(blu.last_result.failed:len()));
        blu.last_result.failed:ieach(function (v)
            imgui.TextColored(C.gold, v);
        end);
    end
end

--[[
* Renders the saved spell set controls.
--]]
local function render_sets()
    vc.section('SAVED SETS');

    local width = vc.avail_w() - vc.z(160);

    imgui.PushItemWidth(width * 0.5);
    if (imgui.BeginCombo('##sets', ui.sets[ui.set_selected] or '(choose a set)')) then
        ui.sets:ieach(function (v, k)
            if (imgui.Selectable(v, ui.set_selected == k)) then
                ui.set_selected = k;
                ui.set_name[1]  = v;

                local names = blu.read_set(v);
                if (names ~= nil) then
                    ui.draft = blu.names_to_ids(names);
                end
            end
        end);
        imgui.EndCombo();
    end
    imgui.PopItemWidth();
    imgui.SameLine();

    imgui.PushItemWidth(width * 0.5 - vc.z(8));
    imgui.InputTextWithHint('##setname', 'Set name', ui.set_name, 64);
    imgui.PopItemWidth();
    imgui.SameLine();

    if (vc.button('Save', nil, 66)) then
        local name  = ui.set_name[1]:trim();
        local names = ui.draft:map(function (id)
            return blu.get_spell_name(id);
        end);
        if (name ~= '' and blu.write_set(name, names)) then
            print(chat.header(addon.name):append(chat.message('Saved spell list to: ')):append(chat.success(name)));
            refresh_sets();
        end
    end
    imgui.SameLine();
    if (vc.button('Delete', 'danger', 66) and ui.sets[ui.set_selected] ~= nil) then
        imgui.OpenPopup('blusets_delete');
    end
    if (imgui.BeginPopup('blusets_delete')) then
        local name = ui.sets[ui.set_selected] or '';
        imgui.Text(('Delete spell set "%s"?'):fmt(name));
        if (vc.button('Delete Set', 'danger')) then
            ashita.fs.remove(blu.get_sets_path() .. name .. '.txt');
            ui.set_selected = 0;
            refresh_sets();
            imgui.CloseCurrentPopup();
        end
        imgui.SameLine();
        if (vc.button('Cancel')) then
            imgui.CloseCurrentPopup();
        end
        imgui.EndPopup();
    end
end

--[[
* Adds up the stats the given spells provide.
*
* @param {table} ids - The spell ids.
* @return {string} The totals, in the order the game lists them.
--]]
local function get_stat_totals(ids)
    local totals = { };
    ids:ieach(function (id)
        local spell = data.spells[id];
        if (spell ~= nil and spell.stats ~= nil) then
            for name, value in spell.stats:gmatch('(%a+)([+-]%d+)') do
                totals[name] = (totals[name] or 0) + tonumber(value);
            end
        end
    end);

    local parts = T{ };
    for _, name in ipairs(STAT_ORDER) do
        if ((totals[name] or 0) ~= 0) then
            parts:append(('%s%+d'):fmt(name, totals[name]));
        end
    end
    return parts:concat(' ');
end

--[[
* Returns the most a trait can reach using every spell the level cap allows.
*
* @param {table} cat - The trait category.
* @return {table|nil} The highest tier in reach, nil if none is.
* @return {number} The trait points of those spells.
--]]
local function get_max_tier(cat)
    if (cat.most == nil) then
        cat.most = 0;
        for id, spell in pairs(data.spells) do
            local r = AshitaCore:GetResourceManager():GetSpellById(id + 512);
            if (data.traits[spell.cat] == cat and r ~= nil and r.LevelRequired[17] >= 1 and r.LevelRequired[17] <= LEVEL_CAP) then
                cat.most = cat.most + spell.weight;
            end
        end
        cat.tiers:ieach(function (t)
            if (t.points <= cat.most) then
                cat.top = t;
            end
        end);
    end
    return cat.top, cat.most;
end

--[[
* Returns the rank of a trait tier within its trait.
*
* @param {table} cat - The trait category.
* @param {table} tier - The tier.
* @return {number} The rank, 1 for the first tier of the trait.
--]]
local function get_tier_rank(cat, tier)
    local rank = 0;
    cat.tiers:ieach(function (t)
        if (t.trait == tier.trait and t.points <= tier.points) then
            rank = rank + 1;
        end
    end);
    return rank;
end

--[[
* Returns if a trait is at the most CatsEye allows.
*
* @param {table|nil} cat - The trait category.
* @param {table|nil} tier - The tier reached with spells.
* @param {table|nil} job - The tier the job gives.
* @param {number|nil} id - The trait id the job tier is for.
* @return {string} The status text.
* @return {table} The status color.
--]]
local function get_max_status(cat, tier, job, id)
    local top = cat ~= nil and get_max_tier(cat) or nil;
    if (top == nil) then
        return '-', C.mute;
    end

    local rank = get_tier_rank(cat, top);
    if ((tier ~= nil and tier.points >= top.points) or (job ~= nil and id == top.trait and job.rank >= rank)) then
        return 'Max', C.gold;
    end
    return 'Can increase', C.teal;
end

--[[
* Builds the row of a trait category. The stronger of the job trait and the blue magic trait is the one that applies.
*
* @param {table} r - The trait result.
* @param {table} shown - Table of the trait ids that have a row. (Updated.)
* @return {table} The row.
--]]
local function build_trait_row(r, shown)
    local tier = r.tier;
    local id   = tier ~= nil and tier.trait or (r.cat.tiers[1] ~= nil and r.cat.tiers[1].trait or nil);

    -- On the character the server has the last word on what is active..
    if (ui.show_current and tier ~= nil and not blu.has_trait(tier.trait)) then
        tier = nil;
    end

    local job  = (id ~= nil and blu.has_trait(id)) and get_job_trait(id) or nil;
    local rank = tier ~= nil and get_tier_rank(r.cat, tier) or 0;

    local row = T{ id = id, cat = r.cat, name = r.cat.name, color = C.mute, from = '-', bonus = 'Not active', bonus_color = C.mute, active = false };
    if (job ~= nil and job.rank >= rank) then
        row.name, row.color, row.from, row.bonus, row.bonus_color, row.active = job.name, C.acc, job.job, job.effect, C.text, true;
    elseif (tier ~= nil) then
        row.name, row.color, row.from, row.bonus, row.bonus_color, row.active = tier.name, C.teal, 'Spells', tier.effect, C.text, true;
    end
    if (row.active) then
        shown[id] = true;
    end

    row.status, row.status_color = get_max_status(r.cat, tier, job, id);

    row.points = tostring(r.points);
    if (r.next ~= nil) then
        row.points = ('%d/%d'):fmt(r.points, r.next.points);
    end

    -- Show the next tier that would actually add something..
    local floor = math.max(rank, job ~= nil and job.rank or 0);
    r.cat.tiers:ieach(function (t)
        if (row.tip == nil and t.points > r.points and t.trait == id and get_tier_rank(r.cat, t) > floor) then
            row.tip = ('%d more for %s: %s'):fmt(t.points - r.points, t.name, t.effect);
        end
    end);

    return row;
end

--[[
* Builds the rows of the active traits panel.
*
* @param {table} ids - The spell ids.
* @return {table} The rows, by section.
--]]
local function get_active_rows(ids)
    local rows  = T{ };
    local shown = T{ };
    calc_traits(ids):each(function (r)
        rows:append(build_trait_row(r, shown));
    end);

    -- Everything else the character has comes from their jobs..
    for id = 0, 255 do
        if (shown[id] == nil and blu.has_trait(id)) then
            local job = get_job_trait(id);
            if (job ~= nil) then
                local cat = TRAIT_CATS[id];
                local top = cat ~= nil and get_max_tier(cat) or nil;
                local status, color = get_max_status(cat, (top ~= nil and shown[top.trait]) and top or nil, job, id);
                rows:append(T{ id = id, cat = cat, name = job.name, color = C.acc, points = '-', from = job.job, bonus = job.effect, bonus_color = C.text, active = true, status = status, status_color = color });
            elseif (ui.show_current) then
                rows:append(T{ id = id, name = ('Trait %d'):fmt(id), color = C.acc, points = '-', from = 'Job', bonus = '', bonus_color = C.text, active = true, status = '-', status_color = C.mute });
            end
        end
    end

    -- Sort the rows into their sections..
    local order = { };
    for k, v in ipairs(SECTION_ORDER) do
        order[v] = k;
    end
    rows:ieach(function (v)
        local section = v.id ~= nil and TRAIT_SECTIONS[v.id] or nil;
        v.section = order[section] ~= nil and section or 'Other';
    end);

    table.sort(rows, function (a, b)
        if (a.section ~= b.section) then
            return order[a.section] < order[b.section];
        end
        local x, y = TRAIT_ORDER[a.id] or 99, TRAIT_ORDER[b.id] or 99;
        if (x ~= y) then
            return x < y;
        end
        if (a.active ~= b.active) then
            return a.active;
        end
        return a.name < b.name;
    end);

    return rows;
end

--[[
* Renders the active traits panel.
*
* @param {table} ids - The spell ids.
* @param {table} rows - The rows.
--]]
local function render_active_traits(ids, rows)
    pane('activetraits', LEFT_W, 8, function ()
        local x, y = vc.xy(imgui.GetCursorPos());
        imgui.SetCursorPos({ x + vc.z(8), y + vc.z(2) });
        imgui.TextColored(C.dim, 'Stats');
        imgui.SetCursorPos({ x + vc.z(60), y + vc.z(2) });
        imgui.TextColored(C.gold, get_stat_totals(ids));
        imgui.SetCursorPos({ x, y + vc.z(24) });
        imgui.Dummy({ 0, 0 });

        column_titles({ { 8, 'Active Trait' }, { 180, 'Points' }, { 235, 'From' }, { 290, 'Bonus' }, { 590, 'CatsEye' } });

        rows:ieach(function (v, k)
            local cols = T{ { 180, v.points, C.text }, { 235, v.from, C.dim }, { 290, vc.fit_text(v.bonus, vc.z(292)), v.bonus_color }, { 590, v.status, v.status_color } };
            if (menu_row(('active%d'):fmt(k), v.name, v.color, 8, cols, v.tip) and v.cat ~= nil) then
                ui.trait_selected = v.cat;
                ui.state.page     = 'search';
            end
        end);
    end);
end

--[[
* Renders the spell selection page.
--]]
local function render_page_spells()
    local max = get_max_points();

    vc.title('Spells', ('On character: %d of %d spells, %d of %d points'):fmt(ui.current:len(), blu.get_slot_count(), get_points(ui.current), max));
    render_lock();
    render_status();

    -- Left Side: every spell the player can set..
    imgui.BeginGroup();
        render_spell_filters();

        -- The active traits take the height they need; the spell list gets the rest..
        local ids      = ui.show_current and ui.current or ui.draft;
        local rows     = get_active_rows(ids);
        local _, room  = vc.xy(imgui.GetContentRegionAvail());
        local traits_h = math.min(66 + rows:len() * MENU_ROW_H, room / vc.scale() - LIST_MIN - 70);

        column_titles({ { 10, 'Pts' }, { 33, 'Spell' }, { 200, 'Trait Pts' }, { 267, 'Trait' }, { 442, 'Stats' } });
        pane('spellpane', LEFT_W, traits_h + 44, function ()
            local filter = ui.spell_filter[1];
            ui.known:ieach(function (v)
                local cat = data.traits[v.data.cat];
                local trait = cat ~= nil and cat.name or '';
                local shown = is_type(cat, ui.spell_type) and (ui.spell_trait == nil or ui.spell_trait == cat);
                if (shown and matches(filter, (v.name .. ' ' .. trait .. ' ' .. (v.data.stats or '')):lower())) then
                    local on = ui.draft:hasval(v.id);
                    local cols = T{ { 6, tostring(v.data.points), on and C.teal or C.dim }, { 205, trait_points(v.data), on and C.teal or C.dim }, { 262, vc.fit_text(trait, vc.z(170)), C.mute }, { 437, vc.fit_text(v.data.stats or '', vc.z(LEFT_W - 450)), C.text } };
                    spell_row(('spell%d'):fmt(v.id), v.id, v.name, on and MENU_TEXT or MENU_IDLE, 28, cols, true);
                end
            end);
        end);

        local picked = vc.seg('traitsrc', { { false, 'Selected Spells' }, { true, 'On Character' } }, ui.show_current);
        if (picked ~= nil) then
            ui.show_current = picked;
        end
        render_active_traits(ids, rows);
    imgui.EndGroup();
    imgui.SameLine();

    -- Right Side: the selected spells..
    imgui.BeginGroup();
        local points = get_points(ui.draft);
        imgui.TextColored(C.dim, 'Selected:');
        imgui.SameLine();
        imgui.TextColored(points > max and C.bad or C.teal, ('%d of %d spells, %d of %d points'):fmt(ui.draft:len(), blu.get_slot_count(), points, max));

        -- The trait column gives way on narrow windows so the stats stay readable..
        local room    = vc.avail_w() / vc.scale();
        local trait_w = math.max(80, math.min(170, room - 450));
        local stats_x = 262 + trait_w + 5;

        column_titles({ { 10, 'Pts' }, { 33, 'Spell' }, { 200, 'Trait Pts' }, { 267, 'Trait' }, { stats_x + 5, 'Stats' } });
        pane('draftpane', 0, INFO_H + 112, function ()
            for _, id in ipairs(ui.draft) do
                local spell = data.spells[id];
                local cat   = spell ~= nil and data.traits[spell.cat] or nil;
                local cols  = T{
                    { 6, spell ~= nil and tostring(spell.points) or '?', C.teal },
                    { 205, trait_points(spell), C.teal },
                    { 262, vc.fit_text(cat ~= nil and cat.name or '', vc.z(trait_w)), C.mute },
                    { stats_x, vc.fit_text(spell ~= nil and spell.stats or '', vc.z(room - stats_x - 24)), C.text },
                };
                if (spell_row(('draft%d'):fmt(id), id, blu.get_spell_name(id), MENU_TEXT, 28, cols, true)) then
                    break;
                end
            end
        end);

        if (vc.button('Apply', 'primary', 90) and blu.loader == nil) then
            blu.load_spells(ui.draft);
        end
        imgui.SameLine();
        if (vc.button('Revert', nil, 80)) then
            revert_draft();
        end
        imgui.SameLine();
        if (vc.button('Clear', nil, 80)) then
            ui.draft = T{ };
        end

        ui.info_reserve = 72;
        render_spell_info();
        render_sets();
    imgui.EndGroup();
end

--[[
* Renders the spells and tiers of the selected trait.
*
* @param {table} cat - The trait category.
--]]
local function render_trait_details(cat)
    local catid = 0;
    for k, v in pairs(data.traits) do
        if (v == cat) then
            catid = k;
        end
    end

    local result = calc_traits(ui.draft)[catid];
    local points = result ~= nil and result.points or 0;

    imgui.Dummy({ 0, vc.z(2) });
    imgui.Indent(vc.z(8));
    imgui.TextColored(C.teal, cat.name);
    imgui.TextColored(C.dim, ('Your selected spells give %d trait point(s).'):fmt(points));

    local top, most = get_max_tier(cat);
    if (cat.tiers:len() > 0) then
        imgui.TextColored(C.gold, ('Max on CatsEye %d: %s (%d trait points from every available spell)'):fmt(LEVEL_CAP, top ~= nil and top.name or 'None', most));
    end
    imgui.Dummy({ 0, vc.z(4) });

    if (cat.tiers:len() == 0) then
        imgui.TextColored(C.gold, 'No tier data is available for this trait.');
    else
        imgui.Columns(3, 'tiercols', false);
        imgui.SetColumnWidth(0, vc.z(170));
        imgui.SetColumnWidth(1, vc.z(60));
        imgui.TextColored(C.dim, 'Tier');
        imgui.NextColumn();
        imgui.TextColored(C.dim, 'Needs');
        imgui.NextColumn();
        imgui.TextColored(C.dim, 'Bonus');
        imgui.NextColumn();
        cat.tiers:ieach(function (t)
            local color = points >= t.points and C.teal or (t.points <= most and C.text or C.mute);
            imgui.TextColored(color, t.name);
            imgui.NextColumn();
            imgui.TextColored(color, ('%d pts'):fmt(t.points));
            imgui.NextColumn();
            imgui.TextColored(color, t.effect);
            if (t == top) then
                imgui.SameLine();
                imgui.TextColored(C.gold, '  Max');
            elseif (t.points > most) then
                imgui.SameLine();
                imgui.TextColored(C.mute, '  Out of reach');
            end
            imgui.NextColumn();
        end);
        imgui.Columns(1);
    end
    imgui.Dummy({ 0, vc.z(6) });
    imgui.Unindent(vc.z(8));

    -- Collect the spells of this trait..
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local res    = AshitaCore:GetResourceManager();
    local level  = blu.get_level();
    local spells = T{ };
    local capped = T{ };
    for id, spell in pairs(data.spells) do
        local r = res:GetSpellById(id + 512);
        if (spell.cat == catid and r ~= nil) then
            local need  = r.LevelRequired[17];
            local entry = T{ id = id, name = r.Name[1], level = need, data = spell,
                             known = player:HasSpell(id + 512), usable = player:HasSpell(id + 512) and need <= level };
            if (need >= 1 and need <= LEVEL_CAP) then
                spells:append(entry);
            else
                capped:append(entry);
            end
        end
    end
    local by_name = function (a, b)
        return a.name < b.name;
    end;
    table.sort(spells, by_name);
    table.sort(capped, by_name);

    column_titles({ { 8, 'Spell' }, { 195, 'Lv' }, { 235, 'Set' }, { 280, 'Trait' }, { 335, 'Status' } });

    spells:ieach(function (v)
        local on = ui.draft:hasval(v.id);

        local status, status_color = 'Known', C.text;
        if (ui.current:hasval(v.id)) then
            status, status_color = 'Set', C.teal;
        elseif (not v.known) then
            status, status_color = 'Not learned', C.bad;
        elseif (not v.usable) then
            status, status_color = 'Level too high', C.mute;
        end

        local cols = T{
            { 195, tostring(v.level), C.text },
            { 235, tostring(v.data.points), C.text },
            { 280, ('+%d'):fmt(v.data.weight), C.text },
            { 335, status, status_color },
        };
        local color = (not v.usable) and MENU_OFF or (on and MENU_TEXT or MENU_IDLE);
        spell_row(('trait%d'):fmt(v.id), v.id, v.name, color, 8, cols, v.usable);
    end);

    -- Spells above the level cap, kept apart so they are not mistaken for options..
    if (capped:len() > 0) then
        imgui.Dummy({ 0, vc.z(MENU_ROW_H * 2) });
        imgui.Indent(vc.z(8));
        imgui.TextColored(C.gold, ('Not available on CatsEye %d server'):fmt(LEVEL_CAP));
        imgui.Unindent(vc.z(8));
        imgui.Dummy({ 0, vc.z(4) });

        capped:ieach(function (v)
            local cols = T{
                { 195, tostring(v.level), MENU_OFF },
                { 235, tostring(v.data.points), MENU_OFF },
                { 280, ('+%d'):fmt(v.data.weight), MENU_OFF },
            };
            spell_row(('capped%d'):fmt(v.id), v.id, v.name, MENU_OFF, 8, cols, false);
        end);
    end
end

--[[
* Renders the trait search page.
--]]
local function render_page_search()
    vc.title('Trait Search', 'Find the spells that build a trait');
    render_lock();
    render_status();

    imgui.BeginGroup();
        vc.search_box('##traitfilter', ui.trait_filter, 'Search traits', 230);
        ui.trait_type = type_dropdown('##traittype', 230, ui.trait_type) or ui.trait_type;
        pane('traitlist', 230, 8, function ()
            local filter = ui.trait_filter[1];
            TRAITS:ieach(function (v)
                local effects = '';
                v.tiers:ieach(function (t)
                    effects = effects .. ' ' .. t.effect;
                end);
                if (is_type(v, ui.trait_type) and matches(filter, (v.name .. ' ' .. v.keywords .. effects):lower())) then
                    if (imgui.Selectable(('  %s'):fmt(v.name), ui.trait_selected == v)) then
                        ui.trait_selected = v;
                    end
                end
            end);
        end);
    imgui.EndGroup();
    imgui.SameLine();

    imgui.BeginGroup();
    pane('traitdetails', 0, INFO_H + 14, function ()
        if (ui.trait_selected ~= 0) then
            render_trait_details(ui.trait_selected);
        else
            imgui.Dummy({ 0, vc.z(4) });
            imgui.Indent(vc.z(8));
            imgui.TextColored(C.dim, 'Pick a trait to see its spells and tiers.');
            imgui.Unindent(vc.z(8));
        end
    end);
    ui.info_reserve = 8;
    render_spell_info();
    imgui.EndGroup();
end

--[[
* Renders the settings page.
--]]
local function render_page_settings()
    vc.title('Settings');
    render_lock();

    vc.section('SET POINTS');
    vc.label_row('Bonus set points', 220);
    local bonus = vc.slider('bonus', ui.config.bonus_points, 0, 35, 1, '%d', 220);
    if (bonus ~= nil and bonus ~= ui.config.bonus_points) then
        ui.config.bonus_points = bonus;
        settings.save();
    end
    vc.note('Used until you open the game\'s blue magic menu, which gives the real limit. Assimilation merits add up to 10 and Boruko adds up to 25.');

    vc.section('TRAIT DATA');
    vc.note('Spell traits, trait points and stats come from the game\'s own help text. Tier thresholds follow the game menu (8/16/24). The bonus each tier gives comes from LandSandBoat and may differ on CatsEye.');
end

local PAGES = T{
    spells = render_page_spells,
    search = render_page_search,
    settings = render_page_settings,
};

--[[
* Renders the list of pages.
*
* @param {table} nav - The sidebar builder.
--]]
local function render_sidebar(nav)
    local st = ui.state;
    if (nav.head('list', 'Spells', st.page == 'spells')) then
        st.page = 'spells';
    end
    if (nav.head('search', 'Trait Search', st.page == 'search')) then
        st.page = 'search';
    end
    nav.gap();
    if (nav.head('gear', 'Settings', st.page == 'settings')) then
        st.page = 'settings';
    end
end

--[[
* Renders the window.
--]]
function ui.render()
    if (not ui.state.open[1]) then
        if (ui.holding) then
            restore_game_windows();
        end
        return;
    end

    load_menu_font();

    -- Keep the set spells current without reading them every frame..
    local now = os.clock();
    if (now >= ui.refresh) then
        ui.refresh = now + 0.5;
        ui.current = T{ };
        blu.get_spells():ieach(function (id)
            if (id ~= 0) then
                ui.current:append(id);
            end
        end);
    end

    ui.lock_left = blu.get_lock_left();

    -- Open above every other window..
    if (ui.raise) then
        ui.raise = false;
        imgui.SetNextWindowFocus();
    end

    vc.window(ui.state, {
        id      = 'blusets',
        title   = 'BluSets',
        size    = { 1460, 860 },
        min     = { 1190, 840 },
        pages   = PAGES,
        sidebar = render_sidebar,
        scaler  = true,
        header_right = function ()
            if (ui.lock_left > 0) then
                return ('Spells locked %s'):fmt(get_lock_text()), C.gold;
            end
            return 'Spells ready', C.teal;
        end,
        on_scale = function (scale)
            ui.config.ui_scale = scale;
            settings.save();
        end,
    });
end

return ui;
