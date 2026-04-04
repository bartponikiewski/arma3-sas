/*
    Description:
    Switches the side of a unit or all units in a group to the specified side. For units, moves them to a new group of the target side. 
	For groups, moves all members to a new group of the target side and deletes the old group if empty.

	Be aware that this can break all scripts initiated for the group or unit, so use with caution. Always test after using this function.

    Usage:
    [entity, side] call SAS_fnc_switchSide;

    Parameter(s):
    0: OBJECT/GROUP - Unit or group to switch side
    1: SIDE - Target side

    Returns:
    _grp  new group created for the unit or group with the new side, or false if there was an error
    
    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_entity", "_side"];

if (isNull _entity || isNil "_side" || _side == sideEnemy) exitWith {
    [format ["[switchSide] Invalid entity or side: %1, %2", _entity, _side]] call SAS_fnc_logDebug;
    false
};

if (!local _entity) exitWith {
	[format ["[switchSide] Entity %1 is not local", _entity]] call SAS_fnc_logDebug;
	false
};

private _currentGroup = if (typeName _entity == "OBJECT") then { group _entity } else { _entity };
private _newGroup = createGroup [_side, false];

{
    [_x] joinSilent _newGroup;
} forEach units _currentGroup;

_newGroup deleteGroupWhenEmpty true;

[format ["[switchSide] %1 switched to side %2, to new group %3", _entity, _side, _newGroup]] call SAS_fnc_logDebug;

_newGroup;
