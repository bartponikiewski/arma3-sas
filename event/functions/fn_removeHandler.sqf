/*
    Description:
    Remove a handler for a scripted event. Wrapper around BIS_fnc_removeScriptedEventHandler.

    Usage:
    ["SAS_MyEvent", _handlerId] call SAS_Event_fnc_removeHandler;

    Parameter(s):
    0: STRING - Event name
    1: NUMBER - Handler ID (returned by SAS_Event_fnc_onEvent)

    Returns:
    Nothing
*/

params [
    ["_eventName", "", [""]],
    ["_handlerId", -1, [0]]
];

if (_eventName == "") exitWith {
    ["[Event:removeHandler] No event name provided"] call SAS_fnc_logDebug;
};

if (_handlerId < 0) exitWith {
    ["[Event:removeHandler] Invalid handler ID"] call SAS_fnc_logDebug;
};

[missionNamespace, _eventName, _handlerId] call BIS_fnc_removeScriptedEventHandler;

[format ["[Event:removeHandler] Removed handler #%1 from '%2'", _handlerId, _eventName]] call SAS_fnc_logDebug;
