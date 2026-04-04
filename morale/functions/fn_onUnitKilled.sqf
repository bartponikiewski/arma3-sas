/*
    Description:
    Handles unit killed event for morale system. Adds killed unit to group casualties array, recalculates group fear, and emits groupFearChanged event if fear changes.

    Usage:
    [unit] call SAS_Morale_fnc_onUnitKilled;

    Parameters(s):
    0: OBJECT - Killed unit

    Returns:
    Nothing
*/

params ["_group", "_unit", "_killer", "_instigator", "_useEffects"];
if (isNull _group || isNull _unit) exitWith {};

// Ensure this is a local group to avoid processing remote events
if (!local _group) exitWith {};

// Add killed unit to casualties array
private _casualties = _group getVariable ["SAS_Morale_casualties", []];
if (!(_unit in _casualties)) then {
    _casualties pushBack _unit;
    _group setVariable ["SAS_Morale_casualties", _casualties, true];
};

// Recalculate group fear
private _oldFear = _group getVariable ["SAS_Morale_groupFear", 0];
private _newFear = [_group] call SAS_Morale_fnc_calculateGroupFear;

// Save new fear value
_group setVariable ["SAS_Morale_groupFear", _newFear, true];

// Ensure at least one unit in group is alive before emitting event
if ({alive _x} count (units _group) == 0) exitWith {};

// Emit event if fear changed
if (_newFear != _oldFear) then {
    [_group, "SAS_Morale_groupFearChanged", [_group, _oldFear, _newFear]] call BIS_fnc_callScriptedEventHandler;
};
