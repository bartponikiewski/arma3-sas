---
name: SAS Workspace Instructions
applyTo: sas/**
description: "Workspace instructions for SAS framework mission scripting. Enforces modularity, naming conventions, documentation, and engine compatibility."
---

# SAS Workspace Instructions

## Principles
- **Modular Structure:** All mission logic lives under `sas/`, organized into self-contained modules. See [sas/README.md](sas/README.md) for module overview and links.
- **Naming Convention:** Public functions follow `SAS_<module>_fnc_<action>`. See [sas-framework.instructions.md](.github/instructions/sas-framework.instructions.md) for details.
- **Documentation:** Each module has a README describing its purpose, key functions, and usage. All function files start with a standardized header block.
- **Debug Logging:** Use `SAS_fnc_logDebug` for debug output. Enable `SAS_Debug_global` for debugging.
- **Registration:** Register public functions in [sas/functions.hpp](sas/functions.hpp).
- **Engine Compatibility:** Leverage Arma 3 engine mechanics; avoid manual overrides unless necessary.
- **Performance:** Prefer group/event-driven logic over per-unit/per-frame polling.
- **File Integrity:** Never manually edit mission.sqm; use the Arma 3 editor.

## Onboarding & Testing
- The mission is a playground for SAS development. See [README.md](README.md) for onboarding, module overview, and example usage.
- Actions and scripts in [init.sqf](init.sqf) and [initPlayerLocal.sqf](initPlayerLocal.sqf) demonstrate all core SAS systems.

## References
- [sas/README.md](sas/README.md) — Module overview and documentation links
- [sas-framework.instructions.md](.github/instructions/sas-framework.instructions.md) — Coding standards and architecture
- [copilot-instructions.md](.github/copilot-instructions.md) — Workspace agent instructions
- [Arma 3 SQF Reference](https://community.bistudio.com/wiki/Category:Scripting_Commands)
- [CfgFunctions reference](https://community.bistudio.com/wiki/Arma_3:_Functions_Library)

## Example Prompts
- "Add a new SAS module for helicopter extraction."
- "Refactor SAS_morale_fnc_update to follow documentation standards."
- "Register SAS_gunship_fnc_createGunship in the central include."

---

This file enforces SAS framework standards for modularity, naming, documentation, and engine compatibility. Link to module docs and standards; do not duplicate content. Use for all work in the `sas/` directory.
