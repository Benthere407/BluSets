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

addon.name      = 'blusets';
addon.author    = 'atom0s';
addon.version   = '2.1.1';
addon.desc      = 'Manage blue magic spells with a window and slash commands, for Ashita v4 / VanaCore (CatsEyeXI).';
addon.link      = 'https://github.com/Benthere407/BluSets';

require('common');
local blu = require('blu');
local chat = require('chat');
local ui = require('ui');

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/blusets', 'Opens or closes the BluSets window.' },
        { '/blusets help', 'Shows the addon help.' },
        { '/blusets list', 'Lists all available spell list files.' },
        { '/blusets load <file>', 'Loads the BLU spells from the given spell list file.' },
        { '/blusets stop', 'Stops a spell list that is currently loading.' },
        { '/blusets save <file>', 'Saves the current set BLU spells to the given spell list file.' },
        { '/blusets delete <file>', 'Deletes the given spell list file.' },
        { '/blusets (clear | reset | unset)', 'Unsets all currently set BLU spells.' },
        { '/blusets set <slot> <spell>', 'Sets the given slot to the given BLU spell by its id.' },
        { '/blusets setn <slot> <spell>', 'Sets the given slot to the given BLU spell by its name.' },
        { '/blusets mode [safe | fast]', 'Sets mode BluSets will use to send packets. (safe is default.)' },
        { '/blusets delay <amount>', 'Sets the minimum delay, in seconds, between packets that BluSets will use when loading sets.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Ensure the configuration folder exists..
    local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'blusets');
    if (not ashita.fs.exists(path)) then
        ashita.fs.create_dir(path);
    end

    ui.load();
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    blu.loader_finish('The addon was unloaded.');
    ui.unload();
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    blu.loader_tick();
    ui.render();
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    if (e.id == 0x0044) then
        blu.on_job_data(e.data);
    elseif (e.id == 0x000B) then
        blu.loader_finish('You left the zone.');
    end
end);

--[[
* event: packet_out
* desc : Event called when the addon is processing outgoing packets.
--]]
ashita.events.register('packet_out', 'packet_out_cb', function (e)
    if (e.id == 0x0102) then
        blu.on_job_change(e.data);
    end
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/blusets', '/bluesets', '/bluset', '/blueset', '/bs')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /blusets - Opens or closes the BluSets window.
    if (#args == 1) then
        ui.toggle();
        return;
    end

    -- Handle: /blusets help - Shows the addon help.
    if (#args >= 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /blusets list - Lists all available spell list files.
    if (#args >= 2 and args[2]:any('list')) then
        local sets = blu.list_sets();
        if (sets:len() > 0) then
            sets:each(function (v)
                print(chat.header(addon.name):append(chat.message('Found spell set file: ')):append(chat.success(v)));
            end);
            return;
        end

        print(chat.header(addon.name):append(chat.message('No saved spell lists found.')));
        return;
    end

    -- Handle: /blusets load <file> - Loads the BLU spells from the given spell list file.
    if (#args >= 3 and args[2]:any('load')) then
        local name = args:concat(' ', 3):gsub('.txt', ''):trim();
        local names = blu.read_set(name);
        if (names == nil) then
            print(chat.header(addon.name):append(chat.error('Failed to load spell list; file does not exist: ')):append(chat.warning(name)));
            return;
        end

        -- Report any spell names that can no longer be resolved..
        local ids, bad = blu.names_to_ids(names);
        bad:ieach(function (v)
            print(chat.header(addon.name):append(chat.error('Unknown spell in spell list: ')):append(chat.warning(v)));
        end);

        -- Apply the spell list..
        if (blu.load_spells(ids)) then
            print(chat.header(addon.name):append(chat.message('Setting blue magic from spell set; please wait..')));
        end
        return;
    end

    -- Handle: /blusets stop - Stops a spell list that is currently loading.
    if (#args >= 2 and args[2]:any('stop', 'cancel')) then
        blu.loader_finish('Stopped by the player.');
        return;
    end

    -- Handle: /blusets save <file> - Saves the current set BLU spells to the given spell list file.
    if (#args >= 3 and args[2]:any('save')) then
        local spells = blu.get_spells_names();

        local name = args:concat(' ', 3):gsub('.txt', ''):trim();
        if (not blu.write_set(name, spells)) then
            print(chat.header(addon.name):append(chat.error('Failed to open spell list file for writing.')));
            return;
        end

        print(chat.header(addon.name):append(chat.message('Saved spell list to: ')):append(chat.success(name)));
        return;
    end

    -- Handle: /blusets delete <file> - Deletes the given spell list file.
    if (#args >= 3 and args[2]:any('delete')) then
        local name = args:concat(' ', 3):gsub('.txt', ''):trim();
        local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'blusets');

        if (not ashita.fs.exists(path:append(name:append('.txt')))) then
            print(chat.header(addon.name):append(chat.error('Failed to delete spell list; file does not exist: ')):append(chat.warning(name)));
            return;
        end

        ashita.fs.remove(path:append(name:append('.txt')));

        print(chat.header(addon.name):append(chat.message('Deleted spell list file: ')):append(chat.success(name)));
        return;
    end

    -- Handle: /blusets (clear | reset | unset) - Unsets all currently set BLU spells.
    if (#args >= 2 and args[2]:any('clear', 'reset', 'unset')) then
        blu.reset_all_spells();

        print(chat.header(addon.name):append(chat.message('Blue magic spells reset.')));
        return;
    end

    -- Handle: /blusets set <slot> <spell> - Sets the given slot to the given BLU spell by its id.
    if (#args >= 4 and args[2]:any('set')) then
        blu.set_spell(args[3]:num(), args[4]:num_or(0));
        return;
    end

    -- Handle: /blusets setn <slot> <spell> - Sets the given slot to the given BLU spell by its name.
    if (#args >= 4 and args[2]:any('setn')) then
        blu.set_spell_by_name(args[3]:num(), args:concat(' ', 4));
        return;
    end

    -- Handle: /blusets mode [safe | fast] - Sets mode BluSets will use to send packets. (safe is default.)
    if (#args >= 2 and args[2]:any('mode')) then
        if (#args >= 3) then
            if (args[3]:any('fast')) then
                blu.mode = 'fast';
            else
                blu.mode = 'safe';
            end
        end

        print(chat.header(addon.name):append(chat.message('BluSets packet mode is set to: ')):append(chat.success(blu.mode)));
        return;
    end

    -- Handle: /blusets delay <amount> - Sets the delay, in seconds, between packets that BluSets will use when loading sets. (If safe mode is on, minimum is 1 second.)
    if (#args >= 3 and args[2]:any('delay')) then
        blu.delay = args[3]:num_or(1);
        if (blu.delay <= 0) then
            blu.delay = 1;
        end

        print(chat.header(addon.name):append(chat.message('BluSets packet delay set to: ')):append(chat.success(blu.delay)));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);