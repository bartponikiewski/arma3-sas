/*
    Description:
    Sets whether the group can be called as reinforcement.

    Usage:
    [group, true] call SAS_Reinforcement_fnc_setCanBeCalled;

    Parameter(s):
    0: GROUP - The group to set
    1: BOOL - Whether the group can be called as reinforcement

    Returns:
    BOOL - true if set, false otherwise

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group", "_canBeCalled"];
if (isNull _group) exitWith {false};
if (!local _group) exitWith {false};

_group setVariable ["SAS_Reinforcement_canBeCalled", _canBeCalled, true];

[format ["[Reinforcement] setCanBeCalled: group=%1 canBeCalled=%2", _group, _canBeCalled]] call SAS_fnc_logDebug;
true;