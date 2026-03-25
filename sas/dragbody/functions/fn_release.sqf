/*
	Description:
	Releases a dragged unit. Detaches, resets animations, and clears state.

	Usage:
	[_target] call SAS_DragBody_fnc_release;
	[_target] spawn SAS_DragBody_fnc_release;

	Parameters:
	0: Object - _target: the unit being dragged
*/

params ["_target"];

// Unlock walk
player forceWalk false;

// Release animation
[_target, "AinjPpneMstpSnonWrflDb_release"] remoteExec ["switchMove", 0];

// Detach
detach _target;

// Player release animation
[player, "released"] remoteExec ["playActionNow", 0];

sleep 0.6;

// Return to unconscious pose
[_target, "unconsciousrevivedefault"] remoteExec ["switchMove", 0];

// Re-enable collision
[_target, player] remoteExecCall ["enableCollisionWith", 0];

// Align to terrain
_target setVectorUp surfaceNormal position _target;

// Reset state
_target setVariable ["SAS_DragBody_isDragged", false, true];
player setVariable ["SAS_DragBody_isDragging", false, true];
