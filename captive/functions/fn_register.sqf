/*
	Registers an array of units as capturable.
	Adds "Hands Up!" action to each unit so players can order them to surrender.

	Usage:
	[_units] call SAS_Captive_fnc_register;

	Parameters:
	0: Array - _units: Array of units to register as capturable

	Example:
	[[unit1, unit2, unit3]] call SAS_Captive_fnc_register;
*/
params [["_units", []]];

if (_units isEqualTo []) exitWith {
	["[SAS_Captive_fnc_register]: No units provided"] call SAS_fnc_logDebug;
};

{
	private _unit = _x;

	if (isNull _unit) then {
		[format ["[SAS_Captive_fnc_register]: Skipping null unit at index %1", _forEachIndex]] call SAS_fnc_logDebug;
	} else {
		if (!alive _unit) then {
			[format ["[SAS_Captive_fnc_register]: Skipping dead unit %1", _unit]] call SAS_fnc_logDebug;
		} else {
			// Skip units already in captive system or hostage system
			private _captiveState = _unit getVariable ["SAS_Captive_state", ""];
			private _hostageState = _unit getVariable ["SAS_Hostage_state", ""];

			if (_captiveState != "" || _hostageState != "") then {
				[format ["[SAS_Captive_fnc_register]: Skipping unit %1, already in captive/hostage system", _unit]] call SAS_fnc_logDebug;
			} else {
				[_unit, "CAPTURABLE"] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
			};
		};
	};
} forEach _units;
