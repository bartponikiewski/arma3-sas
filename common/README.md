
# SAS Common Module

The `common` directory is a meta-module grouping shared utility sub-modules used across the SAS framework. These sub-modules provide foundational capabilities for all other modules.

## Sub-modules

| Sub-module | Key Function | Description |
|---|---|---|
| [`misc`](misc/README.md) | `SAS_fnc_switchSide`, `SAS_fnc_doHalo` | Utility functions: side-switching, HALO jumps, flares, group reset |
| [`logging`](logging/README.md) | `SAS_fnc_logDebug` | Centralized debug logging |
| [`gui`](gui/README.md) | `SAS_fnc_guiMessage` | Generic GUI message dialog with configurable buttons |

---

## Key Functions

### Logging
**SAS_fnc_logDebug**

Displays debug hint messages when `SAS_Debug_global` is enabled. Used by all modules for consistent debug output.

**Usage:**
```
["Your debug message"] call SAS_fnc_logDebug;
```

---

### Misc Utilities
**SAS_fnc_switchSide**

Switches the side of a unit or group.

**Usage:**
```
[entity, side] call SAS_fnc_switchSide;
```

**SAS_fnc_doHalo**

Performs HALO parachute jump for a unit.

**Usage:**
```
[unit] call SAS_fnc_doHalo;
```

---

### GUI
**SAS_fnc_guiMessage**

Creates a modal dialog with title, message, and buttons.

**Usage:**
```
[title, message, buttons] call SAS_fnc_guiMessage;
```

---

## Usage Example
```sqf
SAS_Debug_global = true;
["[myModule] Initialising group tracking"] call SAS_fnc_logDebug;
[player, west] call SAS_fnc_switchSide;
["Notice", "Mission area is now active."] call SAS_fnc_guiMessage;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../../.github/copilot-instructions.md) for documentation and coding conventions.
