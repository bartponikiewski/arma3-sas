
# SAS Intel Module

This module provides intel dialog and management for Arma 3 missions. Key features include setting intel, simple intel, and showing intel dialogs.

## Key Functions

### Set Intel
**SAS_Intel_fnc_setIntel**

Adds an action to an object for intel investigation, triggering a dialog when used.

**Usage:**
```
[_obj, _actionText, _dialogParams] call SAS_Intel_fnc_setIntel;
```

**Parameters:**
- obj: Object to attach the action to
- actionText: Action text shown to player (default: "Investigate")
- dialogParams: Parameters passed to intel dialog (default: [])

---

## Additional Functions
- `fn_setIntelSimple.sqf`: Set simple intel
- `fn_intelDialog.sqf`: Show intel dialog

See the functions directory for more details.

---

## Usage Example
```sqf
[intelObj, "Investigate", ["Intel found!"]] call SAS_Intel_fnc_setIntel;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.