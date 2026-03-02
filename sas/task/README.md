# SAS Task Module

This module provides AI group tasking functions for the SAS framework in Arma 3 missions. It enables mission-makers to assign and manage group-level behaviors such as defending, garrisoning, and patrolling, in a modular and engine-friendly way.

## Features
- Assign defend, garrison, and patrol tasks to AI groups
- Modular, event-driven design for scalability
- Designed for use with SAS function registration and mission architecture

## Functions
- **fn_defend.sqf**: Assigns a defend task to a group at a specified position or area.
- **fn_garrison.sqf**: Orders a group to garrison a building or set of positions.
- **fn_patrol.sqf**: Assigns a patrol route or area to a group.

## Usage
All functions are registered using the SAS naming convention and should be called via the engine-registered function name, e.g.:

    [group, position, radius] call SAS_task_fnc_patrol;

Refer to each function's header for parameter details and usage examples.

## Integration
- Register all public functions in `sas/description.cpp` under the `SAS_task` class.
- Use only the public interface for cross-module calls.
- Place all new task-related functions in this module for consistency.

## Debugging
All functions support debug logging via the SAS logging system. Enable `SAS_Debug_global` to see debug output.

## Best Practices
- Use group-level tasking for performance and realism.
- Avoid per-frame or per-unit polling; prefer event-driven logic.
- Follow SAS documentation and function header standards for all new functions.

---
For more information, see the main SAS framework documentation and the copilot-instructions.md in the repository root.
