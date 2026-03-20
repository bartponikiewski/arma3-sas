
# SAS Civilians Module

This module provides functions for manipulating civilian units and groups in Arma 3 missions using the SAS framework. Key features include turning civilians hostile mid-mission and arming them.

## Key Functions

### Make Hostile
**SAS_Civilians_fnc_makeHostile**

Makes a civilian unit or group hostile and arms every member with a weapon.

**Usage:**
```
[civ, side, weaponType] call SAS_Civilians_fnc_makeHostile;
```

**Parameters:**
- civ: Civilian unit or group to make hostile
- side: Side to become hostile toward (default: WEST)
- weaponType: Weapon category ("PISTOL", "SMG", "SHOTGUN", "RIFLE", or exact class; default: random)

---

## Additional Functions
- `fn_createHostileZone.sqf`: Create hostile zone for civilians
- `fn_makeHostileInArea.sqf`: Make civilians hostile in area

See the functions directory for more details.

---

## Usage Example
```sqf
[civ1] call SAS_Civilians_fnc_makeHostile;
[civGrp, EAST, "SMG"] call SAS_Civilians_fnc_makeHostile;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.
- Weapon selection uses a built-in hash map of category-to-class-array mappings; passing an invalid category causes an early exit.
- Side switching is performed via `SAS_fnc_switchSide`, which moves all units into a new group of the target side.
- Each unit has `setCaptive false` applied after arming to ensure they engage enemies.

## Debugging
Debug output is controlled by `SAS_Debug_global`. Enable it to receive hint messages about each step of the function.

## References
- See [copilot-instructions.md](../../.github/copilot-instructions.md) for architectural and coding standards.
- See `sas/common/misc` for `SAS_fnc_switchSide`, which this module depends on.
