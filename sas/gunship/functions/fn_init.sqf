

/*
	Description:
	Initializes the Gunship module, sets allowed modes, max calls, and registers JTAC units.

	Usage:
	[JTACUnits, maxCalls, availableModes] call SAS_Gunship_fnc_init;

	Parameter(s):
	0: Array - JTAC units to register
	1: Number - Maximum number of gunship calls
	2: Array - Available gunship modes (e.g., ["LASER", "MANUAL"])

	Returns:
	Nothing

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [["_jtacUnits", []],["_maxCalls", 5], ["_availableModes", ["LASER", "MANUAL"]]];

if (!isServer) exitWith {};

if (count _jtacUnits <= 0) exitWith {
	["No JTAC units defined. Gunship system will not work without a JTAC unit."] call SAS_fnc_logDebug;
};

missionnamespace setVariable ["SAS_Gunship_allowLaserMode", (if (_availableModes find "LASER" != -1) then {true} else {false}), true];
missionnamespace setVariable ["SAS_Gunship_allowManualMode", (if (_availableModes find "MANUAL" != -1) then {true} else {false}), true];
[_maxCalls] call SAS_Gunship_fnc_setMaxCalls;

remoteExec ["SAS_Gunship_fnc_addCallMenu", _jtacUnits, true];
