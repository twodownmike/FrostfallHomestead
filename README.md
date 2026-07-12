# Frostfall Homestead

A **Whiteout Survival–style** winter city-builder for Godot 4.

Map-first mobile UI: slim resource chrome, big bottom dock, tap buildings to inspect, collect floating production bubbles, feed the furnace, and survive the whiteout.

## Play

| Mode | How |
|------|-----|
| Desktop | Open in Godot 4.6+ → **F5** |
| Web | Push to `main` deploys GitHub Pages |

```bash
godot --path .
```

## How it feels (Whiteout loop)

1. **City map is the main screen** — drag to pan, almost full-screen
2. **Top bar** — heat / fuel / morale + compact resources
3. **Tap a building** — bottom sheet slides up (stats, crew, upgrade, orders)
4. **Green + bubbles** — tap to collect production (or **Collect** / **C**)
5. **Bottom dock** — Build · People · Missions · Collect · More
6. **Mission pill** — current goal, tap to open missions
7. **Storm warnings** — stock fuel before gales/whiteouts

## Controls

| Input | Action |
|-------|--------|
| Drag map | Pan city |
| Tap building | Inspect / collect |
| **C** | Collect all |
| **P** | Pause |
| **1 / 2 / 3** | Speed |
| **Esc** | Close sheet / menu / cancel place |
| WASD | Pan |

## Win / lose

- **Victory**: Chapter 5 complete, day 14+, power 180+
- **Defeat**: Morale collapse, total shortage, or dead furnace

## Project

```
scripts/GameState.gd   # Simulation (save v3)
scripts/Main.gd        # Mobile Whiteout-style client
scripts/SnowOverlay.gd
scripts/FloatingText.gd
scenes/Main.tscn
assets/                # Kenney CC0 + custom sheets
```

## Save

`user://frostfall_save.json` — city, layout, survivors, bubbles, storms. Offline catch-up on load.

## Assets

Kenney Tiny Town / Ski / UI Pack / Game Icons — **CC0**. Custom building & map art in `assets/building_upgrades/` and `assets/map_details/`.
