# SAS Common Module

The `common` directory is a meta-module that groups shared utility sub-modules used across the entire SAS framework. These sub-modules provide foundational capabilities that other modules depend on.

## Sub-modules

| Sub-module | Prefix | Description |
|---|---|---|
| [`misc`](misc/README.md) | `SAS_fnc_` | General-purpose utility functions (side-switching, HALO jumps, flares, group reset) |
| [`logging`](logging/README.md) | `SAS_fnc` | Centralised debug logging |
| [`gui`](gui/README.md) | `SAS_fnc` | Generic GUI message dialog with configurable buttons |

## Usage
Refer to each sub-module's README for function signatures, parameters, and examples.

## References
- See [copilot-instructions.md](../../.github/copilot-instructions.md) for architectural and coding standards.
