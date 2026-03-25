# Sushi Arma Scripts — Framework for missionmakers

SAS (Sushi ArmA Scripts) is a modular framework for Arma 3 missions. It provides self-contained systems for AI, intro sequences, briefing, conversations, night ops, captives, and more — all registered centrally for engine compatibility.

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

This repo is also a **development playground** — `init.sqf` and `initPlayerLocal.sqf` demonstrate every SAS feature and serve as a reference when building your own mission.

## Modules

All modules live under `sas/`. For the full list with function tags and documentation links see **[sas/README.md](sas/README.md)**.

## References

- [sas/QUICKSTART.md](sas/QUICKSTART.md)
- [sas/README.md](sas/README.md)
- [.github/copilot-instructions.md](.github/copilot-instructions.md)
- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)
