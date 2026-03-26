/*
    Description:
    Spawns an exact clone of a cached group template at the given position.
    Recreates all units with loadouts, vehicles, and crew assignments.

    Usage:
    ["patrolTemplate", getMarkerPos "spawn"] call SAS_Cache_fnc_spawnGroup;
    ["patrolTemplate", getMarkerPos "spawn", east] call SAS_Cache_fnc_spawnGroup;

    Parameter(s):
    0: STRING - Template name
    1: ARRAY - World position [x, y, z]
    2: SIDE - (optional) Side override, defaults to template's stored side

    Returns:
    GROUP - The newly created group, or grpNull on failure
*/

if (!isServer) exitWith {
    ["[spawnGroup] Must run on server"] call SAS_fnc_logDebug;
    grpNull
};

params [
    ["_name", "", [""]],
    ["_pos", [], [[]]],
    ["_side", sideEmpty, [west]]
];

private _template = [_name] call SAS_Cache_fnc_getCache;

if (isNil "_template") exitWith {
    [format ["[spawnGroup] Template '%1' not found", _name]] call SAS_fnc_logDebug;
    grpNull
};

if (_side isEqualTo sideEmpty) then {
    _side = _template get "side";
};

// Create group
private _newGroup = createGroup [_side, true];

// Spawn vehicles first
private _vehicleData = _template get "vehicles";
private _spawnedVehicles = [];
{
    private _vehPos = _pos vectorAdd (_x get "offset");
    private _veh = createVehicle [_x get "classname", _vehPos, [], 0, "NONE"];
    _veh setPos _vehPos;
    _spawnedVehicles pushBack _veh;
} forEach _vehicleData;

// Spawn units
private _unitData = _template get "units";
private _leaderUnit = objNull;
{
    private _unitMap = _x;
    private _unitPos = _pos vectorAdd (_unitMap get "offset");

    private _unit = _newGroup createUnit [_unitMap get "classname", _unitPos, [], 0, "NONE"];
    _unit setUnitLoadout (_unitMap get "loadout");

    if (_unitMap get "isLeader") then {
        _leaderUnit = _unit;
    };

    // Assign to vehicle if applicable
    private _vehIdx = _unitMap get "vehicleIdx";
    if (_vehIdx >= 0) then {
        private _veh = _spawnedVehicles select _vehIdx;
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

// Set leader
if (!isNull _leaderUnit) then {
    _newGroup selectLeader _leaderUnit;
};

[format ["[spawnGroup] Spawned '%1': %2 units, %3 vehicles at %4", _name, count _unitData, count _vehicleData, _pos]] call SAS_fnc_logDebug;

_newGroup
