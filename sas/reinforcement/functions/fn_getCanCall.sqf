/*
    Description:
    Gets whether the group can call reinforcements.

    Usage:
    [group] call SAS_Reinforcement_fnc_getCanCall;

    Parameter(s):
    0: GROUP - The group to check

    Returns:
    BOOL - true if can call reinforcements, false otherwise

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group"];
if (isNull _group) exitWith {false};
private _canCall = _group getVariable ["SAS_Reinforcement_canCall", false];
[format ["[Reinforcement] getCanCall: group=%1 canCall=%2", _group, _canCall]] call SAS_fnc_logDebug;
_canCall;