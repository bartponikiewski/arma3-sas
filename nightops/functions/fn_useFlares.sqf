/*
    Description:
    Fires a white flare from the group when enemy contact is detected.
    Uses SAS_misc_fnc_fireFlare for flare logic.

    Usage:
    [group] call SAS_NightOps_fnc_useFlares;

    Parameter(s):
    0: Group - The group to monitor for contact

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [
    ["_group", objNull, [objNull, grpNull]]
];

// Validate
if (isNull _group) exitWith {};
if (typename _group == "OBJECT") then { _group = group _group; };
if (!local _group) exitWith {};

_group addEventHandler ["EnemyDetected", {
	params ["_group", "_newTarget"];

    // Run only if group is local and flare loop isn't already active
    if (!local _group) exitWith {};
    private _flareLoopActive = _group getVariable ["SAS_NightOps_FlareLoopActive", false];
    if (_flareLoopActive) exitWith {};

    [_group, _newTarget] call SAS_NightOps_fnc_fireFlaresAtTargetRecurring ;
}];

[format ["[useFlares] Set up flare event handler for group %1", _group]] call SAS_fnc_logDebug;
