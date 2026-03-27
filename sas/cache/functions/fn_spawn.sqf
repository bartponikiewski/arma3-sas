/*
    Description:
    Spawns a group from a cached template. Uses BIS_fnc_spawnGroup for infantry
    and BIS_fnc_spawnVehicle for vehicles. Finds safe positions to avoid spawning
    in rocks or on rooftops. Applies mission skill parameter if active.

    Usage:
    ["patrolTemplate"] call SAS_Cache_fnc_spawn;
    ["patrolTemplate", getMarkerPos "spawn"] call SAS_Cache_fnc_spawn;
    ["patrolTemplate", nil, 12] call SAS_Cache_fnc_spawn;
    ["patrolTemplate", getMarkerPos "spawn", 8] call SAS_Cache_fnc_spawn;

    Parameter(s):
    0: STRING - Template name (required)
    1: ARRAY  - Position [x,y,z] (optional, defaults to template's stored position)
    2: NUMBER - Infantry count (optional, defaults to template's infantry count)

    Returns:
    GROUP - The spawned group, or grpNull on failure
*/

params [
    ["_name", "", [""]],
    ["_pos", [], [[]]],
    ["_count", -1, [0]]
];

if (!isServer) exitWith {
    ["[spawn] Must run on server"] call SAS_fnc_logDebug;
    grpNull
};

private _template = [_name] call SAS_Cache_fnc_getCache;

if (isNil "_template") exitWith {
    [format ["[spawn] Template '%1' not found", _name]] call SAS_fnc_logDebug;
    grpNull
};

private _side = _template get "side";
private _templatePos = _template get "position";
private _infantryClasses = _template get "infantry";
private _vehicleClasses = _template get "vehicles";

// Resolve position
if (_pos isEqualTo []) then {
    _pos = _templatePos;
};

// Resolve infantry count
if (_count == -1) then {
    _count = count _infantryClasses;
};

private _poolSize = count _infantryClasses;
private _newGroup = grpNull;

// Spawn infantry
if (_count > 0 && _poolSize > 0) then {
    // Build class array by cycling through template classes
    private _classArray = [];
    for "_i" from 0 to (_count - 1) do {
        _classArray pushBack (_infantryClasses select (_i mod _poolSize));
    };

    // Find safe position for infantry
    private _safePos = [_pos, 0, 50, 3, 0, 0.3, 0] call BIS_fnc_findSafePos;
    _newGroup = [_safePos, _side, _classArray] call BIS_fnc_spawnGroup;
} else {
    _newGroup = createGroup [_side, true];
};

// Always spawn vehicles if template has them
{
    private _vehSafePos = [_pos, 10, 100, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
    private _spawned = [_vehSafePos, random 360, _x, _side] call BIS_fnc_spawnVehicle;
    _spawned params ["_veh", "_crew", "_vehGrp"];

    { [_x] joinSilent _newGroup } forEach _crew;
    deleteGroup _vehGrp;
} forEach _vehicleClasses;

// Apply skills if mission parameter is active
private _skillParam = "SAS_Skills" call BIS_fnc_getParamValue;
if (!isNil "_skillParam" && {_skillParam > 0}) then {
    private _levels = ["AUTO", "NORMAL", "GOOD", "SPECOPS"];
    [_newGroup, _levels select _skillParam] call SAS_Skills_fnc_set;
};

// Apply behaviour from template
private _behaviour = _template getOrDefault ["behaviour", "AWARE"];
_newGroup setBehaviour _behaviour;

[format ["[spawn] Spawned '%1': %2 infantry, %3 vehicles at %4", _name, _count, count _vehicleClasses, _pos]] call SAS_fnc_logDebug;

_newGroup
