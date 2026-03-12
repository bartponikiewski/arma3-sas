/*
    Description:
    Assigns a simple patrol task to a group using BIS_fnc_taskPatrol. Optionally creates map markers for each generated waypoint if debug is enabled.

    Usage:
    [group, position, distance, blacklist] call SAS_Task_fnc_patrol;

    Parameter(s):
    0: Group - the group to patrol
    1: Position - the position on which to base the patrol
    2: Number - maximum distance between waypoints in meters
    3: (Optional) Array - blacklist of areas (default: [])

    Returns:
    Boolean - true if patrol task assigned, false otherwise

    Debug:
    If SAS_Debug_global is true, creates map markers for each generated waypoint.
    Calls SAS_fnc_logDebug to output debug information.
*/

params ["_group", "_position", "_distance", ["_blacklist", []]];

if (isNull _group) exitWith {
    ["[SAS_task_fnc_patrol] ERROR: Group is null"] call SAS_fnc_logDebug;
    false
};

if (!local _group) exitWith {
    ["[SAS_task_fnc_patrol] ERROR: Group is not local"] call SAS_fnc_logDebug;
    false
};

private _result = [_group, _position, _distance, _blacklist] call BIS_fnc_taskPatrol;
_group setBehaviour "SAFE";

private _debugGlobal = missionNamespace getVariable ["SAS_Debug_global", false];
if (_debugGlobal) then {
    private _wps = waypoints _group;
    {
        private _wpPos = waypointPosition _x;
        private _marker = createMarker [format ["sas_patrol_wp_%1_%2", groupId _group, _forEachIndex], _wpPos];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "mil_dot";
        _marker setMarkerColor "ColorYellow";
        _marker setMarkerText format ["Patrol WP %1", _forEachIndex + 1];
    } forEach _wps;
    [format ["[SAS_task_fnc_patrol] Created %1 waypoints for group %2", count _wps, groupId _group]] call SAS_fnc_logDebug;
};

_result;