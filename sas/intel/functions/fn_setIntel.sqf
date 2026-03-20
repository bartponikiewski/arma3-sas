/*
	Description:
	Adds an action to an object for intel investigation, triggering a dialog when used.

	Usage:
	[_obj, _actionText, _dialogParams] call SAS_Intel_fnc_setIntel;

	Parameter(s):
	0: Object - The object to attach the action to.
	1: String - The action text shown to the player (default: "Investigate").
	2: Array - Parameters passed to the intel dialog (default: []).

	Returns:
	Nothing.

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [["_obj", objNull], ["_actionText", "Investigate"], ["_dialogParams", []]];

if (isNull _obj) exitWith { hint "Invalid unit for message." };

_obj addAction [_actionText, {
	params ["_target", "_caller", "_actionId", "_arguments"];
	_arguments params [["_dialogParams", []]];
	
	if (!isNil "_dialogParams") then {
		_dialogParams call SAS_Intel_fnc_intelDialog;
	};
},[_dialogParams],1.5,true, true, "", "true", 5];