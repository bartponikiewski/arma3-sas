/*
    Description:
    Finds the nearest available reinforcement group to the given group, filtering by eligibility and availability.

    Usage:
    [group] call SAS_Reinforcement_fnc_findNearestReinforcementGroup;

    Parameter(s):
    0: GROUP - The group requesting reinforcements

    Returns:
    GROUP - The nearest available reinforcement group, or grpNull if none found

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group"];

// Get registered reinforcement groups and filter by eligibility and availability
private _reinforcementGroups = [] call SAS_Reinforcement_fnc_getRegisteredReinforcementGroups;

// Filter groups that are not the requesting group, can be called as reinforcement, and have a valid leader
private _availableGroups = _reinforcementGroups select {
    _x != _group &&
    [_x] call SAS_Reinforcement_fnc_getCanBeCalled &&
    !isNull (leader _x)
};

// Find nearest group by distance to leader of requesting group
if (_availableGroups isEqualTo []) exitWith {
    ["[Reinforcement] No available reinforcement groups found."] call SAS_fnc_logDebug;
    grpNull
};

// Initialize with first group and compare distances
private _nearestGroup = _availableGroups select 0;
private _minDist = (leader _nearestGroup) distance (leader _group);
{
    private _dist = (leader _x) distance (leader _group);
    if (_dist < _minDist) then {
        _nearestGroup = _x;
        _minDist = _dist;
    };
} forEach _availableGroups;

[format ["[Reinforcement] Nearest reinforcement group to %1 is %2 (distance %3)", _group, _nearestGroup, _minDist]] call SAS_fnc_logDebug;

_nearestGroup;
