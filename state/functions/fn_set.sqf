/*
    Description:
    Set state for a given scope. Can be called from any machine —
    automatically routes through the server to ensure global consistency.
    Sets the value globally (including JIP) and fires onChanged listeners
    on all machines exactly once.

    Safe to call from code that runs on all machines (e.g. init.sqf) —
    duplicate calls are handled automatically.

    Usage:
    ["meeting", "arrived"] call SAS_State_fnc_set;

    Parameter(s):
    0: STRING - Scope name (e.g. "meeting", "mission")
    1: ANY    - New state value

    Returns:
    Nothing
*/

params [
    ["_scope", "", [""]],
    ["_newState", ""]
];

if (_scope == "") exitWith {
    ["[State:set] No scope provided"] call SAS_fnc_logDebug;
};

// Client: check if server already broadcast this value
if (!isServer) exitWith {
    private _current = [_scope] call SAS_State_fnc_get;
    if (_current isEqualTo _newState) exitWith {
        [format ["[State:set] %1: client skipping, already '%2'", _scope, _newState]] call SAS_fnc_logDebug;
    };
    // Server hasn't processed yet or this is a client-only call — forward
    [_scope, _newState] remoteExec ["SAS_State_fnc_set", 2];
};

// --- Server only below ---

private _oldState = [_scope] call SAS_State_fnc_get;

// Dedup: skip if state hasn't actually changed
if (_oldState isEqualTo _newState) exitWith {
    [format ["[State:set] %1: already '%2', skipping", _scope, _newState]] call SAS_fnc_logDebug;
};

// Store globally + JIP
missionNamespace setVariable ["SAS_State_" + _scope, _newState, true];

[format ["[State:set] %1: %2 -> %3", _scope, _oldState, _newState]] call SAS_fnc_logDebug;

// Fire generic listeners on all machines
[missionNamespace, "SAS_State_changed_" + _scope, [_scope, _newState, _oldState]] remoteExec ["BIS_fnc_callScriptedEventHandler", 0];

// Fire target-specific listeners on all machines
if (_newState isEqualType "" && {_newState != ""}) then {
    [missionNamespace, "SAS_State_changed_" + _scope + "_" + _newState, [_scope, _newState, _oldState]] remoteExec ["BIS_fnc_callScriptedEventHandler", 0];
};
