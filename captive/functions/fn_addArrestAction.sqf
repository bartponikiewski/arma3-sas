/*
	Adds an "Arrest" action to a surrendering unit.

	Usage:
	[_unit] call SAS_Captive_fnc_addArrestAction;

	Parameters:
	0: Object - _unit: The surrendering unit to add the action to
*/
params ["_unit"];

if (isDedicated) exitWith {};
if (isNull _unit) exitWith {};

// Remove any existing action to prevent duplicates (race condition guard)
[_unit] call SAS_Captive_fnc_removeArrestAction;

private _actionId = [
	_unit,
	"Arrest",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",
	"alive _target && (_target getVariable ['SAS_Captive_state', '']) == 'SURRENDERED' && isNull (_this getVariable ['SAS_Captive_escortingUnit', objNull])",
	"_caller distance _target < 3",
	{},
	{},
	{
		params ["_target", "_caller"];
		_caller playActionNow "PutDown";
		[_target, "ARRESTED", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
	},
	{},
	[],
	3,
	nil,
	true,
	false,
	true,
	3
] call BIS_fnc_holdActionAdd;

_unit setVariable ["SAS_Captive_arrestActionId", _actionId];
