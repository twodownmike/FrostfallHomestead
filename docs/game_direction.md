# Frostfall Homestead

Frostfall Homestead is a mobile survival-settlement game inspired by the cold-pressure city loop of Whiteout Survival, but centered on homesteading instead of industrial apocalypse fantasy.

## Core Loop

1. Assign families to homestead jobs: woodlot, garden, well, workshop, cabin upkeep, root cellar, smokehouse, and coop.
2. Produce daily supplies while winter pressure consumes food, water, and firewood.
3. Upgrade buildings to improve production and worker capacity (construction/upgrade timers).
4. Send expeditions and scout map landmarks for seed, food, tools, and morale.
5. Keep morale and hearth heat high enough to survive deeper winter and complete chapter goals.

## Theme Pillars

- Homesteads, family labor, preserving food, seed saving, livestock, hand tools, and seasonal planning.
- Threats should feel grounded: blizzards, failed crops, illness, predators, broken wells, and supply shortages.
- Progression should grow from cabin cluster to durable valley settlement.

## Implemented Systems

- Save / load / auto-save (`user://frostfall_save.json`) with building layout.
- First-run tutorial with skip.
- Pause and time scale (0.5×–3×).
- Tile map placement, move mode, level-based sprites, construction progress badges.
- Root cellar (spoilage reduction), smokehouse (preserved food), chicken coop (food + morale).
- Seasonal progression (Early → Late Winter) with pressure scaling.
- Scripted choice events on days 3, 8, and 12.
- Victory (Chapter 5 goals + day 14 + power 160) and defeat screens.
- Population growth when stores and morale stay healthy.
- UI sound feedback (Kenney UI pack).

## Suggested Next Systems

- Animated workers and collection bubbles on the map.
- Livestock illness / fox raid micro-events with more choices.
- iOS / Android export presets, icons, splash screens, and safe-area tuning.
- Local multiplayer ghost settlements or daily challenge seeds.
- Accessibility: colorblind resource markers and scalable UI text.

## Asset Source

- Kenney Tiny Town: https://kenney.nl/assets/tiny-town (CC0)
- Kenney UI Pack: https://kenney.nl/assets/ui-pack (CC0)
- Kenney Game Icons: https://kenney.nl/assets/game-icons (CC0)
- Kenney Tiny Ski: https://kenney.nl/assets/tiny-ski (CC0)
- User-provided building upgrade sheet: `assets/building_upgrades/source_sheet.png`
- User-provided overworld map detail sheet: `assets/map_details/source_sheet.png`

## Visual Direction

- Cold survival-settlement tone: blue glass HUD, snow overlay, pale winter terrain, and high-contrast command panels.
- Mobile strategy readability: compact resource strip, strong action buttons, selected-building inspector, and large tap targets.
- Keep references to games like Whiteout Survival at the genre level only: polished survival HUD, winter atmosphere, and clear upgrade loops without copying protected layouts, logos, characters, or exact art treatment.

## Interaction Direction

- Tapping a building opens a contextual command panel with role, output, risk, condition, readiness, workers, and building-specific orders.
- Buildings accumulate readiness over daily cycles; ready buildings show a map badge so the world itself calls for attention.
- Construction and upgrades show progress badges on the map.
- Orders feel immediate and legible: costs on the button, rewards apply instantly, dispatch log confirms the result.
- Landmarks dim after scouting so the map communicates exploration state.
