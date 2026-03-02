/*
    Description:
    Dispatches a reinforcement group to support a target group at a specified position. Sets response states for both groups and manages waypoints for the reinforcement group.

    Usage:
    [targetGroup, reinforcementGroup, position] call SAS_Reinforcement_fnc_sendReinforcements;

    Parameter(s):
    0: Group - The group requesting support (target)
    1: Group - The group providing support (reinforcement)
    2: Array - The position to send support units to

    Returns:
    Boolean - True if dispatch succeeded, false otherwise

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/
params [
    ["_targetGroup", grpNull, [grpNull, objNull]],
    ["_reinforceGroup", grpNull, [grpNull, objNull]],
    ["_pos", [], [[]]]
];

// Validate
if (count _pos == 0) exitWith {false};
if (isNull _reinforceGroup) exitWith {false};
if (typename _reinforceGroup == "OBJECT") then { _reinforceGroup = group _reinforceGroup; };
if (!local _reinforceGroup) exitWith {false};

// Set group as unavailable to response calls
[_reinforceGroup, false] call SAS_Reinforcement_fnc_setCanCall;

if (SAS_Debug_global) then {
    [format ["[Reinforcement] Group %1 dispatched to support group %2 at %3.", _reinforceGroup, _targetGroup, _pos]] call SAS_fnc_logDebug;
};

// Reset group
[_reinforceGroup] call SAS_fnc_resetGroup;

// Send units
_reinforceGroup setSpeedMode "FULL";

// Get nearest road if exists
private _insertPointPos = _pos;
private _nearestRoad = [_pos, 80] call BIS_fnc_nearestRoad;
if (!isNull _nearestRoad) then {
    _insertPointPos = getPos _nearestRoad;
};

// Move near position
private _wpMove = _reinforceGroup addWaypoint [_insertPointPos, 20];
_wpMove setWaypointType "MOVE";
_wpMove setWaypointBehaviour "AWARE";
_wpMove setWaypointCombatMode "WHITE";
_wpMove setWaypointSpeed "FULL";
    _wpMove setWaypointStatements [
        "this", 
        "hint 'test';"
    ];

// Get out
private _wpGetOut = _reinforceGroup addWaypoint [_insertPointPos, 20];
_wpGetOut setWaypointType "UNLOAD";
_wpGetOut setWaypointBehaviour "AWARE";

// Search & destroy
private _wpSearch = _reinforceGroup addWaypoint [_pos, 100];
_wpSearch setWaypointType "SAD";
_wpSearch setWaypointCombatMode "RED";
_wpSearch setWaypointBehaviour "AWARE";
_wpSearch setWaypointTimeout [60,90,120];
_wpSearch setWaypointCompletionRadius 100;
_wpSearch setWaypointStatements [
        "this", 
        "[group this, true] spawn SAS_Reinforcement_fnc_setCanBeCalled;"
];

true;
