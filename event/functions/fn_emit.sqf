/*
    Description:
    Emit a scripted event. Wrapper around BIS_fnc_callScriptedEventHandler.
    Can emit locally (this machine only) or globally (all machines).

    Usage:
    // Local emit:
    ["SAS_MyEvent", [_arg1, _arg2]] call SAS_Event_fnc_emit;

    // Global emit (all machines):
    ["SAS_MyEvent", [_arg1, _arg2], true] call SAS_Event_fnc_emit;

    Parameter(s):
    0: STRING - Event name
    1: ARRAY  - (Optional, default []) Arguments passed to handlers
    2: BOOL   - (Optional, default false) True = emit globally on all machines

    Returns:
    Nothing
*/

params [
    ["_eventName", "", [""]],
    ["_args", [], [[]]],
    ["_global", false, [false]]
];

if (_eventName == "") exitWith {
    ["[Event:emit] No event name provided"] call SAS_fnc_logDebug;
};

if (_global) then {
    [missionNamespace, _eventName, _args] remoteExec ["BIS_fnc_callScriptedEventHandler", 0];
} else {
    [missionNamespace, _eventName, _args] call BIS_fnc_callScriptedEventHandler;
};

[format ["[Event:emit] '%1' (global: %2)", _eventName, _global]] call SAS_fnc_logDebug;
