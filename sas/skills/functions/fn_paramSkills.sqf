/*
    Description:
	Function used with mission Params. Sets the skill level for all units in mission. 
	Be aware that this can break other scripts manipulating unit skills.

    Usage:
    In mission params konfig

    Parameter(s):
    0: Param value for skill level, passed from param it will be number 0-4, where 0=AUTO, 1=EASY, 2=NORMAL, 3=GOOD, 4=SPECOPS. See params.cpp for details.

    Returns:
    Nothing
*/
params [["_skillLevel", 2]];

if (!isServer) exitWith {
	["SAS_Skills_fnc_paramSkills: skipped (not server)"] call SAS_fnc_logDebug;
};

[_skillLevel] spawn {
    params ["_skillLevel"];
    waitUntil { count allUnits > 0 }; // Wait until units are initialized

    private _trueSkillLevels = ["AUTO", "EASY", "NORMAL", "GOOD", "SPECOPS"];

    [allUnits, _trueSkillLevels select _skillLevel] call SAS_Skills_fnc_set;
};

