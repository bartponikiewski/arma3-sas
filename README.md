# Sushi Arma Scripts — Framework for missionmakers

**Version 1.0.0**

SAS (Sushi ArmA Scripts) is a modular framework for Arma 3 missions, created by Sushi with multiplayer testing by Gruwi. It provides self-contained systems for AI, intro sequences, briefing, conversations, night ops, captives, and more — all registered centrally for engine compatibility.

## Getting started

→ **[QUICKSTART.md](QUICKSTART.md)** — installation options and step-by-step guide to building your first mission.

## Test mission

A fully wired test mission that demonstrates every SAS module is available at [arma3-sas-mission](https://github.com/bartponikiewski/arma3-sas-mission). It uses this repo as a submodule and serves as a living reference for how to use each module.

## Repository layout

This repository is designed to be used as a **git submodule** (or copied) into an Arma 3 mission directory as `sas/`. The repo root becomes the `sas/` folder inside the mission.

```
(repo root → becomes sas/ in mission)
├── _examples_/        ← starter description.ext, init.sqf, initPlayerLocal.sqf
├── assets/            ← shared images, voice files
├── params/            ← lobby parameters (intro toggle, AI skill)
├── [module_name]/*    ← module directories
├── functions.hpp      ← central function registration
└── rsc.hpp            ← UI resource definitions
```

## Modules

For the full list with function tags and documentation links see **[MODULE_INDEX.md](MODULE_INDEX.md)**.

## References

- [QUICKSTART.md](QUICKSTART.md)
- [MODULE_INDEX.md](MODULE_INDEX.md)
- [.github/copilot-instructions.md](.github/copilot-instructions.md)
- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)