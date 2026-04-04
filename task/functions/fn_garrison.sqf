/*
    Description:
    Garrisons units from a group into nearby buildings within a given radius. Each available building position is filled in order until all units are placed or positions run out. No randomness is applied.

    Usage:
    [group, position, radius] call SAS_Task_fnc_garrison;

    Parameter(s):
    0: Group - the group whose units will be garrisoned
    1: Position - the center position (Array)
    2: (Optional) Number - radius to search for buildings (default: 100)
	3: (Optional) Boolean - prioritize by Z (height) (default: false)

    Returns:
    Number - number of units garrisoned

    Debug:
    If SAS_Debug_global is true, logs the number of units garrisoned.
*/
params ["_group", "_position", ["_radius", 100], ["_prioritizeByHeight", false]];

if (isNull _group) exitWith {
    ["[SAS_Task_fnc_garrison] ERROR: Group is null"] call SAS_fnc_logDebug;
    0
};
if ((typeName _position) != (typeName [])) exitWith {
    ["[SAS_Task_fnc_garrison] ERROR: Position must be an Array"] call SAS_fnc_logDebug;
    0
};


private _units = (units _group) - [leader _group];

[_units, _position, _radius, _prioritizeByHeight] call SAS_Task_fnc_garrisonUnits;

