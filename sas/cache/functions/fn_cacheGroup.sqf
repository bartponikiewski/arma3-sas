/*
    Description:
    Caches a group as a reusable template. Stores unit classnames, loadouts,
    relative positions, vehicle compositions and crew assignments under a string name.

    Usage:
    [myGroup, "patrolTemplate"] call SAS_Cache_fnc_cacheGroup;
    [leader myGroup, "patrolTemplate", true] call SAS_Cache_fnc_cacheGroup;

    Parameter(s):
    0: GROUP or OBJECT - Group or unit (resolved to group)
    1: STRING - Template name
    2: BOOL - Delete group after caching (default: false)

    Returns:
    BOOL - true on success
*/

if (!isServer) exitWith {
    ["[cacheGroup] Must run on server"] call SAS_fnc_logDebug;
    false
};

params [
    ["_group", grpNull, [grpNull, objNull]],
    ["_name", "", [""]],
    ["_deleteAfter", false, [false]]
];

if (typeName _group == "OBJECT") then { _group = group _group };

if (isNull _group) exitWith {
    ["[cacheGroup] Invalid group"] call SAS_fnc_logDebug;
    false
};

if (_name isEqualTo "") exitWith {
    ["[cacheGroup] Empty template name"] call SAS_fnc_logDebug;
    false
};

private _leader = leader _group;
private _leaderPos = getPos _leader;

// Collect unique vehicles belonging to group members
private _groupVehicles = [];
{
    private _veh = vehicle _x;
    if (_veh != _x) then {
        _groupVehicles pushBackUnique _veh;
    };
} forEach units _group;

// Build vehicle data
private _vehicleData = [];
{
    private _vehMap = createHashMap;
    _vehMap set ["classname", typeOf _x];
    _vehMap set ["offset", (getPos _x) vectorDiff _leaderPos];
    _vehicleData pushBack _vehMap;
} forEach _groupVehicles;

// Build unit data
private _unitData = [];
{
    private _unit = _x;
    private _unitMap = createHashMap;

    _unitMap set ["classname", typeOf _unit];
    _unitMap set ["loadout", getUnitLoadout _unit];
    _unitMap set ["offset", (getPos _unit) vectorDiff _leaderPos];
    _unitMap set ["isLeader", _unit == _leader];

    private _veh = vehicle _unit;
    if (_veh != _unit) then {
        private _vehIdx = _groupVehicles find _veh;
        _unitMap set ["vehicleIdx", _vehIdx];

        private _role = "cargo";
        if (_unit == driver _veh) then { _role = "driver" };
        if (_unit == gunner _veh) then { _role = "gunner" };
        if (_unit == commander _veh) then { _role = "commander" };

        _unitMap set ["vehicleRole", _role];
    } else {
        _unitMap set ["vehicleIdx", -1];
        _unitMap set ["vehicleRole", ""];
    };

    _unitData pushBack _unitMap;
} forEach units _group;

// Assemble template
private _template = createHashMap;
_template set ["side", side _group];
_template set ["units", _unitData];
_template set ["vehicles", _vehicleData];

// Store as individual variable per template (avoids race condition from editor inits)
missionNamespace setVariable [format ["SAS_Cache_%1", _name], _template];

[format ["[cacheGroup] Cached '%1': %2 units, %3 vehicles", _name, count _unitData, count _vehicleData]] call SAS_fnc_logDebug;

// Optional deletion
if (_deleteAfter) then {
    { deleteVehicle _x } forEach _groupVehicles;
    { deleteVehicle _x } forEach units _group;
    deleteGroup _group;
    [format ["[cacheGroup] Deleted original group for '%1'", _name]] call SAS_fnc_logDebug;
};

true
