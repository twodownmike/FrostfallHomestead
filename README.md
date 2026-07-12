# Frostfall Homestead

A winter survival settlement game built in **Godot 4**. Guide a cold-valley homestead through blizzards, shortages, and hard choices — assign families, raise buildings, scout landmarks, and keep the hearth lit.

Play the live web build (GitHub Pages) after the latest `main` deploy, or run locally with Godot 4.6+.

## Core loop

1. **Assign workers** to woodlots, gardens, wells, workshops, and new homestead buildings.
2. **Produce supplies** while winter consumes food, water, and firewood every day.
3. **Build & upgrade** structures (with real construction timers) to grow capacity.
4. **Issue building orders** when readiness is high (READY badges on the map).
5. **Scout landmarks**, run expeditions, and survive chapter goals through Deep Winter.
6. **Win** by completing Chapter 5 goals (day 14+, power 160+) — or fall to frost and famine.

## Features

| System | Details |
|--------|---------|
| Buildings | Homestead, Woodlot, Kitchen Garden, Well, Workshop, **Root Cellar**, **Smokehouse**, **Chicken Coop** |
| Seasons | Early → Mid → Deep → Late Winter as days advance |
| Progression | 5 chapters, 16 survival goals, settlement power score |
| Decisions | Scripted choice events (travelers, blizzard prep, traders) |
| Meta | Save / load / auto-save, pause, 0.5×–3× speed, tutorial |
| Map | Scrollable snow map, place buildings, move plots, scout POIs |
| Platform | Desktop + mobile-friendly UI, Web export via GitHub Actions |

## Controls

| Input | Action |
|-------|--------|
| Mouse / touch | Pan map, select buildings, place structures |
| **WASD** / arrows | Pan map (Shift = faster) |
| **P** | Pause / resume |
| **1 / 2 / 3** | Set time scale |
| **Esc** | Cancel placement or close menus |
| Build menu | Place unlocked buildings on the map |
| Move | Relocate the selected building |

## Run locally

1. Install [Godot 4.6+](https://godotengine.org/) (4.7 works).
2. Open this folder as a project.
3. Press **F5** (main scene: `scenes/Main.tscn`).

```bash
godot --path . 
```

## Web export

```bash
godot --headless --path . --export-release "Web" build/web/index.html
```

Pushing to `main` runs `.github/workflows/pages.yml` and deploys the web build to GitHub Pages.

## Project layout

```
scripts/GameState.gd   # Simulation, goals, save/load, events
scripts/Main.gd        # UI, map, input, modals
scripts/SnowOverlay.gd # Falling snow
scripts/PolishedBackground.gd
scenes/Main.tscn
assets/                # Kenney packs + custom building/map art
docs/game_direction.md
```

## Assets & license

- [Kenney Tiny Town](https://kenney.nl/assets/tiny-town), [Tiny Ski](https://kenney.nl/assets/tiny-ski), [UI Pack](https://kenney.nl/assets/ui-pack), [Game Icons](https://kenney.nl/assets/game-icons) — **CC0**
- Custom building upgrade and map detail sheets under `assets/building_upgrades/` and `assets/map_details/`

## Save data

Saves are written to Godot user data:

`user://frostfall_save.json`

Includes resources, buildings, goals, chapter, layout positions, and tutorial progress. Auto-saves every 2 in-game days.
