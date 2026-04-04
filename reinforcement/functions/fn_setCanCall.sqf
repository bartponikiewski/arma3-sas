/*
    Description:
    Sets whether the group can call reinforcements.

    Usage:
    [group, true] call SAS_Reinforcement_fnc_setCanCall;

    Parameter(s):
    0: GROUP - The group to set
    1: BOOL - Whether the group can call reinforcements

    Returns:
    BOOL - true if set, false otherwise

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group", "_canCall"];
if (isNull _group) exitWith {false};
if (!local _group) exitWith {false};

_group setVariable ["SAS_Reinforcement_canCall", _canCall, true];

[format ["[Reinforcement] setCanCall: group=%1 canCall=%2", _group, _canCall]] call SAS_fnc_logDebug;
true;