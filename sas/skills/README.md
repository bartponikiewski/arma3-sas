
# SAS Skills Module

This module provides skill parameter management for Arma 3 missions. Key features include setting skills and skill parameters for units or groups.

## Key Functions

### Set Skills
**SAS_Skills_fnc_set**

Sets unit or group skills to predefined levels (NORMAL, GOOD, SPECOPS) or custom values.

**Usage:**
```
[unit, skillLevel, customValues] call SAS_Skills_fnc_set;
```

**Parameters:**
- unit: Unit, array of units, or group
- skillLevel: Predefined skill level ("AUTO", "NORMAL", "GOOD", "SPECOPS")
- customValues: Array of custom skill values (if skillLevel is "CUSTOM")

---

## Additional Functions
- `fn_paramSkills.sqf`: Manage skill parameters

See the functions directory for more details.

---

## Usage Example
```sqf
[group this] call SAS_Skills_fnc_set;
[[unit1,unit2,unit3],"SPECOPS"] call SAS_Skills_fnc_set;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.