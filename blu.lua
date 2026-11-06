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
local chat = require('chat');
local ffi = require('ffi');

-- FFI Prototypes
ffi.cdef[[
    /**
     * Extended equip packet sender. Used for BLU spells, PUP attachments, etc.
     *
     * @param {uint8_t} isSubJob - Flag if the used job is currently subbed or not. (ie. If using BLU, is BLU subbed?)
     * @param {uint16_t} jobType - Flag used for the job packet type. (BLU = 0x1000, PUP = 0x1200)
     * @param {uint16_t} index - The index of the slot being manipulated. (ie. The BLU spell slot.)
     * @param {uint8_t} id - The id of the spell, attachment, etc. being set. (BLU spells are id - 512.)
     * @return {uint8_t} 1 on success, 0 otherwise.
     * @note
     *  This calls the in-game function that is used to send the 0x102 packets.
     */
    typedef uint8_t (__cdecl *equipex_t)(uint8_t isSubJob, uint16_t jobType, uint16_t index, uint8_t id);

    // Packet: 0x0102 - Extended Equip (Client To Server)
    typedef struct packet_equipex_c2s_t {
        uint16_t    IdSize;             /* Packet id and size. */
        uint16_t    Sync;               /* Packet sync count. */
        uint8_t     SpellId;            /* If setting a spell, this is set to the spell id being placed in a 'Spells' entry. If unsetting, it is set to 0. */
        uint8_t     Unknown0000;        /* Forced to 0 by the client. */
        uint16_t    Unknown0001;        /* Unused. */
    
        /**
         * The following data is job specific, this is how it is defined for BLU.
         */
    
        uint8_t     JobId;              /* Set to 0x10, BLU's job id. */
        uint8_t     IsSubJob;           /* Flag set if BLU is currently the players sub job. */
        uint16_t    Unknown0002;        /* Unused. (Padding) */
        uint8_t     Spells[20];         /* Array of the BLU spell slots. */
        uint8_t     Unknown0003[132];   /* Unused. */
    } packet_equipex_c2s_t;
]];

-- Blue Mage Helper Library
local blu = T{
    offset  = ffi.cast('uint32_t*', ashita.memory.find('FFXiMain.dll', 0, 'C1E1032BC8B0018D????????????B9????????F3A55F5E5B', 10, 0)),
    points  = ffi.cast('uint8_t***', ashita.memory.find('FFXiMain.dll', 0, 'A1????????33C98A4E5E33D28A565D5F5E8950148948185B83C414C20400', 1, 0)),
    equipex = ffi.cast('equipex_t', ashita.memory.find('FFXiMain.dll', 0, '8B0D????????81EC9C00000085C95356570F??????????8B', 0, 0)),

    --[[
    Packet Sender Mode

    Sets the mode that will be used when queueing and sending packets by blusets.

        safe - Uses the games actual functions to rate limit and send the packet properly.
        fast - Uses custom injected packets with custom rate limiting to bypass the internal client buffer limit.
    --]]
    mode = 'safe',

    -- The minimum delay, in seconds, between packet sends when loading a spell set.
    delay = 0.75,

    -- The state of the spell set currently being loaded. (nil when idle.)
    loader = nil,

    -- The result of the last finished spell set load.
    last_result = nil,

    -- The time the last spell change was sent. Blue magic cannot be cast for LOCK_SECONDS after each change.
    last_change = nil,
    LOCK_SECONDS = 60,
};

-- Spell set loader tuning..
local LOADER_TIMEOUT    = 3.0;  -- Seconds to wait for the server to confirm a change.
local LOADER_MAX_TRIES  = 3;    -- Attempts for a single spell (or unset) before giving up on it.

--[[
* Returns if the players main job is BLU.
*
* @return {boolean} True if BLU main, false otherwise.
--]]
function blu.is_blu_main()
    return AshitaCore:GetMemoryManager():GetPlayer():GetMainJob() == 16;
end

