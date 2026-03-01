/*
    Description:
    Calculates and returns the fear value for a group based on casualties, suppression, and morale.

    Usage:
    [group player] call SAS_Morale_calculateGroupFear;
    [player] call SAS_Morale_calculateGroupFear;

    Parameters(s):
    0: OBJECT or GROUP - Group leader or group

    Returns:
    NUMBER - Group fear value (0 to 1)
*/

params ["_group"];
if (isNull _group) exitWith {0};
if (typename _group == "OBJECT") then { _group = group _group; };

// Get units in the group and calculate casualties, suppression, and low morale
private _units = units _group;
private _aliveUnits = _units select {alive _x};
private _casualties = count _units - count _aliveUnits;
private _suppressed = {_x getSuppression > 0.5} count _aliveUnits;
private _lowMorale = {_x behaviour == "COMBAT" && _x morale < 0.3} count _aliveUnits;
private _groupFear = 0;

// Return 0 if whole group is dead
if (count _aliveUnits == 0) exitWith {0};

// Calculate fear based on casualties, suppression, and low morale
_groupFear = _groupFear + (_casualties / (count _units max 1)) * 0.5;
_groupFear = _groupFear + (_suppressed / (count _units max 1)) * 0.3;
_groupFear = _groupFear + (_lowMorale / (count _units max 1)) * 0.2;
_groupFear = _groupFear max 0 min 1;


// Return the calculated fear value
_groupFear;