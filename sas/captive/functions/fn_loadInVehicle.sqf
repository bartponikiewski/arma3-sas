/*
	Loads an escorted captive into the nearest vehicle.
	Detaches from player, moves into cargo, and adds unload action on the vehicle.

	Usage:
	[_target, _caller] call SAS_Captive_fnc_loadInVehicle;

	Parameters:
	0: Object - _target: The escorted captive to load
	1: Object - _caller: The player loading the captive
*/
params ["_target", "_caller"];

// Find nearest vehicle with free cargo
private _vehicles = nearestObjects [_caller, ["Car", "Tank", "Helicopter", "Boat", "Plane"], 10];
private _vehicle = objNull;

{
	if (alive _x && {_x emptyPositions "cargo" > 0}) exitWith {
		_vehicle = _x;
	};
} forEach _vehicles;

if (isNull _vehicle) exitWith {
	["[SAS_Captive_fnc_loadInVehicle]: No vehicle with free cargo nearby"] call SAS_fnc_logDebug;
};

// Stop escort: detach, unlock walk, clean actions
_caller forceWalk false;
detach _target;
[_target, _caller] remoteExecCall ["enableCollisionWith", 0];

// Clean up escort-specific actions
private _stopActionId = _target getVariable ["SAS_Captive_stopEscortActionId", -1];
if (_stopActionId >= 0) then {
	_target removeAction _stopActionId;
	_target setVariable ["SAS_Captive_stopEscortActionId", nil];
};

// Load action is on the player, not the target
private _loadActionId = _caller getVariable ["SAS_Captive_loadActionId", -1];
if (_loadActionId >= 0) then {
	_caller removeAction _loadActionId;
	_caller setVariable ["SAS_Captive_loadActionId", nil];
};

// Remove escort/release actions from previous state
[_target] call SAS_Captive_fnc_removeEscortAction;

// Move into vehicle cargo
_target moveInCargo _vehicle;

// Store vehicle reference BEFORE remoteExec so all clients can read it
_target setVariable ["SAS_Captive_vehicle", _vehicle, true];

// Set state (unload action is added in setCaptiveState IN_VEHICLE case on all clients)
[_target, "IN_VEHICLE", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
