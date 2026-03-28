/*
	File: setSkills.sqf
	Author: Sushi

	Description:
	Set give units or group skills to predefined levels (NORMAL, GOOD, SPECOPS) or custom values.
	Can be used to quickly set up AI units without needing to configure each skill individually.

	Parameter(s):
	0: OBJECT, ARRAY or GROUP - Unit, array of units, or group to set skills for. If a group is passed, skills will be applied to all units in the group.
	1: (Optional) STRING - Predefined skill level to apply to all units. One of: "AUTO", "NORMAL", "GOOD", "SPECOPS". Default is "NORMAL".
	2: (Optional) ARRAY - Custom skill values to apply if the skill level is "CUSTOM". Default is an empty array.
		Expected format: [aimingspeed, spotdistance, aimingaccuracy, aimingshake, courage, spottime, commanding, general]
		Each value should be between 0 and 1.

	Returns:
	Nothing
	
	Example:
	[group this] call SAS_Skills_fnc_set;
	[[unit1,unit2,unit3],"SPECOPS"] call SAS_Skills_fnc_set;
*/

/**
	consider using: BIS_fnc_EXP_camp_setSkill
*/

//-->Parameters
params [
	["_uArr",[],[[],grpNull,objNull]],
	["_lvl","NORMAL",[""]],
	["_sArr",[],[[]]]
];

//-->Validate
if (typename _uArr == "GROUP") then {
	_uArr setVariable ["SAS_skillLevelCache",_this select 1,true];
	_uArr = units _uArr;
};
if (typename _uArr == "OBJECT") then {
	_uArr = [_uArr];
};

if (count _uArr < 1) exitWith {};


//-->Main scope
switch (_lvl) do {
	case "AUTO": {
		// Do nothing, auto settings from editor
	};
	
	case "NORMAL": {
		{
			if (!local _x) then { continue };

			_x setSkill ["aimingspeed", 0.05];
			_x setSkill ["spotdistance", 0.1];
			_x setSkill ["aimingaccuracy", 0.05];
			_x setSkill ["aimingshake", 0.04];
			_x setskill ["courage", 0.9];
			_x setSkill ["spottime", 0.2];
			_x setSkill ["commanding", 1];
			_x setSkill ["general", 0.5];
		} forEach _uArr;
	};
	
	case "GOOD": {
		{
			if (!local _x) then { continue };

			_x setSkill ["aimingspeed", 0.08];
			_x setSkill ["spotdistance", 0.1];
			_x setSkill ["aimingaccuracy", 0.07];
			_x setSkill ["aimingshake", 0.07];
			_x setskill ["courage", 0.9];
			_x setSkill ["spottime", 0.2];
			_x setSkill ["commanding", 1];
			_x setSkill ["general", 1];
		} forEach _uArr;
	};
	
	case "SPECOPS": {
		{	
			if (!local _x) then { continue };

			_x setSkill ["aimingspeed", 1];
			_x setSkill ["spotdistance", 0.15];
			_x setSkill ["aimingaccuracy", 1];
			_x setSkill ["aimingshake", 0.05];
			_x setskill ["courage", 1];
			_x setSkill ["spottime", 0.25];
			_x setSkill ["commanding", 1];
			_x setSkill ["general", 1];
		} forEach _uArr;
	};
	
	case "CUSTOM": {
		{	
			if (!local _x) then { continue };

			_x setSkill ["aimingspeed", _sArr select 0];
			_x setSkill ["spotdistance", _sArr select 1];
			_x setSkill ["aimingaccuracy", _sArr select 2];
			_x setSkill ["aimingshake", _sArr select 3];
			_x setskill ["courage", _sArr select 4];
			_x setSkill ["spottime", _sArr select 5];
			_x setSkill ["commanding", _sArr select 6];
			_x setSkill ["general", _sArr select 7];
		} forEach _uArr;
	};
};
