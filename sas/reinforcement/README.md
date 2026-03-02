# SAS Reinforcement Module

## Overview
The SAS Reinforcement module provides a flexible system for managing AI group reinforcements in Arma 3 missions. It allows mission-makers to register groups as reinforcement providers or callers, control reinforcement eligibility, and handle reinforcement requests dynamically based on in-game events such as group morale or fear changes.

## Features
- Register groups as reinforcement providers or callers
- Dynamically enable or disable reinforcement eligibility
- Request and send reinforcements between groups
- Track and manage registered reinforcement groups
- React to group fear changes to trigger reinforcement logic

## Usage Example
To register a group in the system:

[_grp, true, false] call SAS_reinforcement_fnc_registerGroup;

Parameters(s):
0: OBJECT or GROUP - Group leader or group
1: BOOL - Can call reinforcements
2: BOOL - Can be called as reinforcement

## Integration
- All public functions are registered in `sas/description.cpp` for engine compatibility.
- Use only the public interface for cross-module communication.
- Follow SAS variable and function naming conventions for consistency.

## Debugging
- Debug output is controlled by the global `SAS_Debug_global` flag.
- All debug messages use `SAS_fnc_logDebug` for centralized logging.

## Best Practices
- Register groups at mission start or dynamically as needed.
- Use event-driven logic (e.g., on group fear change) to trigger reinforcement requests.
- Avoid per-frame polling; prefer scheduled or event-based checks.

## References
- See the [copilot-instructions.md](../../.github/copilot-instructions.md) for architectural and coding standards.
- Refer to official Arma 3 documentation for engine commands and AI behavior.
