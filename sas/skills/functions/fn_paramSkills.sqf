/*
    Description:
	Function used with mission Params. Sets the skill level for all units in mission. 
	Be aware that this can break other scripts manipulating unit skills.

    Usage:
    In mission params konfig

    Parameter(s):
    0: Param value for skill level. One of: "AUTO", "NORMAL", "GOOD", "SPECOPS". Default is "NORMAL".

    Returns:
    Nothing
*/
params [["_skillLevel", "NORMAL"]];

if (!isServer) exitWith {
	["SAS_Skills_fnc_paramSkills: skipped (not server)"] call SAS_fnc_logDebug;
};

waitUntil { !isNil "allUnits" };

[allUnits, _skillLevel] call SAS_Skills_fnc_set;

