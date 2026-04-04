/*
	Description:
	Adds a "Drag" action to a player unit. Runs on each client via remoteExec.
	The action only appears when the target is incapacitated (native revive).

	Usage:
	[_unit] remoteExec ["SAS_DragBody_fnc_addDragAction", 0, _unit];

	Parameters:
	0: Object - _unit: the player unit to add the drag action to
*/

params ["_unit"];

if (isDedicated) exitWith {};
if (isNull _unit) exitWith {};
if (_unit == player) exitWith {};

// Remove any existing drag action before adding (handles respawn/JIP replay)
private _oldActionId = _unit getVariable ["SAS_DragBody_dragActionId", -1];
if (_oldActionId != -1) then {
	_unit removeAction _oldActionId;
};

private _actionId = _unit addAction [
	"<t color='#FFAF00'>Drag</t>",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		[_target] call SAS_DragBody_fnc_drag;
	},
	[],
	6,
	true,
	true,
	"",
	"lifeState _target == 'INCAPACITATED' && alive _this && lifeState _this != 'INCAPACITATED' && !(_this getVariable ['SAS_DragBody_isDragging', false]) && !(_target getVariable ['SAS_DragBody_isDragged', false])",
	3
];

_unit setVariable ["SAS_DragBody_dragActionId", _actionId];