--[[
* Returns if the players sub job is BLU.
*
* @return {boolean} True if BLU sub, false otherwise.
--]]
function blu.is_blu_sub()
    return AshitaCore:GetMemoryManager():GetPlayer():GetSubJob() == 16;
end

--[[
* Returns the number of available BLU points.
*
* @return {number} The number of available BLU points.
--]]
function blu.get_available_points()
    local max = blu.points[0][0][0x18];
    if (max > 0) then
        return max - blu.points[0][0][0x14];
    end
    return 0;
end

--[[
* Returns the total number of spent BLU points.
*
* @return {number} The number of spent BLU points.
--]]
function blu.get_spent_points()
    return blu.points[0][0][0x14];
end

--[[
* Returns the total number of available BLU points.
*
* @return {number} The number of available BLU points.
--]]
function blu.get_max_points()
    return blu.points[0][0][0x18];
end

--[[
* Returns the raw buffer used in BLU spell packets.
*
* @return {number} The current BLU raw buffer pointer.
* @note
*   On private servers, there is a rare chance this buffer is not properly updated immediately until you open an
*   equipment menu or open the BLU set spells window. Because of this, you may send a bad job id for the packets
*   that rely on this buffers data if used directly.
--]]
function blu.get_blu_buffer_ptr()
    local ptr = ashita.memory.read_uint32(AshitaCore:GetPointerManager():Get('inventory'));
    if (ptr == 0) then
        return 0;
    end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then
        return 0;
    end
    return ptr + blu.offset[0] + (blu.is_blu_main() and 0x00 or 0x9C);
end

--[[
* Returns the table of current set BLU spells.
*
* @return {table} The current set BLU spells.
--]]
function blu.get_spells()
    local ptr = ashita.memory.read_uint32(AshitaCore:GetPointerManager():Get('inventory'));
    if (ptr == 0) then
        return T{ };
    end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then
        return T{ };
    end
    return T(ashita.memory.read_array((ptr + blu.offset[0]) + (blu.is_blu_main() and 0x04 or 0xA0), 0x14));
end

--[[
* Returns the table of current set BLU spells names.
*
* @return {table} The current set BLU spells names.
--]]
function blu.get_spells_names()
    return blu.get_spells():map(function (v)
        if (v == 0) then return ''; end
        local spell = AshitaCore:GetResourceManager():GetSpellById(v + 512);
        if (spell ~= nil) then
            return spell.Name[1];
        end
        return '';
    end);
end

--[[
* Builds an unset packet for the given spell slots.
*
* @param {table} slots - Table of slot index to the spell id currently in that slot.
* @return {string} The raw packet data.
*
* The server unsets every slot that is populated in the packet, so one packet can clear any number of spells. The
* job header is always written here instead of being copied from the BLU buffer, since that header can be stale.
--]]
local function build_unset_packet(slots)
    local eqex = ffi.new('packet_equipex_c2s_t', {
        0x5302, 0x0000,
        0,
        0, 0,
        0x10, blu.is_blu_main() == true and 0 or 1,
        0
    });

    for slot, id in pairs(slots) do
        eqex.Spells[slot - 1] = id;
    end

    return ffi.string(eqex, ffi.sizeof('packet_equipex_c2s_t'));
end

--[[
* Unsets the given spell slots.
*
* @param {table} slots - Table of slot index to the spell id currently in that slot.
*
* Safe mode uses the in-game packet queue, fast mode injects the packet to send it as soon as possible.
--]]
local function unset_spells(slots)
    local data = build_unset_packet(slots);

    if (blu.mode == 'fast') then
        AshitaCore:GetPacketManager():AddOutgoingPacket(0x102, data:totable());
        return;
    end

    AshitaCore:GetPacketManager():QueuePacket(0x102, 0xA4, 0x00, 0x00, 0x00, function (ptr)
        ffi.copy(ffi.cast('uint8_t*', ptr) + 0x04, ffi.cast('const uint8_t*', data) + 0x04, 0xA0);
    end);
end

