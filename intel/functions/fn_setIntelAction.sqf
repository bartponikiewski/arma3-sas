/*
	Adds a hold action to an object that calls a callback on completion.
	Unlike setIntel/setIntelSimple, this does not open a dialog.

	Usage:
	[_obj, _actionText, _callback, _removeOnComplete] call SAS_Intel_fnc_setIntelAction;

	Parameters:
	0: Object - _obj: The object to attach the hold action to
	1: (Optional) String - _actionText: Text shown on the hold action (default: "Investigate")
	2: (Optional) Code - _callback: Code executed on completion, receives [_target, _caller] (default: {})
	3: (Optional) Boolean - _removeOnComplete: If true, deleteVehicle the object after callback (default: true)
	4: (Optional) Number - _duration: Duration in seconds to complete the hold action (default: 5)
	5: (Optional) String - _icon: Path to the icon shown on the hold action (default: "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa")

	Example:
	[laptop_1, "Pick up intel", { hint "Intel found!"; }, true] call SAS_Intel_fnc_setIntelAction;
*/
params [["_obj", objNull], ["_actionText", "Investigate"], ["_callback", {}], ["_removeOnComplete", true], ["_duration", 5], ["_icon", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa"]];

if (isDedicated) exitWith {};
if (isNull _obj) exitWith {
	["[SAS_Intel_fnc_setIntelAction]: Invalid object"] call SAS_fnc_logDebug;
};

[
	_obj,
	_actionText,
	_icon,
	_icon,
	"true",
	"_caller distance _target < 5",
	{},
	{},
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_arguments params ["_callback", "_removeOnComplete"];

		[_target, _caller, _actionId] call _callback;

		if (_removeOnComplete) then {
			deleteVehicle _target;
		};
	},
	{},
	[_callback, _removeOnComplete],
	_duration,
	nil,
	true,
	false,
	true,
	5
] call BIS_fnc_holdActionAdd;
