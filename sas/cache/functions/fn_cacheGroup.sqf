/*
    Description:
    Caches a group as a reusable template. Stores unit classnames, vehicle
    classnames, side, behaviour, and original position under a string name.

    Usage:
    [myGroup, "patrolTemplate"] call SAS_Cache_fnc_cacheGroup;
    [leader myGroup, "patrolTemplate", true] call SAS_Cache_fnc_cacheGroup;

    Parameter(s):
    0: GROUP or OBJECT - Group or unit (resolved to group)
    1: STRING - Template name
    2: BOOL - Delete group after caching (default: true)

    Returns:
    BOOL - true on success
*/

params [
    ["_group", grpNull, [grpNull, objNull]],
    ["_name", "", [""]],
    ["_deleteAfter", true, [false]]
];

if (!isServer) exitWith {
    ["[cacheGroup] Must run on server"] call SAS_fnc_logDebug;
    false
};


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

// Collect unique crewed vehicles
private _groupVehicles = [];
{ _groupVehicles pushBackUnique (vehicle _x) } forEach (units _group select { vehicle _x != _x });

// Infantry classnames (units not inside vehicles)
private _infantryClasses = [];
{ _infantryClasses pushBack (typeOf _x) } forEach (units _group select { vehicle _x == _x });

// Vehicle classnames
private _vehicleClasses = [];
{ _vehicleClasses pushBack (typeOf _x) } forEach _groupVehicles;

// Assemble template
private _template = createHashMap;
_template set ["side", side _group];
_template set ["position", getPos _leader];
_template set ["behaviour", behaviour _leader];
_template set ["infantry", _infantryClasses];
_template set ["vehicles", _vehicleClasses];

missionNamespace setVariable [format ["SAS_Cache_%1", _name], _template];

[format ["[cacheGroup] Cached '%1': %2 infantry, %3 vehicles", _name, count _infantryClasses, count _vehicleClasses]] call SAS_fnc_logDebug;

// Optional deletion
if (_deleteAfter) then {
    { deleteVehicle _x } forEach _groupVehicles;
    { deleteVehicle _x } forEach units _group;
    deleteGroup _group;
    [format ["[cacheGroup] Deleted original group for '%1'", _name]] call SAS_fnc_logDebug;
};

true
