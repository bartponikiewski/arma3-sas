/*
    Description:
    Gets whether the group can be called as reinforcement.

    Usage:
    [group] call SAS_Reinforcement_fnc_getCanBeCalled;

    Parameter(s):
    0: GROUP - The group to check

    Returns:
    BOOL - true if can be called as reinforcement, false otherwise

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group"];
if (isNull _group) exitWith {false};
private _canBeCalled = _group getVariable ["SAS_Reinforcement_canBeCalled", false];
[format ["[Reinforcement] getCanBeCalled: group=%1 canBeCalled=%2", _group, _canBeCalled]] call SAS_fnc_logDebug;
_canBeCalled;