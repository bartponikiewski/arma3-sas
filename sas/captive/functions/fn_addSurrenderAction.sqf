/*
	Adds a "Hands Up!" action to a unit, allowing players to order them to surrender.

	Usage:
	[_unit] call SAS_Captive_fnc_addSurrenderAction;

	Parameters:
	0: Object - _unit: The unit to add the action to
*/
params ["_unit"];

if (isDedicated) exitWith {};
if (isNull _unit) exitWith {};

private _actionId = _unit addAction [
	"<t color='#FF8C00'>Hands Up!</t>",
	{
		params ["_target", "_caller"];
		[_target, "SURRENDERED", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
	},
	[],
	6,
	true,
	true,
	"",
	"alive _target && (_target getVariable ['SAS_Captive_state', '']) == 'CAPTURABLE'",
	50
];

_unit setVariable ["SAS_Captive_surrenderActionId", _actionId];
