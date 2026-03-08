# SAS_v1.Stratis

An Arma 3 mission built on the **SAS framework** — a modular scripting system designed to support mission-makers with reusable, well-structured gameplay systems.

## Mission Overview

- **Map:** Stratis
- **Time:** Night
- **Player:** BLUFOR soldier (`player_1`)
- **Setting:** Multi-faction engagement with OPFOR infantry, recon elements, air support, and civilian presence. Enemy groups are pre-registered into the SAS Reinforcement and Morale systems.

## Framework Architecture

All mission logic lives under `sas/`, organized into self-contained modules. Functions are registered centrally in `sas/description.cpp`, included by `description.ext`, and callable via `SAS_<Module>_fnc_<action>`.

```
sas/
├── description.cpp         Central CfgFunctions registration
├── civilians/              Civilian hostility and side-switching
├── common/
│   ├── gui/                Modal GUI dialog builder
│   ├── logging/            Centralized debug logging
│   └── misc/               Shared utilities (HALO, flares, group reset, side switch)
├── conversation/           In-game dialogue overlays and branching dialogs
├── intro/                  Intro sequence, UAV shots, text overlays, quote screen
├── morale/                 Group-level fear and casualty tracking
├── nightops/               Night combat tools (flashlights, flares, light switching)
├── reinforcement/          AI reinforcement request and dispatch system
└── task/                   AI task assignment (patrol, defend, garrison)
```

## Modules

| Module | Tag | Description |
|---|---|---|
| [Common / Logging](sas/common/logging/README.md) | `SAS_fnc_` | Debug logging via `SAS_fnc_logDebug` |
| [Common / Misc](sas/common/misc/README.md) | `SAS_fnc_` | HALO jump, flares, group reset, side switch |
| [Common / GUI](sas/common/gui/README.md) | `SAS_fnc_` | Modal button dialogs |
| [Intro](sas/intro/README.md) | `SAS_Intro_fnc_` | Intro text, UAV shots, title cards, quote screen |
| [Conversation](sas/conversation/README.md) | `SAS_Conv_fnc_` | HUD message overlays and branching modal dialogs |
| [Morale](sas/morale/README.md) | `SAS_Morale_fnc_` | Group fear calculation and casualty tracking |
| [Reinforcement](sas/reinforcement/README.md) | `SAS_Reinforcement_fnc_` | AI reinforcement request and dispatch |
| [NightOps](sas/nightops/README.md) | `SAS_NightOps_fnc_` | Flashlights, flares, area light control |
| [Task](sas/task/README.md) | `SAS_Task_fnc_` | Patrol, defend, garrison tasks for AI groups |
| [Civilians](sas/civilians/README.md) | `SAS_Civilians_fnc_` | Make civilians hostile and arm them |

## Module Interdependencies

```
Civilians ──────────────────► Common/Misc (switchSide)
NightOps ───────────────────► Common/Misc (fireFlare)
Task/Defend ────────────────► Task/Garrison, Task/Patrol
Reinforcement ──────────────► Morale (registerGroup, groupFearChanged event)
                           ► Common/Misc (fireFlare, resetGroup)
All modules ────────────────► Common/Logging (logDebug)
```

## Getting Started

### Debug Mode

Enable debug hints globally in `init.sqf`:

```sqf
SAS_Debug_global = true;
```

When true, all modules output status messages via `SAS_fnc_logDebug` and draw debug markers on the map.

### Registering Groups

Register groups at mission start or in unit init fields:

```sqf
// Can call reinforcements, cannot be called
[this, true, false] call SAS_Reinforcement_fnc_registerGroup;

// Cannot call, but available as reinforcement
[this, false, true] call SAS_Reinforcement_fnc_registerGroup;
```

### Running an Intro Sequence

```sqf
[
    ["It was a dark night on Stratis.", "The mission had just begun."],
    ["Operation Silent Strike", "3rd SAS Regiment"],
    "MyMusicClass"
] spawn SAS_Intro_fnc_opening;
```

### Assigning AI Tasks

```sqf
// Patrol around a position
[_group, getPos _marker, 150] call SAS_Task_fnc_patrol;

// Defend a position (garrison + patrol)
[_group, getPos _marker, 100, true, true] call SAS_Task_fnc_defend;
```

## Conventions

- **Function naming:** `SAS_<Module>_fnc_<action>` (e.g., `SAS_Morale_fnc_registerGroup`)
- **Variables:** `SAS_<Module>_<camelCaseState>` (e.g., `SAS_Morale_groupFear`)
- **Do not edit** `mission.sqm` manually — use the Arma 3 editor only
- All new functions must be registered in `sas/description.cpp`
- See [copilot-instructions.md](.github/copilot-instructions.md) for full coding standards

## References

- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)
- [copilot-instructions.md](.github/copilot-instructions.md)
