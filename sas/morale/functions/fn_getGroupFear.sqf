/*
    Description:
    Get current group fear.

    Usage:
    [group player] call SAS_Morale_fnc_getGroupFear;
    [player] call SAS_Morale_fnc_getGroupFear;

    Parameters(s):
    0: OBJECT or GROUP - Group leader or group

    Returns:
    NUMBER - Group fear value (0 to 1)
*/

params ["_group"];
if (isNull _group) exitWith {0};
if (typename _group == "OBJECT") then { _group = group _group; };

_group getVariable ["SAS_Morale_groupFear", 0];
