
# SAS Fastrope Module

This module provides helicopter fastrope mechanics for Arma 3 missions. Key features include rope creation, cutting, fastrope actions, and crew drops.

## Key Functions

### Start Mission
**SAS_Fastrope_fnc_startMission**

Starts a helicopter fast-rope transport mission, flies to drop zone, executes fastrope, and returns or deletes helicopter.

**Usage:**
```
[heli, dropPos, returnPos, deleteAtEnd] spawn SAS_Fastrope_fnc_startMission;
```

**Parameters:**
- heli: Helicopter object
- dropPos: Position to drop troops
- returnPos: Position for helicopter to return after drop
- deleteAtEnd: Whether to delete helicopter at end (default: false)

---

## Additional Functions
- `fn_createRopes.sqf`: Create ropes for fastrope
- `fn_cutRopes.sqf`: Cut ropes after fastrope
- `fn_doFastrope.sqf`: Execute fastrope action
- `fn_dropCrew.sqf`: Drop crew using fastrope

See the functions directory for more details.

---

## Usage Example
```sqf
[heli_1, getPos heli_1, getPos heli_1, false] spawn SAS_Fastrope_fnc_startMission;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.