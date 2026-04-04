---
name: SAS Workspace Instructions
applyTo: "**"
description: "Workspace instructions for SAS framework mission scripting. Enforces modularity, naming conventions, documentation, and engine compatibility."
---

# SAS Workspace Instructions

This repository **is** the SAS framework. It is designed to be used as a git submodule (or copy) placed at `sas/` inside an Arma 3 mission directory. The repo root becomes `sas/` in the mission — there is no `sas/` folder within this repo itself.

## Principles
- **Modular Structure:** Each module is a self-contained directory at the repo root (e.g., `common/`, `briefing/`, `task/`). See [README.md](../README.md) for module overview and links.
- **Naming Convention:** Public functions follow `SAS_<module>_fnc_<action>`. See [sas-framework.instructions.md](.github/instructions/sas-framework.instructions.md) for details.
- **Documentation:** Each module has a README describing its purpose, key functions, and usage. All function files start with a standardized header block.
- **Debug Logging:** Use `SAS_fnc_logDebug` for debug output. Enable `SAS_Debug_global` for debugging.
- **Registration:** Register public functions in [functions.hpp](../functions.hpp).
- **Engine Compatibility:** Leverage Arma 3 engine mechanics; avoid manual overrides unless necessary.
- **Performance:** Prefer group/event-driven logic over per-unit/per-frame polling.
- **File Integrity:** Never manually edit mission.sqm; use the Arma 3 editor.

## Onboarding & Testing
- A separate test mission repo ([arma3-sas-mission](https://github.com/bartponikiewski/arma3-sas-mission)) uses this framework as a submodule and demonstrates all core SAS systems.
- See [README.md](../README.md) for onboarding, module overview, and example usage.

## References
- [README.md](../README.md) — Module overview and documentation links
- [sas-framework.instructions.md](.github/instructions/sas-framework.instructions.md) — Coding standards and architecture
- [copilot-instructions.md](.github/copilot-instructions.md) — Workspace agent instructions
- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)

## Example Prompts
- "Add a new SAS module for helicopter extraction."
- "Refactor SAS_morale_fnc_update to follow documentation standards."
- "Register SAS_gunship_fnc_createGunship in the central include."

---

This file enforces SAS framework standards for modularity, naming, documentation, and engine compatibility. Link to module docs and standards; do not duplicate content.
