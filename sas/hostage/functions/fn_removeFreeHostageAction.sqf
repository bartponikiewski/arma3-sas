
/*
	Description:
	Removes the free hostage action from a hostage object. 
	Should be called when a hostage is freed or no longer interactable.

	This is mean to be used in player local scope.

	Usage:
	[_hostage] call SAS_Hostage_fnc_removeFreeHostageAction;

	Parameters:
	0: Object - _hostage: The hostage object from which to remove the action (default: objNull)

	Returns:
	None. The function removes the action from the specified object.
*/
params ["_hostage"];

if (isDedicated) exitWith {};
if (isNull _hostage) exitWith {};



private _actionId = _hostage getVariable ["SAS_Hostage_freeActionId", -1];
if (_actionId == -1) exitWith {
	["[SAS_Hostage_fnc_removeFreeHostageAction]: No action found on this object"] call SAS_fnc_logDebug;
};
[_hostage, _actionId] call BIS_fnc_holdActionRemove;
_hostage setVariable ["SAS_Hostage_freeActionId", nil];