# BluSets for Ashita v4 / VanaCore

Manage blue magic spells with a window and slash commands. Made for CatsEyeXI, based on atom0s' blusets addon.

## Install

Put this folder in `addonslusets`, then in game:

```
/addon load blusets
```

## Commands

- `/blusets` opens or closes the window. (`/bs` also works.)
- `/blusets load <set>` sets the spells of a saved set. `/blusets stop` stops a load.
- `/blusets help` lists every command.

## Window

The window is built on `vcmenu.lua`, the shared VanaCore menu library. Spell lists use bold shadowed text like the game menus.

- **Spells**: click a spell to read the game's information on it, and double click it (or use **Add** and **Remove**) to select it, then **Apply**. Saved sets load into the selection; nothing changes on your character until you apply. Under the list, Active Traits shows trait points, tier and bonus for the selected spells or the spells on your character; hover a trait for the next tier that would add to it. Both views list your job traits; where a job and your spells give the same trait, the stronger tier is shown.
- **Trait Search**: search a trait (`accuracy`, `physical`, `magic`..) or pick a type from the dropdown to see its spells, set cost, trait points and tiers. The spell list on the Spells page has type and trait dropdowns too.
- **Settings**: bonus set points on top of your level amount, for your Assimilation merits and Boruko bonus.

While the window is open, VanaCore's `menus.ontop` setting is off so the game's windows stay behind it. Your setting is put back when the window closes.

The header shows when blue magic can be cast again after a spell change. (60 seconds.)

## How loading works

Each change waits for the server to confirm it (packet 0x044) before the next is sent. Spells already set stay set, and anything that could not be set is listed in the chat log with the reason. Each change restarts the 60 second blue magic recast on the server.

## Trait data

`data.lua` is generated. Each spell's trait, trait points and stats come from the game's own help text (`ROM/166/116.DAT`). Set costs come from the public CatsEye tables and BG-Wiki. Tier thresholds follow the game menu (8/16/24). The bonus each tier gives comes from stock LandSandBoat and may differ on CatsEye; a live Max MP test did not match exactly.

## License

GNU General Public License v3. See `LICENSE`.
