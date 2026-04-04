# DragBody Module

Allows players to drag incapacitated teammates to safety. Works exclusively with the native Arma 3 BIS revive system (`ReviveMode = 1` in `description.ext`).

## Setup

No manual setup required. The module auto-initializes via `postInit = 1` when native revive is enabled.

## How It Works

1. Each player client broadcasts itself to all other clients on init
2. Every client adds a "Drag" scroll action to every other player
3. The action only appears when the target is incapacitated
4. Dragging attaches the body, locks the dragger to walk speed, and plays drag animations
5. Release detaches and returns the body to unconscious pose
6. Auto-releases if the dragger goes incapacitated/dies, or the target is revived/dies

## Functions

| Function | Description |
|----------|-------------|
| `SAS_DragBody_fnc_init` | Per-client initialization (auto-called via postInit) |
| `SAS_DragBody_fnc_addDragAction` | Adds "Drag" action to a player unit |
| `SAS_DragBody_fnc_drag` | Attaches and starts dragging a target |
| `SAS_DragBody_fnc_release` | Detaches and releases a dragged target |

## Requirements

- `ReviveMode = 1` (or higher) in `description.ext`
- Multiplayer environment
