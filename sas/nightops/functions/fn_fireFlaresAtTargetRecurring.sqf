/*
    Description:
    Fires a flare at a target for a group, and automatically repeats as long as the group is in combat and the target is valid.
    Handles cleanup and restarts the flare loop when the flare is deleted.

    Usage:
    [_group, _target] call SAS_NightOps_fnc_fireFlaresAtTargetRecurring;

    Parameter(s):
    0: Group - The group that will fire the flare.
    1: Object - The target object to illuminate.

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group", "_target"];

// Validate group and target before potentially restarting flare loop
if (isNull _group) exitWith {};
if (count ((units _group) select {alive _x}) == 0) exitWith {};
if (!local _group) exitWith {};

// If group behaviour is not COMBAT exit with reset
if (combatBehaviour _group != "COMBAT") exitWith { _group setVariable ["SAS_NightOps_FlareLoopActive", false, false]; };

// If target is null or dead, exit and clear flare loop active variable
if (isNull _target) exitWith { _group setVariable ["SAS_NightOps_FlareLoopActive", false, false]; };
if (!alive _target) exitWith { _group setVariable ["SAS_NightOps_FlareLoopActive", false, false]; };

// Set variable to indicate flare loop is active
_group setVariable ["SAS_NightOps_FlareLoopActive", true, false];

// Get predicted target position
private _targetPos = leader _group getHideFrom _target;

// If target position is [0,0,0] it means unit do not know about target, exit with reset
if (_targetPos isEqualTo [0,0,0]) exitWith { _group setVariable ["SAS_NightOps_FlareLoopActive", false, false]; };

// Set flare height to 200m to ensure visibility
_targetPos set [2,200];

// Shot flare
private _flare = [_group, "white", _targetPos] call SAS_fnc_fireFlare;
_flare setVariable ["SAS_NightOps_FlareTarget", _target, false];
_flare setVariable ["SAS_NightOps_FlareGroup", _group, false];

[format ["[useFlares] Fired flare from group %1 at target %2", _group, _target]] call SAS_fnc_logDebug;

// Flare cleanup and loop restart logic
_flare addEventHandler ["Deleted", {
	params ["_entity"];

	private _target = _entity getVariable "SAS_NightOps_FlareTarget";
	private _group = _entity getVariable "SAS_NightOps_FlareGroup";
	
	[_entity, _group, _target] spawn {
		params ["_entity", "_group", "_target"];
				
		// Wait a bit before checking conditions to allow flare to be fully deleted
		sleep 10 + (random 20);

		// Restart flare loop with same target
		[_group, _target] call SAS_NightOps_fnc_fireFlaresAtTargetRecurring;
	};
}];