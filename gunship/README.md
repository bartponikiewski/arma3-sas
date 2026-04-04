# SAS Gunship Module

This module provides gunship creation, control, and communication for Arma 3 missions. Key features include gunship management, call menus, command menus, and JTAC integration.

## Key Functions

### Initialization
**SAS_Gunship_fnc_init**

Initializes the Gunship module, sets allowed modes, max calls, and registers JTAC units.

**Usage:**
```
[JTACUnits, maxCalls, availableModes] call SAS_Gunship_fnc_init;
```

**Parameters:**
- JTACUnits: Array of JTAC units to register
- maxCalls: Maximum number of gunship calls
- availableModes: Array of allowed gunship modes (e.g., ["LASER", "MANUAL"])

### Start Mission
**SAS_Gunship_fnc_startMission**

Starts a gunship mission, checks call limits, manages menu, and triggers gunship attack on position.

**Usage:**
```
[attackPos, mode, jtacUnit] call SAS_Gunship_fnc_startMission;
```

**Parameters:**
- attackPos: Target position for gunship attack
- mode: Gunship mode (default: "LASER")
- jtacUnit: JTAC unit (default: player)

---

## Additional Functions
- `fn_createGunship.sqf`: Create a gunship unit
- `fn_callOnPosition.sqf`: Call gunship to a position
- `fn_addCallMenu.sqf`: Add call menu for gunship
- `fn_addCommandMenu.sqf`: Add command menu for gunship

See the functions directory for more details.

---

## Usage Example
```sqf
[jtacUnits, 3, ["LASER", "MANUAL"]] call SAS_Gunship_fnc_init;
[getPos target, "LASER", player] call SAS_Gunship_fnc_startMission;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.