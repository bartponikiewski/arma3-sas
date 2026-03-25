/*
	Adds "Escort" and "Release" actions to an arrested unit.

	Usage:
	[_unit] call SAS_Captive_fnc_addEscortAction;

	Parameters:
	0: Object - _unit: The arrested unit to add actions to
*/
params ["_unit"];

if (isDedicated) exitWith {};
if (isNull _unit) exitWith {};

// Remove any existing actions to prevent duplicates (race condition guard)
[_unit] call SAS_Captive_fnc_removeEscortAction;

// Escort action
private _escortActionId = _unit addAction [
	"<t color='#00BFFF'>Escort</t>",
	{
		params ["_target", "_caller"];
		[_target, _caller] call SAS_Captive_fnc_escort;
	},
	[],
	6,
	true,
	true,
	"",
	"alive _target && (_target getVariable ['SAS_Captive_state', '']) == 'ARRESTED' && !(_this getVariable ['SAS_DragBody_isDragging', false]) && isNull (_this getVariable ['SAS_Captive_escortingUnit', objNull])",
	3
];

_unit setVariable ["SAS_Captive_escortActionId", _escortActionId];

// Release action
private _releaseActionId = _unit addAction [
	"<t color='#00FF00'>Release</t>",
	{
		params ["_target", "_caller"];
		[_target, "RELEASED", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
	},
	[],
	1.5,
	true,
	true,
	"",
	"alive _target && (_target getVariable ['SAS_Captive_state', '']) in ['ARRESTED', 'ESCORTED'] && (isNull (_this getVariable ['SAS_Captive_escortingUnit', objNull]) || (_this getVariable ['SAS_Captive_escortingUnit', objNull]) == _target)",
	5
];

_unit setVariable ["SAS_Captive_releaseActionId", _releaseActionId];
