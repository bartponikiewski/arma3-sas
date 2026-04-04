
# SAS Hostage Module

This module provides hostage creation and management for Arma 3 missions. Key features include making hostages, setting hostage state, and adding/removing free hostage actions.

## Key Functions

### Make Hostage
**SAS_Hostage_fnc_makeHostage**

Makes a unit a hostage (typically civilian, but any unit supported).

**Usage:**
```
[_unit] call SAS_Hostage_fnc_makeHostage;
```

**Parameters:**
- unit: Unit to make a hostage

---

## Additional Functions
- `fn_setHostageState.sqf`: Set hostage state
- `fn_addFreeHostageAction.sqf`: Add free hostage action
- `fn_removeFreeHostageAction.sqf`: Remove free hostage action

See the functions directory for more details.

---

## Usage Example
```sqf
[civ1] call SAS_Hostage_fnc_makeHostage;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.