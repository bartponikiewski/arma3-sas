/*
    Description:
    Spawns N infantry units based on a cached group template, cycling through
    the template's unit types. Optionally spawns all template vehicles with
    their original crew on top of the infantry count.

    Usage:
    ["patrolTemplate", 8, getMarkerPos "spawn"] call SAS_Cache_fnc_spawnUnits;
    ["patrolTemplate", 6, getMarkerPos "spawn", east, true] call SAS_Cache_fnc_spawnUnits;

    Parameter(s):
    0: STRING - Template name
    1: NUMBER - Number of infantry units to spawn
    2: ARRAY - World position [x, y, z]
    3: SIDE - (optional) Side override, defaults to template's stored side
    4: BOOL - (optional) Spawn vehicles with crew (default: false)

    Returns:
    GROUP - The newly created group, or grpNull on failure
*/

if (!isServer) exitWith {
    ["[spawnUnits] Must run on server"] call SAS_fnc_logDebug;
    grpNull
};

params [
    ["_name", "", [""]],
    ["_count", 0, [0]],
    ["_pos", [], [[]]],
    ["_side", sideEmpty, [west]],
    ["_withVehicles", false, [false]]
];

private _template = [_name] call SAS_Cache_fnc_getCache;

if (isNil "_template") exitWith {
    [format ["[spawnUnits] Template '%1' not found", _name]] call SAS_fnc_logDebug;
    grpNull
};

if (_count <= 0) exitWith {
    ["[spawnUnits] Count must be greater than 0"] call SAS_fnc_logDebug;
    grpNull
};

if (_side isEqualTo sideEmpty) then {
    _side = _template get "side";
};

private _unitData = _template get "units";

// Create group
private _newGroup = createGroup [_side, true];

// Spawn vehicles with crew if requested
if (_withVehicles) then {
    private _vehicleData = _template get "vehicles";
    private _spawnedVehicles = [];

    // Create vehicles
    {
        private _vehPos = _pos vectorAdd (_x get "offset");
        private _veh = createVehicle [_x get "classname", _vehPos, [], 0, "NONE"];
        _veh setPos _vehPos;
        _spawnedVehicles pushBack _veh;
    } forEach _vehicleData;

    // Create crew units from template
    {
        private _unitMap = _x;
        private _vehIdx = _unitMap get "vehicleIdx";

        if (_vehIdx >= 0) then {
            private _veh = _spawnedVehicles select _vehIdx;
            private _unitPos = _pos vectorAdd (_unitMap get "offset");

            private _unit = _newGroup createUnit [_unitMap get "classname", _unitPos, [], 0, "NONE"];
            _unit setUnitLoadout (_unitMap get "loadout");

            private _role = _unitMap get "vehicleRole";
            switch (_role) do {
                case "driver": {
                    _unit assignAsDriver _veh;
                    _unit moveInDriver _veh;
                };
                case "gunner": {
                    _unit assignAsGunner _veh;
                    _unit moveInGunner _veh;
                };
                case "commander": {
                    _unit assignAsCommander _veh;
                    _unit moveInCommander _veh;
                };
                case "cargo": {
                    _unit assignAsCargo _veh;
                    _unit moveInCargo _veh;
                };
            };
        };
    } forEach _unitData;

    [format ["[spawnUnits] Spawned %1 vehicles with crew for '%2'", count _vehicleData, _name]] call SAS_fnc_logDebug;
};

// Build infantry pool (dismounted units only)
private _infantryPool = _unitData select { (_x get "vehicleIdx") == -1 };

// Fallback: if all units are vehicle crew, use all unit types as infantry pool
if (count _infantryPool == 0) then {
    _infantryPool = _unitData;
};

// Spawn N infantry, cycling through pool
private _poolSize = count _infantryPool;
for "_i" from 0 to (_count - 1) do {
    private _unitMap = _infantryPool select (_i mod _poolSize);
    private _unitPos = _pos getPos [2 + random 5, random 360];

    private _unit = _newGroup createUnit [_unitMap get "classname", _unitPos, [], 0, "NONE"];
    _unit setUnitLoadout (_unitMap get "loadout");
};

[format ["[spawnUnits] Spawned %1 infantry from '%2' (withVehicles: %3)", _count, _name, _withVehicles]] call SAS_fnc_logDebug;

_newGroup