--[[
* Sets a BLU spell for the give slot index. (safe)
*
* @param {number} index - The slot index to set. (1 to 10)
* @param {number} id - The spell id to set. (0 if unsetting.)
*
* Uses actual client function used to set BLU spells to safely and properly queue the packet.
*
* @return {boolean} True if the client queued the packet. It refuses silently when its BLU buffer is out of date.
--]]
local function safe_set_spell(index, id)
    return blu.equipex(blu.is_blu_main() == true and 0 or 1, 0x1000, index - 1, id) ~= 0;
end

--[[
* Sets a BLU spell for the give slot index. (unsafe)
*
* @param {number} index - The slot index to set.
* @param {number} id - The spell id to set. (0 if unsetting.)
*
* Uses custom packet injection to queue the set spell packet as soon as possible.
--]]
local function unsafe_set_spell(index, id)
    -- Prepare the initial packet data..
    local eqex = ffi.new('packet_equipex_c2s_t', {
        0x5302, 0x0000,
        0,
        0, 0,
        0x10, blu.is_blu_sub() == true and 1 or 0,
        0
    });

    -- Handle the spell information accordingly..
    if (id == 0) then
        -- Unsetting..
        eqex.SpellId = 0;
        eqex.Spells[index - 1] = blu.get_spells()[index];
    else
        -- Setting..
        eqex.SpellId = id;
        eqex.Spells[index - 1] = id;
    end

    -- Convert and send the packet..
    local packet = ffi.string(eqex, ffi.sizeof('packet_equipex_c2s_t')):totable();
    AshitaCore:GetPacketManager():AddOutgoingPacket(0x102, packet);
end

--[[
* Queues the packet required to unset all BLU spells.
--]]
function blu.reset_all_spells()
    local slots = T{ };
    blu.get_spells():ieach(function (v, k)
        if (v ~= 0) then
            slots[k] = v;
        end
    end);
    unset_spells(slots);
end

--[[
* Queues the packet required to set a BLU spell. (Or unset.)
*
* @param {number} index - The slot index to set.
* @param {number} id - The spell id to set. (0 if unsetting.)
--]]
function blu.set_spell(index, id)
    if (index <= 0 or index > 20) then
        print(chat.header(addon.name):append(chat.error('Failed to set spell; invalid index given. (Params - Index: %d, Id: %d)')):fmt(index, id));
        return;
    end

    -- Check if the spell is set elsewhere already..
    local spells = blu.get_spells();
    if (id ~= 0 and spells:hasval(id)) then
        print(chat.header(addon.name):append(chat.error('Failed to set spell; spell is already assigned. (Params - Index: %d, Id: %d)')):fmt(index, id));
        return;
    end

    -- Check if the spell is being unset and has a spell in the desired slot..
    local spell = spells[index];
    if (id == 0 and (spell == nil or spell == 0)) then
        return;
    end

    -- Set the spell..
    if (blu.mode == 'fast' or not safe_set_spell(index, id)) then
        unsafe_set_spell(index, id);
    end
end

--[[
* Sets the given slot index to the spell matching the given name. If no name is given, the slot is unset.
*
* @param {number} index - The slot index to set the spell into.
* @param {string|nil} name - The name of the spell to set. (nil if unsetting spell.)
--]]
function blu.set_spell_by_name(index, name)
    -- Unset the spell if no name is given..
    if (name == nil or name == '') then
        blu.set_spell(index, 0);
        return;
    end

    -- Obtain the spell resource info..
    local spell = AshitaCore:GetResourceManager():GetSpellByName(name, 0);
    if (spell == nil) then
        print(chat.header(addon.name):append(chat.error('Failed to set spell; invalid spell name given. (Params - Index: %d, Name: %s)')):fmt(index, name));
        return;
    end

    -- Ensure the spell is a BLU magic spell..
    if (spell.Index < 512 or spell.Index > 1024) then
        print(chat.header(addon.name):append(chat.error('Failed to set spell; invalid spell given. (Not Blue Magic) (Params - Index: %d, Name: %s)')):fmt(index, name));
        return;
    end

    -- Set the spell..
    blu.set_spell(index, spell.Index - 512);
