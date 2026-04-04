# SAS Common — Misc Sub-module

This sub-module provides general-purpose utility functions used across the SAS framework. Functions cover side-switching, HALO parachute jumps, flare firing, and group state resets.

## Functions

### `SAS_fnc_switchSide`
Switches the side of a unit or all units in a group by moving them into a new group of the target side. Deletes the old group if it becomes empty.

**Usage:**
```sqf
[entity, side] call SAS_fnc_switchSide;
```

**Parameters:**
| # | Type | Description |
|---|------|-------------|
| 0 | OBJECT \| GROUP | Unit or group to switch |
| 1 | SIDE | Target side (e.g. `WEST`, `EAST`, `RESISTANCE`) |

**Returns:** `BOOL` — `true` on success, `false` on validation failure.

> **Warning:** Switching side can break scripts that hold a reference to the original group. Always test after use.

---

### `SAS_fnc_doHalo`
Teleports a unit to altitude and performs a HALO parachute jump. Handles backpack preservation, optional chemlight attachment, post-canopy effects, and AI safety.

**Usage:**
```sqf
[unit] call SAS_fnc_doHalo;
[unit, getPos unit, 4000, true, false, true] call SAS_fnc_doHalo;
```

**Parameters:**
| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | OBJECT | Unit to perform the jump | *(required)* |
| 1 | POSITION | Jump position | unit's current position |
| 2 | NUMBER | Jump altitude in metres (min 500) | `3000` |
| 3 | BOOL | Attach a red chemlight to the unit during freefall | `true` |
| 4 | BOOL | Auto-open parachute at 150 m AGL (player only) | `false` |
| 5 | BOOL | Preserve and restore original backpack after landing | `true` |

**Returns:** `OBJECT` — the unit that performed the jump.

---

### `SAS_fnc_fireFlare`
Fires a coloured flare from a unit or the leader of a group.

**Usage:**
```sqf
[groupOrUnit, color, position] call SAS_fnc_fireFlare;
```

**Parameters:**
| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | OBJECT \| GROUP | Unit or group whose leader fires the flare | *(required)* |
| 1 | STRING | `"white"`, `"red"`, `"green"`, or `"blue"` | `"white"` |
| 2 | ARRAY | World position for the flare. If empty, fires 50 m ahead and 200 m up from the leader | `[]` |

**Returns:** `OBJECT` — the created flare vehicle.

---

### `SAS_fnc_resetGroup`
Resets a group to a neutral default state: enables all AI, clears waypoints, and resets behaviour, combat mode, speed, and formation.

**Usage:**
```sqf
[groupOrLeader] call SAS_fnc_resetGroup;
```

**Parameters:**
| # | Type | Description |
|---|------|-------------|
| 0 | OBJECT \| GROUP | Group leader or group to reset |

**Returns:** Nothing.

## Debugging
All functions use `SAS_fnc_logDebug` for debug output. Enable `SAS_Debug_global` for verbose logs.

## References
- See [copilot-instructions.md](../../../.github/copilot-instructions.md) for architectural and coding standards.
- `SAS_fnc_switchSide` is used by `sas/civilians` (`SAS_Civilians_fnc_makeHostile`).
- `SAS_fnc_fireFlare` is used by `sas/nightops` (`SAS_NightOps_fnc_fireFlaresAtTargetRecurring`).
