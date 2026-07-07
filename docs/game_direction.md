# Frostfall Homestead

Frostfall Homestead is a mobile survival-settlement game inspired by the cold-pressure city loop of Whiteout Survival, but centered on homesteading instead of industrial apocalypse fantasy.

## Core Loop

1. Assign families to homestead jobs: woodlot, garden, well, workshop, and cabin upkeep.
2. Produce daily supplies while winter pressure consumes food, water, and firewood.
3. Upgrade buildings to improve production and worker capacity.
4. Send expeditions for seed, food, tools, and future map discoveries.
5. Keep morale and hearth heat high enough to survive deeper winter.

## Theme Pillars

- Homesteads, family labor, preserving food, seed saving, livestock, hand tools, and seasonal planning.
- Threats should feel grounded: blizzards, failed crops, illness, predators, broken wells, and supply shortages.
- Progression should grow from cabin cluster to durable valley settlement.

## Suggested Next Systems

- Save/load support with `ConfigFile` or JSON.
- Tutorial prompts for first-time mobile users.
- Build placement on a tile map.
- Livestock buildings: coop, dairy shed, smokehouse, root cellar.
- Seasonal events and choices with tradeoffs.
- iOS export presets, icons, splash screens, and safe-area tuning.

## Asset Source

- Kenney Tiny Town: https://kenney.nl/assets/tiny-town
- License: Creative Commons Zero, CC0
- Used for the current overworld terrain, cabin, garden, well, workshop, trees, paths, and fence sprites.
- Kenney UI Pack: https://kenney.nl/assets/ui-pack
- License: Creative Commons Zero, CC0
- Used for the current interface font and as the source pack for future panel/button art.
- Kenney Game Icons: https://kenney.nl/assets/game-icons
- License: Creative Commons Zero, CC0
- Used for action, assignment, and operation icons.
- Kenney Tiny Ski: https://kenney.nl/assets/tiny-ski
- License: Creative Commons Zero, CC0
- Used for expanded snowy terrain variation in the movable homestead map.
- User-provided building upgrade sheet: `assets/building_upgrades/source_sheet.png`
- Used for large level 1-3 building visuals on the map.
- User-provided overworld map detail sheet: `assets/map_details/source_sheet.png`
- Used for snowy roads, timber/stone/hunting nodes, camp POIs, cave POIs, and outpost markers.

## Visual Direction

- Cold survival-settlement tone: blue glass HUD, snow overlay, pale winter terrain, and high-contrast command panels.
- Mobile strategy readability: compact resource strip, strong action buttons, selected-building inspector, and large tap targets.
- Keep references to games like Whiteout Survival at the genre level only: polished survival HUD, winter atmosphere, and clear upgrade loops without copying protected layouts, logos, characters, or exact art treatment.

## Interaction Direction

- Tapping a building opens a contextual command panel with role, output, risk, condition, readiness, and building-specific orders.
- Buildings accumulate readiness over daily cycles; ready buildings show a map badge so the world itself calls for attention.
- Orders should feel immediate and legible: costs are shown on the button, rewards apply instantly, and the dispatch log confirms the result.
- Future passes should add animated workers, construction timers, collection bubbles, and temporary event choices so the map becomes the primary place to play.
- Map customization now supports a larger scrollable grid, move mode, relocated buildings, and level-based building sprite changes.
