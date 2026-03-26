# SAS Framework — Module Index

All modules live under `sas/`, each self-contained with its own functions and README. Functions are registered centrally in `sas/functions.hpp` via `cfgFunctions` in `description.ext`.

→ New here? Start with **[QUICKSTART.md](QUICKSTART.md)**.

---

## Modules

| Module | Tag | Description | Docs |
|--------|-----|-------------|------|
| Common / Logging | `SAS_fnc_` | Centralised debug logging via `SAS_fnc_logDebug` | [common/logging/README.md](common/logging/README.md) |
| Common / Misc | `SAS_fnc_` | HALO jump, flares, markers, waypoints, group reset, side switch | [common/misc/README.md](common/misc/README.md) |
| Common / GUI | `SAS_fnc_` | Modal button dialogs, black-in/out transitions | [common/gui/README.md](common/gui/README.md) |
| Init | `SAS_Init_fnc_` | Loading screen that persists until all init scripts finish | [init/README.md](init/README.md) |
| Intro | `SAS_Intro_fnc_` | Blackout intro sequence, UAV shot, info overlay, quote screen | [intro/README.md](intro/README.md) |
| Briefing | `SAS_Briefing_fnc_` | Task creation, briefing sections, diary notes, task state management | [briefing/README_diary.md](briefing/README_diary.md) |
| Conversation | `SAS_Conv_fnc_` | Non-blocking HUD overlays and modal branching dialogs with face-cam | [conversation/README.md](conversation/README.md) |
| Task | `SAS_Task_fnc_` | Patrol, defend, and garrison behaviours for AI groups | [task/README.md](task/README.md) |
| Morale | `SAS_Morale_fnc_` | Per-group fear tracking based on casualties | [morale/README.md](morale/README.md) |
| Reinforcement | `SAS_Reinforcement_fnc_` | Fear-driven reinforcement requests and dispatch between AI groups | [reinforcement/README.md](reinforcement/README.md) |
| NightOps | `SAS_NightOps_fnc_` | Flashlights, flares, area light control, power source actions | [nightops/README.md](nightops/README.md) |
| Civilians | `SAS_Civilians_fnc_` | Make civilians hostile, arm them, create hostile zones | [civilians/README.md](civilians/README.md) |
| Hostage | `SAS_Hostage_fnc_` | Cuff civilians as hostages, free action, state management | [hostage/README.md](hostage/README.md) |
| Captive | `SAS_Captive_fnc_` | Full captive flow: surrender → arrest → escort → vehicle → release | [captive/README.md](captive/README.md) |
| DragBody | `SAS_DragBody_fnc_` | Drag incapacitated players (requires native BIS revive) | [dragbody/README.md](dragbody/README.md) |
| Fastrope | `SAS_Fastrope_fnc_` | Helicopter fast-rope insertion mechanics | [fastrope/README.md](fastrope/README.md) |
| Gunship | `SAS_Gunship_fnc_` | Gunship CAS: spawn, JTAC menu, laser/manual fire modes, RTB | [gunship/README.md](gunship/README.md) |
| Intel | `SAS_Intel_fnc_` | Interactable intel objects with dialog and callback | [intel/README.md](intel/README.md) |
| Skills | `SAS_Skills_fnc_` | Apply skill presets (NORMAL / GOOD / SPECOPS) to units or groups | [skills/README.md](skills/README.md) |
| Cache | `SAS_Cache_fnc_` | Cache editor groups as templates, spawn clones or scaled squads at runtime | [cache/README.md](cache/README.md) |
| Params | — | Lobby parameters for intro toggle and AI skill level | [params/README.md](params/README.md) |

---

## Global variables

| Variable | Type | Set in | Description |
|----------|------|--------|-------------|
| `SAS_Debug_global` | Bool | `init.sqf` | Enable verbose debug logging across all modules |
| `SAS_Dev_mode` | Bool | `init.sqf` | Enable development helpers (markers, extra logging) |

---

## Adding a new module

1. Create `sas/<module>/` with a `functions/` subfolder.
2. Write your functions as `fn_<name>.sqf`.
3. Register them in `sas/functions.hpp` under a new `class SAS_<Module>` block.
4. Add a `README.md` and a row to this table.

See [copilot-instructions.md](../.github/copilot-instructions.md) for naming conventions and coding standards.

---

## References

- [QUICKSTART.md](QUICKSTART.md)
- [copilot-instructions.md](../.github/copilot-instructions.md)
- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)
