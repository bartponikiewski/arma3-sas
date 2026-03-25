/*
	Description:
	Drags an incapacitated player. Attaches the target to the caller,
	plays drag animations, and starts a monitor loop for auto-release.

	Usage:
	[_target] call SAS_DragBody_fnc_drag;

	Parameters:
	0: Object - _target: the incapacitated unit to drag
*/

params ["_target"];

// Set state
player setVariable ["SAS_DragBody_isDragging", true, true];
_target setVariable ["SAS_DragBody_isDragged", true, true];

// Disable collision
[_target, player] remoteExecCall ["disableCollisionWith", 0];

// Attach and animate
_target attachTo [player, [0, 1.04, 0.04]];
[_target, 180] remoteExec ["setDir", 0];
[player, "grabDrag"] remoteExec ["playAction", 0];
[_target, "AinjPpneMrunSnonWnonDb_grab"] remoteExec ["switchMove", 0];

// Lock to walk
player forceWalk true;

// Add release action to the target
private _releaseActionId = _target addAction [
	"<t color='#FFAF00'>Release</t>",
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_target removeAction _actionId;
		[_target] spawn SAS_DragBody_fnc_release;
	},
	[],
	6,
	true,
	false,
	"",
	"player == attachedTo _target",
	3
];

_target setVariable ["SAS_DragBody_releaseActionId", _releaseActionId];

// Monitor loop — auto-release on incap, death, or revive
[_target, _releaseActionId] spawn {
	params ["_target", "_releaseActionId"];

	while {
		alive player
		&& lifeState player != "INCAPACITATED"
		&& player getVariable ["SAS_DragBody_isDragging", false]
	} do {
		// Target died or was revived
		if (!alive _target || lifeState _target == "HEALTHY") exitWith {};
		sleep 1;
	};

	// Only release if still dragging (avoid double-release if manual release happened)
	if (_target getVariable ["SAS_DragBody_isDragged", false]) then {
		_target removeAction _releaseActionId;
		[_target] call SAS_DragBody_fnc_release;
	};
};
