
# SAS Task Module

This module provides AI group tasking functions for the SAS framework in Arma 3 missions. Key features include defend, garrison, and patrol tasks for AI groups.

## Key Functions

### Patrol
**SAS_Task_fnc_patrol**

Assigns a patrol route or area to a group.

**Usage:**
```
[group, position, radius] call SAS_Task_fnc_patrol;
```

---

### Defend
**SAS_Task_fnc_defend**

Assigns a defend task to a group at a specified position or area.

**Usage:**
```
[group, position, radius, garrison, patrol] call SAS_Task_fnc_defend;
```

---

## Additional Functions
- `fn_garrison.sqf`: Orders a group to garrison a building or set of positions

See the functions directory for more details.

---

## Usage Example
```sqf
[group, getPos marker, 150] call SAS_Task_fnc_patrol;
[group, getPos marker, 100, true, true] call SAS_Task_fnc_defend;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.
