/*
	Checks whether the observer can see the target, accounting for both
	field of view (facing direction) and physical line of sight (terrain, walls, objects).

	Usage:
	_canSee = [_observer, _target] call SAS_fnc_canSeeTarget;
	_canSee = [_observer, _target, 60] call SAS_fnc_canSeeTarget;

	Parameters:
	0: Object - _observer: The unit doing the looking
	1: Object - _target: The unit being looked at
	2: Number - _fov: (Optional, default 60) Half-angle of the vision cone in degrees

	Returns:
	Boolean - True if the observer is facing the target and has unobstructed line of sight
*/
params [["_observer", objNull], ["_target", objNull], ["_fov", 60]];

if (isNull _observer || {isNull _target} || {!alive _observer} || {!alive _target}) exitWith { false };

// Check if the target is within the observer's field of view
private _dirToTarget = (_observer getRelDir _target);
// getRelDir returns 0-360, normalize to -180..180
if (_dirToTarget > 180) then { _dirToTarget = _dirToTarget - 360 };

if ((abs _dirToTarget) >= _fov) exitWith { false };

// checkVisibility returns 0 (fully occluded) to 1 (fully visible)
private _vis = [_observer, "VIEW", _target] checkVisibility [eyePos _observer, eyePos _target];

_vis > 0
