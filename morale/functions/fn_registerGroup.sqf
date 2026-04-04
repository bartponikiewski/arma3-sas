/*
    Description:
    Registers a group into the morale system by storing its initial unit count as a group variable.

    Usage:
    [group player] call SAS_Morale_fnc_registerGroup;
    [player] call SAS_Morale_fnc_registerGroup;

    Parameters(s):
    0: OBJECT or GROUP - Group leader or group

    Returns:
    BOOL - true if registered, false if already registered or invalid
*/

params ["_group"];
if (isNull _group) exitWith {false};
if (typename _group == "OBJECT") then { _group = group _group; };

// Ensure this is a local group to avoid registering remote groups
if (!local _group) exitWith {false};

// Check if already registered
if (!isNil {_group getVariable "SAS_Morale_registered"}) exitWith {false};

// Set casualties array and initial groupFear
_group setVariable ["SAS_Morale_registered", true, true];
_group setVariable ["SAS_Morale_casualties", [], true];
_group setVariable ["SAS_Morale_groupFear", 0, true];

// Add group-level UnitKilled event handler
_group addEventHandler ["UnitKilled", {
    params ["_group", "_unit", "_killer", "_instigator", "_useEffects"];
    [_group, _unit, _killer, _instigator, _useEffects] call SAS_Morale_fnc_onUnitKilled;
}];
true;