end

--[[
* Returns if the player currently has the given job trait.
*
* The client keeps the trait bits the server last sent, 0x8AE104 bytes past the equipex function. (32 bytes.)
*
* @param {number} id - The trait id.
* @return {boolean} True if the trait is active.
--]]
function blu.has_trait(id)
    local bits = ffi.cast('const uint8_t*', tonumber(ffi.cast('uint32_t', blu.equipex)) + 0x8AE104);
    return bit.band(bits[math.floor(id / 8)], bit.lshift(1, id % 8)) ~= 0;
end

--[[
* Returns the level the player has BLU at.
*
* @return {number} The BLU level, 0 if BLU is not the main or sub job.
--]]
function blu.get_level()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    if (blu.is_blu_main()) then
        return player:GetMainJobLevel();
    end
    if (blu.is_blu_sub()) then
        return player:GetSubJobLevel();
    end
    return 0;
end

--[[
* Returns the number of spell slots available at the players BLU level.
*
* @return {number} The number of spell slots.
--]]
function blu.get_slot_count()
    local level = blu.get_level();
    if (level == 0) then
        return 0;
    end
    return math.min(20, math.floor((level - 1) / 10) * 2 + 6);
end

--[[
* Returns the configuration folder that spell set files are stored within.
*
* @return {string} The spell set folder path.
--]]
function blu.get_sets_path()
    return ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'blusets');
end

--[[
* Returns the names of the saved spell sets.
*
* @return {table} The sorted spell set names.
--]]
function blu.list_sets()
    local names = T{ };
    local files = ashita.fs.get_dir(blu.get_sets_path(), '.*.txt', true);
    if (files ~= nil) then
        T(files):each(function (v)
            names:append((v:gsub('%.txt$', '')));
        end);
    end
    table.sort(names, function (a, b)
        return a:lower() < b:lower();
    end);
    return names;
end

--[[
* Reads the spell names stored in a saved spell set.
*
* @param {string} name - The spell set name.
* @return {table|nil} The spell names, one per slot. (Empty slots are empty strings.) nil on failure.
--]]
function blu.read_set(name)
    local f = io.open(blu.get_sets_path() .. name .. '.txt', 'r');
    if (f == nil) then
        return nil;
    end

    local spells = T{ };
    for line in f:lines() do
        spells:append((line:gsub('%s+$', '')));
    end
    f:close();

    return spells;
end

--[[
* Writes the given spell names to a spell set file.
*
* @param {string} name - The spell set name.
* @param {table} spells - The spell names to store.
* @return {boolean} True on success, false otherwise.
--]]
function blu.write_set(name, spells)
    local f = io.open(blu.get_sets_path() .. name .. '.txt', 'w+');
    if (f == nil) then
        return false;
    end
    f:write(spells:concat('\n'));
    f:close();
    return true;
end

--[[
* Returns the spell name for the given BLU spell id.
*
* @param {number} id - The spell id. (Offset by 512.)
* @return {string} The spell name.
--]]
function blu.get_spell_name(id)
    local spell = AshitaCore:GetResourceManager():GetSpellById(id + 512);
    if (spell ~= nil) then
        return spell.Name[1];
    end
    return ('Spell %d'):fmt(id);
end

--[[
* Converts spell names to BLU spell ids.
*
* @param {table} names - The spell names. (Empty names are ignored.)
* @return {table} The spell ids. (Offset by 512.)
* @return {table} The names that could not be resolved.
--]]
function blu.names_to_ids(names)
    local ids = T{ };
    local bad = T{ };

    T(names):ieach(function (v)
        if (v ~= '') then
            local spell = AshitaCore:GetResourceManager():GetSpellByName(v, 0);
            if (spell ~= nil and spell.Index >= 512 and spell.Index <= 1024) then
                ids:append(spell.Index - 512);
            else
                bad:append(v);
            end
        end
    end);

    return ids, bad;
end

