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

private _actionId = _unit addAction [
	"<t color='#FF4444'>Arrest</t>",
	{
		params ["_target", "_caller"];
		_caller playActionNow "PutDown";
		[_target, "ARRESTED", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
	},
	[],
	6,
	true,
	true,
	"",
	"alive _target && (_target getVariable ['SAS_Captive_state', '']) == 'SURRENDERED'",
	3
];

_unit setVariable ["SAS_Captive_arrestActionId", _actionId];
