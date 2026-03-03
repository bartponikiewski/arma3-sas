# SAS Night Operations Module

## Overview
The **nightops** module provides functions and utilities to enhance night-time gameplay in Arma 3 missions. It enables mission-makers to control lighting, flares, and AI flashlight usage, supporting immersive and dynamic night operations.

## Features
- Switch individual or area lights on/off dynamically
- Recurring flare launches at target locations
- AI flashlight and flare usage scripting
- Modular, event-driven design for performance and flexibility

## Functions
All public functions follow the SAS naming convention and are registered for use in mission scripts. Key functions include:

- **SAS_Nightops_fnc_switchLight**
  - Switches a single light source on or off.
- **SAS_Nightops_fnc_switchLightsInArea**
  - Switches all lights within a specified area on or off.
- **SAS_Nightops_fnc_fireFlaresAtTargetRecurring**
  - Launches flares at a target location on a recurring schedule.
- **SAS_Nightops_fnc_useFlares**
  - Orders AI to use flares.
- **SAS_Nightops_fnc_useFlashlights**
  - Orders AI to use flashlights.

See each function's header for usage, parameters, and return values.

## Usage
1. Register the module's functions in your central include (see SAS framework instructions).
2. Call the desired function from your mission script or event handler:
   
   Example:
   [position, radius, true] call SAS_Nightops_fnc_switchLightsInArea;

3. For recurring or AI-driven effects, use the provided functions in scheduled or event-driven logic.

## Best Practices
- Use area-based light switching for performance.
- Prefer event-driven triggers over continuous polling.
- Follow SAS framework conventions for modularity and debug logging.

## Debugging
All functions support debug logging via `SAS_fnc_logDebug`. Enable `SAS_Debug_global` for verbose output during development.


## References
- See the SAS framework documentation for architecture, registration, and debug standards.
- Refer to Arma 3 scripting wiki for engine command details.

---
This module is part of the SAS framework. For questions or contributions, see the main project documentation.
