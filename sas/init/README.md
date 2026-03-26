# SAS Init Module

Manages the mission loading screen. The screen runs automatically at mission start (`postInit`) and stays up until `SAS_Init_fnc_finish` is called, ensuring all initialization scripts complete before the player sees the world.

## Functions

### `SAS_Init_fnc_loadingScreen`
Displays a black loading screen with animated typing text, mission name, author, and a logo bar. Randomly cycles through loading lines while waiting. Runs automatically via `postInit` — no manual call needed.

**Parameters:**
| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | ARRAY | Custom loading lines to display | Built-in pool of 9 lines |
| 1 | NUMBER | Delay after sequence finishes before fade-in | `4` |

**Behaviour:**
- Blacks out the screen and disables environment/sound via `SAS_fnc_blackOut`
- Shows mission name and author from `description.ext`
- Randomly displays lines from the pool (no repeats until all shown)
- Waits for players to be present
- Waits until `SAS_Init_fnc_finish` is called (minimum 10 seconds display time)
- Shows "Finalizing setup..." as the last line before fading in
- Skipped entirely when `SAS_Dev_mode` is `true`

### `SAS_Init_fnc_finish`
Signals the loading screen to end. Call this when all your initialization scripts have completed.

**Usage:**
```sqf
[] call SAS_Init_fnc_finish;
```

**Parameters:** None

**Returns:** Nothing

### `SAS_Init_fnc_getLoadingState`
Returns whether the loading screen has finished (faded in). Use this to gate scripts that should only run after the screen is gone.

**Usage:**
```sqf
waitUntil { [] call SAS_Init_fnc_getLoadingState };
```

**Parameters:** None

**Returns:** `BOOL` — `true` when the loading screen has finished, `false` otherwise.

### `SAS_Init_fnc_setLoadingState`
Sets the loading screen state. Called internally by the loading screen — you normally don't need to call this yourself.

**Parameters:**
| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | BOOL | `true` = screen finished, `false` = screen active | `false` |

**Returns:** Nothing

## Example

```sqf
// init.sqf — server-side setup
// ... create tasks, spawn AI, configure modules ...

// Signal that init is done — loading screen will fade out
[] call SAS_Init_fnc_finish;
```

```sqf
// initPlayerLocal.sqf — wait for loading screen before starting intro
waitUntil { [] call SAS_Init_fnc_getLoadingState };
[...] call SAS_Intro_fnc_play;
```

## Debugging
Debug output is controlled by `SAS_Debug_global`. Enable it to see loading screen start/completion and finish signal in the log.

## References
- See [copilot-instructions.md](../../.github/copilot-instructions.md) for architectural and coding standards.
