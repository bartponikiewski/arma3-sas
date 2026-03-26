/*
	Removes the "Arrest" action from a unit.

	Usage:
	[_unit] call SAS_Captive_fnc_removeArrestAction;

	Parameters:
	0: Object - _unit: The unit to remove the action from
*/
params ["_unit"];

if (isNull _unit) exitWith {};

private _actionId = _unit getVariable ["SAS_Captive_arrestActionId", -1];
if (_actionId >= 0) then {
	[_unit, _actionId] call BIS_fnc_holdActionRemove;
	_unit setVariable ["SAS_Captive_arrestActionId", nil];
};
