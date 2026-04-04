
/*
	Description:
	Removes the power source action from a light control object. 
	Should be called when a power source object is destroyed.

	This is mean to be used in player local scope.

	Usage:
	_lightControl call SAS_NightOps_fnc_removePowerSourceAction;

	Parameters:
	0: Object - _lightControl: The light control object from which to remove the action (default: objNull)

	Returns:
	None. The function removes the action from the specified object.
*/
params ["_lightControl"];

if (isDedicated) exitWith {};
if (isNull _lightControl) exitWith {};



private _actionId = _lightControl getVariable ["SAS_NightOps_lightControlActionId", -1];
if (_actionId == -1) exitWith {
	["[SAS_NightOps_fnc_removePowerSourceAction]: No action found on this object"] call SAS_fnc_logDebug;
}; // No action found on this object, probably shouldn't be trying to remove it
[_lightControl, _actionId] call BIS_fnc_holdActionRemove;
_lightControl setVariable ["SAS_NightOps_lightControlActionId", nil];

