/*
	Removes "Escort" and "Release" actions from a unit.

	Usage:
	[_unit] call SAS_Captive_fnc_removeEscortAction;

	Parameters:
	0: Object - _unit: The unit to remove the actions from
*/
params ["_unit"];

if (isNull _unit) exitWith {};

private _escortActionId = _unit getVariable ["SAS_Captive_escortActionId", -1];
if (_escortActionId >= 0) then {
	_unit removeAction _escortActionId;
	_unit setVariable ["SAS_Captive_escortActionId", nil];
};

private _releaseActionId = _unit getVariable ["SAS_Captive_releaseActionId", -1];
if (_releaseActionId >= 0) then {
	_unit removeAction _releaseActionId;
	_unit setVariable ["SAS_Captive_releaseActionId", nil];
};
