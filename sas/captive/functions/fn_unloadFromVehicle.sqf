/*
	Unloads a captive from a vehicle and returns them to ARRESTED state.

	Usage:
	[_target, _caller] call SAS_Captive_fnc_unloadFromVehicle;

	Parameters:
	0: Object - _target: The captive to unload
	1: Object - _caller: The player unloading the captive
*/
params ["_target", "_caller"];

if (isNull _target || !alive _target) exitWith {};

private _vehicle = _target getVariable ["SAS_Captive_vehicle", objNull];

// Remove unload action from vehicle (local cleanup, each client removes its own)
[_target] call SAS_Captive_fnc_removeUnloadAction;

// Move out of vehicle and clear assignment so unit doesn't walk back
moveOut _target;
unassignVehicle _target;
_target leaveVehicle _vehicle;

// Clear vehicle reference
_target setVariable ["SAS_Captive_vehicle", objNull, true];
_target setVariable ["SAS_Captive_unloadVehicle", nil];

// Return to arrested state on the ground
[_target, "ARRESTED", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
