/*
	Description:
	Adds an action to an object for intel investigation, triggering a dialog when used.

	Usage:
	[_obj, _actionText, _dialogParams] call SAS_Intel_fnc_setIntel;

	Parameter(s):
	0: Object - The object to attach the action to.
	1: String - The action text shown to the player (default: "Investigate").
	2: String - The intel text shown in the dialog (default: "").
	3: String - The title of the dialog (default: "Intel").
	4: String - The text for the response button (default: "Take").
	5: Code - The code to execute when the response button is pressed (default: empty code).

	Returns:
	Nothing.

	example:
	// Add an intel action to a computer terminal object
	[_terminalObject, "Hack Terminal", "The terminal contains valuable intel on enemy positions.", "Terminal Intel", "Download", { hint "Downloading intel..."; }] call SAS_Intel_fnc_setIntelSimple;

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [["_obj", objNull], ["_actionText", "Investigate"], ["_text", ""], ["_title", "Intel"], ["_buttonText", "Take"], ["_callback", {}]];

if (isNull _obj) exitWith { hint "Invalid unit for message." };
if (_text == "") exitWith { hint "Intel text cannot be empty." };




[_obj, _actionText, [_text, _title, [[_buttonText, _callback]]]] call SAS_Intel_fnc_setIntel;