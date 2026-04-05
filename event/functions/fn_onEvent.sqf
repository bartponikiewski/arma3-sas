/*
    Description:
    Register a handler for a scripted event. Wrapper around BIS_fnc_addScriptedEventHandler.
    Handlers are local — each machine registers its own.

    Usage:
    private _id = ["SAS_MyEvent", {
        params ["_arg1", "_arg2"];
        hint str _arg1;
    }] call SAS_Event_fnc_onEvent;

    Parameter(s):
    0: STRING - Event name
    1: CODE   - Callback
    2: BOOL   - If true, handler is removed after being called once (optional, default: false)

    Returns:
    NUMBER - Handler ID (usable with BIS_fnc_removeScriptedEventHandler)
*/

params [
    ["_eventName", "", [""]],
    ["_callback", {}, [{}]],
    ["_removeAfterUse", false, [false]]
];

if (_eventName == "") exitWith {
    ["[Event:onEvent] No event name provided"] call SAS_fnc_logDebug;
    -1
};

private _code = if (_removeAfterUse) then {
    compile format [
        "(_this) call (%1); [missionNamespace, '%2', _thisScriptedEventHandler] call BIS_fnc_removeScriptedEventHandler;",
        _callback,
        _eventName
    ]
} else {
    _callback
};

private _handlerId = [missionNamespace, _eventName, _code] call BIS_fnc_addScriptedEventHandler;

[format ["[Event:onEvent] Handler #%1 on '%2'", _handlerId, _eventName]] call SAS_fnc_logDebug;

_handlerId