--[[
* Reports the result of a finished spell set load to the chat log.
*
* @param {table} l - The finished loader state.
--]]
local function loader_report(l)
    local cur    = T(l.current);
    local failed = T{ };

    l.target:ieach(function (id)
        if (not cur:hasval(id)) then
            failed:append(('%s (%s)'):fmt(blu.get_spell_name(id), l.reasons[id] or 'load stopped'));
        end
    end);
    l.skipped:ieach(function (v)
        failed:append(v);
    end);

    blu.last_result = T{ failed = failed, error = l.error };

    if (l.error ~= nil) then
        print(chat.header(addon.name):append(chat.error('Spell set load stopped: ')):append(chat.warning(l.error)));
    end

    if (failed:len() == 0) then
        print(chat.header(addon.name):append(chat.message('Finished setting blue magic spells; all ')):append(chat.success(tostring(l.target:len()))):append(chat.message(' spells confirmed.')));
        return;
    end

    print(chat.header(addon.name):append(chat.error(('Finished setting blue magic spells; %d spell(s) are missing:'):fmt(failed:len()))));
    failed:ieach(function (v)
        print(chat.header(addon.name):append(chat.warning(v)));
    end);
end

--[[
* Stops the current spell set load and reports the result.
*
* @param {string|nil} err - The reason the load was stopped, nil if it finished normally.
--]]
function blu.loader_finish(err)
    local l = blu.loader;
    if (l == nil) then
        return;
    end
    l.error = err;
    blu.loader = nil;
    loader_report(l);
end

--[[
* Starts loading the given spells.
*
* The spells are treated as a set; a spell that is already set stays where it is. Spells that do not belong are
* unset first and each missing spell is then set one at a time, waiting for the server to confirm each change.
*
* @param {table} ids - The spell ids to set. (Offset by 512.)
* @return {boolean} True if the load was started, false otherwise.
--]]
function blu.load_spells(ids)
    if (blu.loader ~= nil) then
        print(chat.header(addon.name):append(chat.error('A spell set is already being loaded.')));
        return false;
    end

    local level = blu.get_level();
    if (level == 0) then
        print(chat.header(addon.name):append(chat.error('Blue Mage must be your main or sub job to set spells.')));
        return false;
    end

    local player  = AshitaCore:GetMemoryManager():GetPlayer();
    local target  = T{ };
    local skipped = T{ };
    local limit   = blu.get_slot_count();

    -- Remove anything the server is guaranteed to refuse..
    T(ids):ieach(function (id)
        local spell = AshitaCore:GetResourceManager():GetSpellById(id + 512);
        if (target:hasval(id)) then
            return;
        end
        if (spell == nil) then
            skipped:append(('%s (unknown spell)'):fmt(blu.get_spell_name(id)));
        elseif (not player:HasSpell(id + 512)) then
            skipped:append(('%s (not learned)'):fmt(blu.get_spell_name(id)));
        elseif (spell.LevelRequired[17] > level) then
            skipped:append(('%s (requires level %d)'):fmt(blu.get_spell_name(id), spell.LevelRequired[17]));
        elseif (target:len() >= limit) then
            skipped:append(('%s (no free spell slot)'):fmt(blu.get_spell_name(id)));
        else
            target:append(id);
        end
    end);

    blu.last_result = nil;
    blu.loader = T{
        target      = target,
        skipped     = skipped,
        current     = blu.get_spells(),
        limit       = limit,
        tries       = T{ },
        reasons     = T{ },
        unset_tries = 0,
        waiting     = false,
        deadline    = 0,
        next_send   = 0,
    };
    return true;
end

--[[
* Returns the progress of the current spell set load.
*
* @return {number} The number of target spells that are confirmed set.
* @return {number} The number of target spells.
--]]
function blu.get_load_progress()
    local l = blu.loader;
    if (l == nil) then
        return 0, 0;
    end

    local done = 0;
    local cur  = T(l.current);
    l.target:ieach(function (id)
        if (cur:hasval(id)) then
            done = done + 1;
        end
    end);
    return done, l.target:len();
end

