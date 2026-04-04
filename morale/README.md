
# SAS Morale Module

This module provides group-level morale and fear calculations for Arma 3 missions using the SAS framework. Key features include casualty tracking, group fear calculation, and event-driven updates.

## Key Functions

### Register Group
**SAS_Morale_fnc_registerGroup**

Registers a group for morale tracking and event handlers.

**Usage:**
```
[group player] call SAS_Morale_fnc_registerGroup;
[player] call SAS_Morale_fnc_registerGroup;
```

---

### Calculate Group Fear
**SAS_Morale_fnc_calculateGroupFear**

Calculates group fear based on casualties, suppression, and morale.

**Usage:**
```
[group player] call SAS_Morale_fnc_calculateGroupFear;
```

Returns a value between 0 (no fear) and 1 (maximum fear).

---

## Event Handling
Emits `SAS_Morale_groupFearChanged` event using `BIS_fnc_callScriptedEventHandler` whenever group fear changes.
Example:
```sqf
_group addEventHandler ["SAS_Morale_groupFearChanged", {
    params ["_group", "_oldFear", "_newFear"];
    // Custom logic here
}];
```

---

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.

## File Overview
- `fn_registerGroup.sqf`: Registers a group for morale tracking and sets up event handlers.
- `fn_onUnitKilled.sqf`: Handles unit killed events, updates casualties, recalculates fear, and emits events.
- `fn_calculateGroupFear.sqf`: Calculates group fear based on current group state.
- `fn_groupFearChanged.sqf`: Custom logic for when group fear changes (can be extended).

## Extending
- You can add custom effects, notifications, or AI logic in `fn_groupFearChanged.sqf`.
- Adjust weights in `fn_calculateGroupFear.sqf` for different mission balancing.
