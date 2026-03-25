/*
	Removes the "Unload Captive" action from the vehicle.

	Usage:
	[_unit] call SAS_Captive_fnc_removeUnloadAction;

	Parameters:
	0: Object - _unit: The captive unit whose unload action should be removed
*/
params ["_unit"];

if (isNull _unit) exitWith {};

private _vehicle = _unit getVariable ["SAS_Captive_vehicle", objNull];
private _actionId = _unit getVariable ["SAS_Captive_unloadActionId", -1];

if (_actionId >= 0 && !isNull _vehicle) then {
	_vehicle removeAction _actionId;
	_unit setVariable ["SAS_Captive_unloadActionId", nil];
};
