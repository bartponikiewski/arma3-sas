/*
    Description:
	Function used with mission Params. Sets the skill level for all units in mission. 
	Be aware that this can break other scripts manipulating unit skills.

    Usage:
    In mission params konfig

    Parameter(s):
    0: Param value for skill level, passed from param it will be number 0-3, where 0=AUTO, 1=NORMAL, 2=GOOD, 3=SPECOPS. See params.cpp for details.

    Returns:
    Nothing
*/
params [["_skillLevel", "NORMAL"]];

if (!isServer) exitWith {
	["SAS_Skills_fnc_paramSkills: skipped (not server)"] call SAS_fnc_logDebug;
};

[_skillLevel] spawn {
    params ["_skillLevel"];
    waitUntil { time > 0 };

    private _trueSkillLvels = ["AUTO", "NORMAL", "GOOD", "SPECOPS"];
    [allUnits, _trueSkillLvels select _skillLevel] call SAS_Skills_fnc_set;
};

