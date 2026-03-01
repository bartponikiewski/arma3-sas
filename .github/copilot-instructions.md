Here’s the **full, clean Markdown file** without any backticks that could break rendering. Everything is plain Markdown text, ready to copy.

---

# copilot-instructions.md

# Guidance for AI Coding Agents Working on this Arma 3 Mission

This repository is an Arma 3 mission package. The project is developing **SAS**, a modular framework to support scripts and mission-makers.

This document provides guidance on **architecture, modular patterns, best practices, and function registration**, while ensuring mission safety and engine compatibility.

---

## Overall Architecture Principles

* Modular Framework (SAS): All scripts, systems, and assets should be developed within SAS, providing a consistent structure for mission-makers and developers.
* Separation of Concerns: Each module should have a single responsibility. Modules must not directly manipulate internal state of other modules. Communication should occur via public interfaces or shared, namespaced variables.
* Scalability: Design systems to scale from small to large missions. Prefer group-level evaluations or event-driven triggers rather than per-unit or per-frame polling.
* Engine Awareness: Leverage Arma 3 engine mechanics (AI behavior, suppression, fleeing, perception, FSM states) instead of duplicating or overriding them manually.

---

## Module Structure

* Modules: Each module is a self-contained folder that may include:

  * Public and private functions
  * Scripts supporting system behavior
  * Assets such as sounds, images, or configuration files
* Organization: Maintain a consistent folder structure and naming conventions to ensure engine recognition and ease of maintenance.

Example module pattern (conceptual):

sas/
<module_name>/
functions/
script1.sqf
script2.sqf
assets/
sound1.ogg
image1.paa
config/
config.cpp

* Central Registration: All publicly callable functions in a module must be declared in a central include (for example, sas/description.cpp) for engine registration.

---

## Function Naming & Registration

### Naming Pattern

* All public functions follow the SAS convention:

SAS_<module_name>_fnc_<function_name>

Guidelines:

* <module_name> is short and descriptive.
* <function_name> indicates the action or behavior.
* *fnc* must remain in the middle to comply with engine standards.

SAS_<Module>_fnc_<Action>


### Module-Based Registration

* Each module’s functions should be registered under a dedicated class in the central include file in sas/description.cpp (or similar), following the pattern:

Example registration structure:
    class SAS_<Module_name>
    {
        class <module_name>
        {
            file = "sas/<module_name>/functions";
            class <function_name1> {};
            class <function_name2> {};
        };
    };

* Only functions intended for cross-module use should be registered; helpers remain internal.

### Calling Functions

[*arguments] call SAS_<module_name>_fnc_<function_name>;

* Respect public vs private scope when calling functions.

---

## Function File Documentation Standard

All function files must begin with a standardized header block in the following format:

/*
    Description:
    <Short summary of what the function does>

    Usage:
    <Example of how to call the function, including argument structure>

    Parameters(s):
    0: <Type> - <Description>
    1: (Optional): <Type> - <Description> (default: <value>)
    ...

    Returns:
    <Type or description of return value>
    
*/

Add inline comments within the function body to explain complex logic.

This ensures every function is self-documenting, easy to onboard, and consistent across the SAS framework. Update all new and existing function files to comply with this format.
---

## Mission Initialization & Runtime Logic

* Place startup logic in init.sqf.
* Invoke SAS-registered functions from init.sqf instead of embedding operational logic directly.
* Modular initialization ensures clear separation between mission startup and module behavior.

---

## Mission File Handling

* Do not edit mission.sqm manually. It is binary and should only be modified using the Arma 3 editor.
* Treat .sqm changes as manual edits performed in-game.
* Avoid assumptions about file structure outside of engine-safe operations.

---

## State & Variable Management

* Use namespaced variables for all persistent or shared state:

<ProjectTag>*<Module>*<State>

**Variable Naming Convention:**
All variable names must start with a lowercase letter after the module prefix. For example:

SAS_MyModule_myVar (correct)
SAS_MyModule_MyVar (incorrect)

This ensures consistency and avoids confusion with class or type names. Update all new and existing variables to comply with this format.

* Expose only what is necessary to other modules; keep internal module state local.
* Avoid generic global variables; clearly indicate the source module or system.

---

## AI & System Design Guidelines

* Knowledge Sources: Reference official Arma 3 documentation for commands, classes, and AI behavior mechanics.
* Engine States: Base logic on built-in states (behavior, suppression, fleeing, perception) rather than replicating internal engine calculations.
* Group-Level Decisions: Perform decision-making at group or system level for realism and efficiency.
* Event-Driven Logic: Prefer reacting to engine events instead of continuous polling to reduce computational overhead.

---

## Best Practices Summary

1. Consistency: Maintain consistent naming conventions, variable namespacing, folder structures, and registration patterns within SAS.
2. Modularity: Modules should have clear responsibilities and communicate only via public functions or shared state.
3. Engine Compatibility: Respect AI mechanics and FSMs. Design systems to react rather than override engine behavior.
4. Performance: Favor group-based, scheduled, or event-driven logic over per-unit or per-frame loops.
5. Documentation & References: Rely on official Arma 3 documentation and community best practices.
6. File Integrity: Never modify mission files manually outside the editor. Keep CfgFunctions include paths intact.
7. Framework Alignment: All new functionality—including functions, scripts, and assets—should follow SAS framework conventions, maintaining a unified system for mission-makers and script developers.

---

This guidance ensures that any additions maintain **modular architecture, predictable AI and system behavior, engine compatibility, file integrity**, and consistent **function registration patterns** within the SAS framework.

```

---

If you want, I can also produce a **Markdown diagram showing the SAS module structure** including functions and assets, which makes onboarding easier without naming actual modules.  

Do you want me to create that diagram next?
```
