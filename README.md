# Sushi Arma Scripts - Framework for missionmakers

## What is SAS?

SAS (Sushi ArmA Scripts) is a modular framework for Arma 3 missions, designed to support mission-makers with scalable, engine-friendly systems. It provides:
- Modular, self-contained scripts for AI, tasks, intro, logging, and more
- Standardized function registration and documentation
- Engine compatibility and performance best practices

This mission is a **playground for SAS development and testing**. All features are enabled and ready for demonstration, including:
 - Actions for day/night switching, parachute, fastrope
 - Intro sequences and loading screen via `SAS_Intro_fnc_play`
 - Briefing and tasks setup using `SAS_Briefing_fnc_createTasks` and `SAS_Briefing_fnc_createBriefing`
 - Additional diary notes and credits
The mission setup (see `init.sqf` and `initPlayerLocal.sqf`) demonstrates all core SAS systems, including intro, loading screen, briefing, and tasks.

## Module Overview

All mission logic lives under `sas/`, organized into self-contained modules. Each module has a README documenting its key functions, usage, and debugging. See [sas/README.md](sas/README.md) for a full module table and details.

Example modules:
- Common: Logging, GUI, misc utilities
- Intro: Opening sequence, UAV shots, overlays
- Conversation: HUD overlays, branching dialogs
- Morale: Group fear calculation, casualty tracking
- Reinforcement: AI reinforcement request and dispatch
- NightOps: Night combat tools (lights, flares)
- Task: AI task assignment (patrol, defend, garrison)
- Civilians: Make civilians hostile and arm them
- Fastrope: Helicopter fastrope mechanics
- Gunship: Gunship creation, control, comms
- Hostage: Hostage creation and management
- Intel: Intel dialog and management
- Skills: Skill parameter management
- Briefing: Diary and task creation functions
- Params: Mission parameter configuration

For a complete list and documentation links, see [sas/README.md](sas/README.md).

## Example Usage

Enable debug mode in `init.sqf`:
```sqf
SAS_Debug_global = true;
```

Register a group for reinforcements:
```sqf
[this, true, false] call SAS_Reinforcement_fnc_registerGroup;
```

Show loading screen and intro sequence:
```sqf
[] call SAS_fnc_loadingScreen;

[
    ["QUOTE"],
    [
        "OPENING", 
        [
            ["This is", "a simple intro sequence example", "for SAS framework"],
            ["SAS", "Sushi ArmA Scripts", "v1.0.0-a"],
            ["LeadTrack01_F_Tacops", true]
        ]
    ],
    ["UAV", player]
] call SAS_Intro_fnc_play;

[] call SAS_Intro_fnc_infoText;
```

Assign AI tasks:
```sqf
[_group, getPos _marker, 150] call SAS_Task_fnc_patrol;
[_group, getPos _marker, 100, true, true] call SAS_Task_fnc_defend;
```

Create tasks, briefing, and notes:
```sqf
[
    ["task1", "Test reinforcements", "Lorem ipsum dolor sit amet.", "Attack", "mrk_reinforcements_1"],
    ["task2", "Destroy that", "Lorem ipsum dolor sit amet.", "Destroy", tl_opfor_1],
    ["task3", "Take intel", "Lorem ipsum dolor sit amet.", "Destroy", laptop_3]
] spawn SAS_Briefing_fnc_createTasks;

[
    ["Mission",   "Test SAS and complete the work"],
    ["Situation", "Nothing works, figure it out and fix it."],
    ["Execution", "Go there, do that, win the day."],
    ["Support",   "You have nothing, good luck!"]
] spawn SAS_Briefing_fnc_createBriefing;

[
    ["Credits", "Mission created by Sushi. Thanks for playing!<br /><img image='sas/assets/logo_bar.paa' width=300 />"],
    ["Tech notes", "This mission is using Sushi Arma Scripts framework v1.0.0<br /><img image='sas/assets/powered_by_sas_large.paa' width=200 />"]
] spawn SAS_Briefing_fnc_createNotes;
```

Use mission parameters:
```sqf
#include "sas/params/paramSkills.hpp"
#include "sas/params/paramIntro.hpp"
```

## Onboarding & Testing

- The mission is prepared to test every SAS feature. Actions and scripts in `init.sqf` and `initPlayerLocal.sqf` demonstrate:
    - Intro and loading screen (`SAS_Intro_fnc_play`)
    - Briefing and tasks setup (`SAS_Briefing_fnc_createTasks`, `SAS_Briefing_fnc_createBriefing`)
    - All core systems and actions
- See [sas/README.md](sas/README.md) for module details and links to documentation.
- For coding standards and architecture, see [copilot-instructions.md](.github/copilot-instructions.md).

## References

- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)
- [copilot-instructions.md](.github/copilot-instructions.md)
