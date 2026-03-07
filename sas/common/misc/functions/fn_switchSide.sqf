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
    BOOL - true if successful, false otherwise
    
    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_entity", "_side"];

if (isNull _entity || isNil "_side") exitWith {
    [format ["[switchSide] Invalid entity or side: %1, %2", _entity, _side]] call SAS_fnc_logDebug;
    false
};

if (!local _entity) exitWith {
	[format ["[switchSide] Entity %1 is not local", _entity]] call SAS_fnc_logDebug;
	false
};

private _grp = createGroup [_side, true];
if (typeName _entity == "OBJECT") then {
    // Switch side for a single unit
    
    [_entity] joinSilent _grp;
    [format ["[switchSide] Unit %1 switched to side %2", _entity, _side]] call SAS_fnc_logDebug;
    true
} else {
    if (typeName _entity == "GROUP") then {
        // Switch side for all units in the group
        private _units = units _entity;
        {
            [_x] joinSilent _grp;
        } forEach _units;
        [format ["[switchSide] Group %1 switched to side %2", _entity, _side]] call SAS_fnc_logDebug;
        true
    } else {
        [format ["[switchSide] Unsupported entity type: %1", typeName _entity]] call SAS_fnc_logDebug;
        false
    };
};
