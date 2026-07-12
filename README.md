# Frostfall Homestead

A **Whiteout Survival–style** winter city-builder for Godot 4. Command a frozen settlement: feed the furnace, assign survivors, collect production bubbles, endure blizzards, and grow Frostfall into a stormproof city.

## Play

| Mode | How |
|------|-----|
| **Desktop** | Open this folder in Godot 4.6+ and press **F5** |
| **Web** | Push to `main` deploys GitHub Pages via Actions |

```bash
godot --path .
```

## Core loop (Whiteout-inspired)

1. **Collect bubbles** — production accumulates on buildings; tap the green LOOT bubble or **Collect** / **C**
2. **Feed the furnace** — stoke with wood/coal from Furnace Hall; heat is life
3. **Assign survivors** — People tab; idle hands produce nothing; sick survivors work poorly
4. **Build the city** — Lumber, Farm, Water, Hunter, Workshop, Cookhouse, Warehouse, Infirmary, Watchtower…
5. **Survive storms** — calendar blizzards with warnings; stock fuel before whiteouts
6. **Clear missions** — five chapters of survival goals to victory

## Features

- **13 buildings** with upgrade paths, orders, and readiness
- **Named survivors** with health, jobs, and recruitment
- **Continuous production bubbles** + storage caps (Warehouse)
- **Furnace fuel** + heat drain scaled by season and storms
- **Storm calendar** with gale/whiteout intensity and watchtower intel
- **Choice events**, expeditions, map landmarks
- **Offline catch-up** when loading a save
- **Save / auto-save**, pause, 0.5×–3× speed
- **Mobile-first HUD** — top resources, furnace meters, mission strip, bottom nav, building sheet
- **Polish** — floating collect text, pulse bubbles, storm snow, UI SFX, toasts

## Controls

| Input | Action |
|-------|--------|
| Tap building | Select / collect if bubbles ready |
| **C** | Collect all bubbles |
| **P** | Pause |
| **1 / 2 / 3** | Speed |
| **WASD** / arrows | Pan map (Shift = faster) |
| **Esc** | Close menus / cancel place |
| Bottom nav | Build · People · Missions · Collect · More |

## Victory & defeat

- **Victory**: complete Chapter 5 missions, day 14+, settlement power 180+
- **Defeat**: morale collapse, total resource failure, or dead furnace + broken spirits

## Project layout

```
scripts/GameState.gd      # Simulation (save v3)
scripts/Main.gd           # Whiteout-style UI
scripts/SnowOverlay.gd    # Storm-aware snow
scripts/FloatingText.gd   # Collect popups
scenes/Main.tscn
assets/                   # Kenney CC0 + custom sheets
```

## Save data

`user://frostfall_save.json` — city state, layout, survivors, bubbles, storm calendar.

## Assets

Kenney Tiny Town, Tiny Ski, UI Pack, Game Icons — **CC0**. Custom building/map sheets in `assets/building_upgrades/` and `assets/map_details/`.

## License

Game code: use freely for this project. Third-party assets retain their licenses (Kenney CC0).
