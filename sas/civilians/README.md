# SAS Civilians Module

This module provides functions for manipulating civilian units and groups in Arma 3 missions using the SAS framework. It enables mission-makers to script dynamic civilian behaviour such as turning civilians hostile mid-mission.

## Features
- Turn a civilian unit or group hostile toward a specified side
- Arm newly hostile civilians with a random or specified weapon type
- Validates locality, side, and weapon type before applying changes
- Delegates side-switching to `SAS_fnc_switchSide` for consistency

## Functions

### `SAS_Civilians_fnc_makeHostile`
Makes a civilian unit or group hostile and arms every member with a weapon.

**Usage:**
```sqf
[civ, side, weaponType] call SAS_Civilians_fnc_makeHostile;
```

**Parameters:**
| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | OBJECT \| GROUP | Civilian unit or group to make hostile | *(required)* |
| 1 | SIDE | Side that the civilians become hostile toward (e.g. `WEST`) | `WEST` |
| 2 | STRING | Weapon category: `"PISTOL"`, `"SMG"`, `"SHOTGUN"`, `"RIFLE"`, or an exact class name | random |

**Returns:** `BOOL` — `true` on success, `false` on validation failure.

**Examples:**
```sqf
// Make a single civilian hostile toward WEST with a random weapon
[civ1] call SAS_Civilians_fnc_makeHostile;

// Make an entire civilian group hostile toward EAST, armed with SMGs
[civGrp, EAST, "SMG"] call SAS_Civilians_fnc_makeHostile;
```

## Implementation Notes
- The function exits early if the entity is null, not local, or not of civilian side.
- Weapon selection uses a built-in hash map of category-to-class-array mappings; passing an invalid category causes an early exit.
- Side switching is performed via `SAS_fnc_switchSide`, which moves all units into a new group of the target side.
- Each unit has `setCaptive false` applied after arming to ensure they engage enemies.

## Debugging
Debug output is controlled by `SAS_Debug_global`. Enable it to receive hint messages about each step of the function.

## References
- See [copilot-instructions.md](../../.github/copilot-instructions.md) for architectural and coding standards.
- See `sas/common/misc` for `SAS_fnc_switchSide`, which this module depends on.
