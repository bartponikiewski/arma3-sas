# Cache Module

Cache editor-placed groups as reusable templates, then spawn new groups at runtime. Templates store unit classnames, vehicle classnames, side, and original position.

## Setup

Cache a group from its editor init or from `init.sqf`:

```sqf
// Cache and keep the original group
[myGroup, "patrolTemplate"] call SAS_Cache_fnc_cacheGroup;

// Cache and delete the original (useful for "virtual" template groups)
[myGroup, "patrolTemplate", true] call SAS_Cache_fnc_cacheGroup;

// Also accepts a unit (resolved to its group)
[leader myGroup, "patrolTemplate", true] call SAS_Cache_fnc_cacheGroup;
```

## Spawning

```sqf
// Spawn at original position with original infantry count
["patrolTemplate"] call SAS_Cache_fnc_spawn;

// Spawn at custom position
["patrolTemplate", getMarkerPos "spawn1"] call SAS_Cache_fnc_spawn;

// Spawn at original position with custom infantry count
["patrolTemplate", nil, 12] call SAS_Cache_fnc_spawn;

// Spawn at custom position with custom infantry count
["patrolTemplate", getMarkerPos "spawn1", 8] call SAS_Cache_fnc_spawn;
```

## Functions

| Function | Description |
|----------|-------------|
| `SAS_Cache_fnc_cacheGroup` | Serialize a group (unit classnames, vehicle classnames, side, position) into a named template |
| `SAS_Cache_fnc_getCache` | Retrieve a cached template by name (returns hashmap or nil) |
| `SAS_Cache_fnc_spawn` | Spawn a group from a cached template with optional position and infantry count |

## Template Structure

Templates are stored as `missionNamespace` variables (`SAS_Cache_<name>`):

| Field | Type | Description |
|-------|------|-------------|
| `side` | Side | Side of the original group |
| `position` | Array | Absolute position of the original leader |
| `infantry` | Array | Classnames of dismounted units |
| `vehicles` | Array | Classnames of crewed vehicles |

## Notes

- All functions are **server-only** (`isServer` guard).
- Only vehicles with crew from the group are captured. Empty/uncrewed vehicles are not included.
- If a template has vehicles, they are **always** spawned alongside infantry.
- Units and vehicles are spawned at safe positions via `BIS_fnc_findSafePos` to avoid rocks, rooftops, and steep terrain.
- Infantry uses `BIS_fnc_spawnGroup`, vehicles use `BIS_fnc_spawnVehicle` — units spawn with class-default loadouts (no loadout preservation).
- If the `SAS_Skills` mission parameter is active (non-AUTO), skills are automatically applied to spawned groups via `SAS_Skills_fnc_set`.
- When a custom infantry count is provided, unit classes cycle through the template's infantry pool.

## Debugging

All functions log via `SAS_fnc_logDebug` when `SAS_Debug_global` is `true`.
