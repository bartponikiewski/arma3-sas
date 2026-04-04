# SAS Common — Logging Sub-module

This sub-module provides centralised debug logging for the SAS framework. All other modules route their debug output through this function, giving mission-makers a single toggle to control verbosity.

## Functions

### `SAS_fnc_logDebug`
Displays a debug hint message in-game when the global debug flag is enabled. Silently does nothing when debugging is off.

**Usage:**
```sqf
["Your debug message here"] call SAS_fnc_logDebug;
```

**Parameters:**
| # | Type | Description |
|---|------|-------------|
| 0 | STRING | The message to display |

**Returns:** Nothing.

**Example:**
```sqf
SAS_Debug_global = true;
["[myModule] Initialising group tracking"] call SAS_fnc_logDebug;
```

## Enabling Debug Output
Set the global variable before calling any SAS functions:
```sqf
SAS_Debug_global = true;
```
Messages will appear as in-game hints prefixed with `[SAS DEBUG]`. Set to `false` (or leave undefined) to suppress all output.

## Notes
- All SAS module functions check `SAS_Debug_global` via this function — never directly.
- Alias `SAS_fnc_logDebug` is used across the framework for brevity (registered as `Logging` class under the `SAS` tag).

## References
- See [copilot-instructions.md](../../../.github/copilot-instructions.md) for architectural and coding standards.