--[[
* Sends the next change the current spell set load needs. Finishes the load when nothing is left to do.
*
* @param {table} l - The loader state.
--]]
local function loader_step(l)
    -- Unset everything that does not belong in one packet..
    local extras = T{ };
    for x = 1, 20 do
        local id = l.current[x] or 0;
        if (id ~= 0 and not l.target:hasval(id)) then
            extras[x] = id;
        end
    end

    if (next(extras) ~= nil) then
        l.unset_tries = l.unset_tries + 1;
        if (l.unset_tries > LOADER_MAX_TRIES) then
            blu.loader_finish('The server did not confirm unsetting the old spells.');
            return;
        end
        unset_spells(extras);
        blu.last_change = os.clock();
        l.waiting  = true;
        l.deadline = os.clock() + LOADER_TIMEOUT;
        return;
    end

    -- Set the next missing spell..
    local cur = T(l.current);
    for _, id in ipairs(l.target) do
        if (not cur:hasval(id) and l.reasons[id] == nil) then
            local slot = 0;
            for x = 1, l.limit do
                if ((l.current[x] or 0) == 0) then
                    slot = x;
                    break;
                end
            end

            if (slot == 0) then
                l.reasons[id] = 'no free spell slot';
            elseif ((l.tries[id] or 0) >= LOADER_MAX_TRIES) then
                l.reasons[id] = l.timed_out == id and 'no response from the server' or 'rejected by the server; not enough set points?';
            else
                l.tries[id] = (l.tries[id] or 0) + 1;
                l.pending   = id;
                if (blu.mode == 'fast' or not safe_set_spell(slot, id)) then
                    unsafe_set_spell(slot, id);
                end
                blu.last_change = os.clock();
                l.waiting  = true;
                l.deadline = os.clock() + LOADER_TIMEOUT;
                return;
            end
        end
    end

    blu.loader_finish();
end

--[[
* Advances the current spell set load. Called every frame.
--]]
function blu.loader_tick()
    local l = blu.loader;
    if (l == nil) then
        return;
    end

    local now = os.clock();
    if (l.waiting) then
        if (now < l.deadline) then
            return;
        end

        -- No confirmation arrived; fall back to what the client currently believes is set..
        l.waiting   = false;
        l.timed_out = l.pending;
        l.current   = blu.get_spells();
    end

    if (now >= l.next_send) then
        loader_step(l);
    end
end

--[[
* Handles a spell change leaving the client, including changes made in the game menu. (Packet 0x102)
*
* @param {string} data - The raw packet data.
--]]
function blu.on_job_change(data)
    if (data:byte(0x08 + 1) == 0x10) then
        blu.last_change = os.clock();
    end
end

--[[
* Handles the server confirming the players BLU spells. (Packet 0x044)
*
* The server sends this packet after each 0x102 packet it handles, holding every set spell.
*
* @param {string} data - The raw packet data.
--]]
function blu.on_job_data(data)
    local l = blu.loader;
    if (l == nil or data:byte(0x04 + 1) ~= 0x10) then
        return;
    end

    l.current   = T{ data:byte(0x08 + 1, 0x08 + 20) };
    l.waiting   = false;
    l.next_send = os.clock() + blu.delay;
end

--[[
* Returns the seconds left before blue magic can be cast again.
*
* @return {number} The seconds left, 0 when spells can be cast.
--]]
function blu.get_lock_left()
    local left = 0;
    if (blu.last_change ~= nil) then
        left = math.max(0, blu.last_change + blu.LOCK_SECONDS - os.clock());
    end

    -- The client knows better if it is tracking the recast of every set spell..
    local recast = AshitaCore:GetMemoryManager():GetRecast();
    local lowest = nil;
    blu.get_spells():ieach(function (id)
        if (id ~= 0) then
            local timer = recast:GetSpellTimer(id + 512) / 60;
            lowest = lowest == nil and timer or math.min(lowest, timer);
        end
    end);
    return math.max(left, lowest or 0);
end

-- Return the library table..
return blu;