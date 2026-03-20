# SAS Params Module

This module provides mission parameter configuration for Arma 3 missions. Key features include skill and intro parameter setup via .hpp files.

## Key Files

- `paramSkills.hpp`: Defines skill-related mission parameters
- `paramIntro.hpp`: Defines intro-related mission parameters

## Usage
Include parameter files in your mission's `description.ext` or relevant config.

**Example:**
```
#include "sas/params/paramSkills.hpp"
#include "sas/params/paramIntro.hpp"
```

## Debugging
Enable `SAS_Debug_global` for debug output if parameter scripts support logging.

## Standards
Follow [copilot-instructions.md](../.github/copilot-instructions.md) for documentation and coding conventions.
