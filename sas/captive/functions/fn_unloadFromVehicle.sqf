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

// Move out of vehicle and clear assignment — must execute where _target is local
if (local _target) then {
	moveOut _target;
	unassignVehicle _target;
	_target leaveVehicle _vehicle;
} else {
	[[_target, _vehicle], {
		params ["_unit", "_veh"];
		moveOut _unit;
		unassignVehicle _unit;
		_unit leaveVehicle _veh;
	}] remoteExec ["call", _target];
};

// Vehicle reference is cleared in setCaptiveState ARRESTED case (after removeUnloadAction
// runs on all clients). Clearing it here would race with the remoteExec and cause other
// clients to skip the action removal.
_target setVariable ["SAS_Captive_unloadVehicle", nil];

// Return to arrested state on the ground
[_target, "ARRESTED", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
