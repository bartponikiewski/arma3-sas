
# SAS Reinforcement Module

This module provides a flexible system for managing AI group reinforcements in Arma 3 missions. Key features include group registration, eligibility control, and event-driven reinforcement requests.

## Key Functions

### Register Group
**SAS_Reinforcement_fnc_registerGroup**

Registers a group as reinforcement provider or caller.

**Usage:**
```
[_grp, canCall, canBeCalled] call SAS_Reinforcement_fnc_registerGroup;
```

**Parameters:**
- _grp: Group leader or group
- canCall: Can call reinforcements (bool)
- canBeCalled: Can be called as reinforcement (bool)

---

## Additional Functions
- Request and send reinforcements between groups
- Track and manage registered reinforcement groups
- React to group fear changes to trigger reinforcement logic

See the functions directory for more details.

---

## Usage Example
```sqf
[group player, true, false] call SAS_Reinforcement_fnc_registerGroup;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.
