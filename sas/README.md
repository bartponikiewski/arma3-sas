# SAS Framework Modules

This document provides an overview of all modules in the SAS framework, their purpose, tags, and links to detailed documentation. Each module is self-contained and registered centrally for engine compatibility.

## Module Table

| Module         | Tag                    | Description                                      | Documentation Link                       |
|---------------|------------------------|--------------------------------------------------|------------------------------------------|
| Common / Logging   | SAS_fnc_               | Centralized debug logging                        | [logging/README.md](common/logging/README.md) |
| Common / Misc      | SAS_fnc_               | HALO jump, flares, group reset, side switch      | [misc/README.md](common/misc/README.md)      |
| Common / GUI       | SAS_fnc_               | Modal button dialogs                             | [gui/README.md](common/gui/README.md)        |
| Intro              | SAS_Intro_fnc_         | Intro text, UAV shots, title cards, quote screen | [intro/README.md](intro/README.md)           |
| Conversation       | SAS_Conv_fnc_          | HUD message overlays, branching dialogs           | [conversation/README.md](conversation/README.md) |
| Morale             | SAS_Morale_fnc_        | Group fear calculation, casualty tracking         | [morale/README.md](morale/README.md)           |
| Reinforcement      | SAS_Reinforcement_fnc_ | AI reinforcement request and dispatch             | [reinforcement/README.md](reinforcement/README.md) |
| NightOps           | SAS_NightOps_fnc_      | Flashlights, flares, area light control           | [nightops/README.md](nightops/README.md)         |
| Task               | SAS_Task_fnc_          | Patrol, defend, garrison tasks for AI groups      | [task/README.md](task/README.md)               |
| Civilians          | SAS_Civilians_fnc_     | Make civilians hostile and arm them               | [civilians/README.md](civilians/README.md)       |
| Briefing           | SAS_Briefing_fnc_      | Diary and task creation functions                 | [briefing/README_diary.md](briefing/README_diary.md) |
| Fastrope           | SAS_Fastrope_fnc_      | Helicopter fastrope mechanics                     | [fastrope/functions/](fastrope/functions/)         |
| Gunship            | SAS_Gunship_fnc_       | Gunship creation, control, and comms              | [gunship/functions/](gunship/functions/)           |
| Hostage            | SAS_Hostage_fnc_       | Hostage creation and management                   | [hostage/functions/](hostage/functions/)           |
| Intel              | SAS_Intel_fnc_         | Intel dialog and management                       | [intel/functions/](intel/functions/)               |
| Skills             | SAS_Skills_fnc_        | Skill parameter management                        | [skills/functions/](skills/functions/)              |
| DragBody           | SAS_DragBody_fnc_      | Drag incapacitated players (native revive)        | [dragbody/README.md](dragbody/README.md)           |

## Module Registration

All public functions are registered in `sas/functions.hpp` and centrally included for engine compatibility. See [copilot-instructions.md](../.github/copilot-instructions.md) for standards.

## Adding New Modules
- Create a new folder under `sas/` for your module.
- Add a README.md describing its purpose, functions, and usage.
- Register public functions in `sas/functions.hpp`.
- Follow SAS naming conventions and documentation standards.

## References
- [copilot-instructions.md](../.github/copilot-instructions.md)
- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)
