# Cache Module

Cache editor-placed groups as reusable templates, then spawn exact clones or scaled infantry squads at runtime. Templates capture unit classnames, loadouts, relative positions, vehicle compositions, and crew assignments under a string name.

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

### Exact clone

```sqf
private _grp = ["patrolTemplate", getMarkerPos "spawn1"] call SAS_Cache_fnc_spawnGroup;

// With side override
private _grp = ["patrolTemplate", getMarkerPos "spawn1", east] call SAS_Cache_fnc_spawnGroup;
```

### Scaled infantry

```sqf
// 8 infantry only (cycles through template unit types)
private _grp = ["patrolTemplate", 8, getMarkerPos "spawn2"] call SAS_Cache_fnc_spawnUnits;

// 6 infantry + all template vehicles with original crew
private _grp = ["patrolTemplate", 6, getMarkerPos "spawn2", nil, true] call SAS_Cache_fnc_spawnUnits;
```

## Functions

| Function | Description |
|----------|-------------|
| `SAS_Cache_fnc_cacheGroup` | Serialize a group (units, loadouts, vehicles, crew roles) into a named template |
| `SAS_Cache_fnc_getCache` | Retrieve a cached template by name (returns hashmap or nil) |
| `SAS_Cache_fnc_spawnGroup` | Spawn an exact clone of a cached template at a position |
| `SAS_Cache_fnc_spawnUnits` | Spawn N infantry from a template, optionally with all template vehicles and crew |

## Variables

Templates are stored as individual `missionNamespace` variables:

| Variable | Type | Description |
|----------|------|-------------|
| `SAS_Cache_<name>` | HashMap | Template data for the given name |

## Notes

- All functions are **server-only** (`isServer` guard).
- Only vehicles with crew from the group are captured. Empty/uncrewed vehicles are not included.
- `spawnUnits` with `_withVehicles = true` spawns all template vehicles with their original crew **on top of** the N infantry count.
- If a template has no dismounted infantry (all units are vehicle crew), `spawnUnits` falls back to using all unit types as the cycling pool, spawning them on foot.
- Vehicle crew roles use simple driver/gunner/commander/cargo assignment. Multi-turret vehicles default to the primary turret.

## Debugging

All functions log via `SAS_fnc_logDebug` when `SAS_Debug_global` is `true`.
