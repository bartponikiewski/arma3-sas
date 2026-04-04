---
name: sas-framework
applyTo: "**"
description: "Use when: working on SAS modules, scripts, or assets. Enforce modularity, naming conventions, and documentation standards for Arma 3 mission scripting."
---

# SAS Framework Coding Instructions

This repository **is** the SAS framework. It is used as a git submodule (or copy) placed at `sas/` inside an Arma 3 mission. The repo root becomes `sas/` — there is no `sas/` folder within this repo.

## Use when
- Editing or creating files in this repository
- Adding new modules, functions, or assets to SAS
- Refactoring or reviewing SAS code

## Principles
1. **Modular Structure**: Each module must be self-contained, with clear separation of concerns. No direct manipulation of other modules' internal state.
2. **Naming Convention**: Public functions must follow `SAS_<module>_fnc_<action>`. Variables must be namespaced and start with a lowercase letter after the module prefix.
3. **Documentation**: All function files must start with a standardized header block describing usage, parameters, return values, and debug logic.
4. **Debug Logging**: Use `SAS_fnc_logDebug` for all debug output. Document debug usage in the function header.
5. **Registration**: Register public functions in the central include file (`functions.hpp`). Helpers remain internal.
6. **Engine Compatibility**: Leverage Arma 3 engine mechanics; avoid manual overrides unless necessary.
7. **Performance**: Prefer group/event-driven logic over per-unit/per-frame polling.
8. **File Integrity**: Never manually edit mission.sqm; use the Arma 3 editor.

## Example Prompts
- "Add a new SAS module for helicopter extraction."
- "Refactor SAS_morale_fnc_update to follow documentation standards."
- "Register SAS_gunship_fnc_createGunship in the central include."

## Related Customizations
- Debug logging instructions
- Function header template
- Module registration checklist

---

This instruction enforces SAS framework standards for modularity, naming, documentation, and engine compatibility in Arma 3 mission scripting.