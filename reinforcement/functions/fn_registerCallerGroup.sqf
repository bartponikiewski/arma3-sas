/*
    Description:
    Registers a group as a caller (can request reinforcements), adds the fear change event handler, and ensures morale registration.

    Usage:
    [group] call SAS_Reinforcement_fnc_registerCallerGroup;

    Parameter(s):
    0: GROUP - The group to register as a caller

    Returns:
    BOOL - true if registered, false if invalid

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group"];
if (isNull _group) exitWith {false};
if (!local _group) exitWith {false};

[_group, true] call SAS_Reinforcement_fnc_setCanCall;

[missionNamespace, "SAS_Morale_groupFearChanged", {
    params ["_group", "_oldFear", "_newFear"];
    [_group, _oldFear, _newFear] call SAS_Reinforcement_fnc_onGroupFearChanged;
}] call BIS_fnc_addScriptedEventHandler;

if (!(_group getVariable ["SAS_Morale_registered", false])) then {
    [_group] call SAS_Morale_fnc_registerGroup;
};

[format ["[Reinforcement] Caller group registered: %1", _group]] call SAS_fnc_logDebug;
true;
