/*
	Stops escorting a captive. Detaches the unit and returns to ARRESTED state.

	Usage:
	[_target, _caller] call SAS_Captive_fnc_stopEscort;

	Parameters:
	0: Object - _target: The escorted unit to stop escorting
	1: Object - _caller: The player who was escorting (defaults to reading SAS_Captive_escortedBy)
*/
params ["_target", ["_caller", objNull]];

// Fallback: read stored escort reference if caller not provided
if (isNull _caller) then {
	_caller = _target getVariable ["SAS_Captive_escortedBy", player];
};

// Unlock walk
_caller forceWalk false;

// Detach
detach _target;

// Re-enable collision
[_target, _caller] remoteExecCall ["enableCollisionWith", 0];

// Clean up escort-specific actions
private _stopActionId = _target getVariable ["SAS_Captive_stopEscortActionId", -1];
if (_stopActionId >= 0) then {
	_target removeAction _stopActionId;
	_target setVariable ["SAS_Captive_stopEscortActionId", nil];
};

// Load action is on the caller, not the target
private _loadActionId = _caller getVariable ["SAS_Captive_loadActionId", -1];
if (_loadActionId >= 0) then {
	_caller removeAction _loadActionId;
	_caller setVariable ["SAS_Captive_loadActionId", nil];
};

// Clear escort reference
if (local _target) then {
	_target setVariable ["SAS_Captive_escortedBy", objNull, true];
};

// Return to arrested state
[_target, "ARRESTED", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
