
# SAS NightOps Module

This module provides functions and utilities to enhance night-time gameplay in Arma 3 missions. Key features include dynamic lighting, flares, and AI flashlight usage.

## Key Functions

### Switch Lights In Area
**SAS_Nightops_fnc_switchLightsInArea**

Switches all lights within a specified area on or off.

**Usage:**
```
[position, radius, true] call SAS_Nightops_fnc_switchLightsInArea;
```

---

### Use Flashlights
**SAS_Nightops_fnc_useFlashlights**

Orders AI to use flashlights.

**Usage:**
```
[group] call SAS_Nightops_fnc_useFlashlights;
```

---

## Additional Functions
- `SAS_Nightops_fnc_switchLight`: Switches a single light source
- `SAS_Nightops_fnc_fireFlaresAtTargetRecurring`: Launches flares at a target location on a recurring schedule
- `SAS_Nightops_fnc_useFlares`: Orders AI to use flares

See the functions directory for more details.

---

## Usage Example
```sqf
[position, 100, true] call SAS_Nightops_fnc_switchLightsInArea;
[group] call SAS_Nightops_fnc_useFlashlights;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.

## Debugging
All functions support debug logging via `SAS_fnc_logDebug`. Enable `SAS_Debug_global` for verbose output during development.


## References
- See the SAS framework documentation for architecture, registration, and debug standards.
- Refer to Arma 3 scripting wiki for engine command details.

---
This module is part of the SAS framework. For questions or contributions, see the main project documentation.
