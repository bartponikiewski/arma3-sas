/*
    Description:
    Calculates and returns the fear value for a group based on casualties, suppression, and morale.

    Usage:
    [group player] call SAS_Morale_fnc_calculateGroupFear;
    [player] call SAS_Morale_fnc_calculateGroupFear;

    Parameters(s):
    0: OBJECT or GROUP - Group leader or group

    Returns:
    NUMBER - Group fear value (0 to 1)
*/

params ["_group"];
if (isNull _group) exitWith {0};
if (typename _group == "OBJECT") then { _group = group _group; };

private _units = units _group;
private _aliveUnits = _units select {alive _x};
private _casualtiesArr = _group getVariable ["SAS_Morale_casualties", []];
private _casualties = count _casualtiesArr;
private _totalUnits = count _units + _casualties; // original group size
private _suppressed = {(getSuppression _x) > 0.5} count _aliveUnits;
private _lowMorale = {(behaviour _x) == "COMBAT" && (morale _x) < 0.3} count _aliveUnits;
private _groupFear = 0;

// If whole group is dead, there is no fear anymore...
if (count _aliveUnits == 0) exitWith {0};

// Main fear calculation
_groupFear = (_casualties / (_totalUnits max 1)) * 0.8;
_groupFear = _groupFear + (_suppressed / (count _aliveUnits max 1)) * 0.2;
_groupFear = _groupFear + (_lowMorale / (count _aliveUnits max 1)) * 0.3;

_groupFear = _groupFear max 0 min 1;

// Debug output
[format ["calculateGroupFear: group=%1 casualties=%2 suppressed=%3 lowMorale=%4 fear=%5", _group, _casualties, _suppressed, _lowMorale, _groupFear]] call SAS_fnc_logDebug;

// Return the calculated fear value
_groupFear;