/*
	Puts a unit directly into SURRENDERED state programmatically.
	Works on any unit, no prior registration needed.

	Usage:
	[_unit] call SAS_Captive_fnc_surrender;

	Parameters:
	0: Object - _unit: The unit to put into surrender state

	Example:
	[someUnit] call SAS_Captive_fnc_surrender;
*/
params [["_unit", objNull]];

if (isNull _unit) exitWith {
	["[SAS_Captive_fnc_surrender]: Invalid unit"] call SAS_fnc_logDebug;
};

if (!alive _unit) exitWith {
	[format ["[SAS_Captive_fnc_surrender]: Unit %1 is not alive", _unit]] call SAS_fnc_logDebug;
};

// Skip units already in hostage system
private _hostageState = _unit getVariable ["SAS_Hostage_state", ""];
if (_hostageState != "") exitWith {
	[format ["[SAS_Captive_fnc_surrender]: Unit %1 is already a hostage", _unit]] call SAS_fnc_logDebug;
};

[_unit, "SURRENDERED"] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
