# Sushi Arma Scripts — Framework for missionmakers

**Version 1.0.0**

SAS (Sushi ArmA Scripts) is a modular framework for Arma 3 missions, created by Sushi with multiplayer testing by Gruwi. It provides self-contained systems for AI, intro sequences, briefing, conversations, night ops, captives, and more — all registered centrally for engine compatibility.

## Getting started

→ **[sas/QUICKSTART.md](sas/QUICKSTART.md)** — step-by-step guide: setup, intro, briefing, AI tasks, conversations, and reinforcements.

## Repository layout

```
sas/               — all framework modules
description.ext    — wires up functions, params, RSC, and comms
init.sqf           — server-side setup (tasks, AI, briefing)
initPlayerLocal.sqf — per-client setup (intro, HUD)
mission.sqm        — Eden Editor scene data
```

This repo is also a **ready-to-run test mission**. The included `mission.sqm` has all units, markers, and objects already placed and named. Drop the repo folder into your Arma 3 missions directory and open it in the editor or host it directly — every SAS feature is wired up and ready to test. `init.sqf` and `initPlayerLocal.sqf` serve as a living reference for how to use each module.

## Modules

All modules need to live live under `sas/`. For the full list with function tags and documentation links see **[sas/MODULE_INDEX.md](MODULE_INDEX.md)**.

## References

- [sas/QUICKSTART.md](QUICKSTART.md)
- [sas/MODULE_INDEX.md](MODULE_INDEX.md)
- [.github/copilot-instructions.md](.github/copilot-instructions.md)
- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)
