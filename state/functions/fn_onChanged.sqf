/*
    Description:
    Register a listener that fires when a scope's state changes.
    Listeners are local — each machine registers its own.
    Uses BIS scripted event handlers internally.

    Usage:
    // React to any state change:
    private _id = ["meeting", "", {
        params ["_scope", "_newState", "_oldState"];
    }] call SAS_State_fnc_onChanged;

    // React to a specific state value:
    private _id = ["meeting", "attack", {
        params ["_scope", "_newState", "_oldState"];
        hint "Cover blown!";
    }] call SAS_State_fnc_onChanged;

    // JIP catch-up (fire immediately if state already matches):
    private _id = ["meeting", "attack", {
        params ["_scope", "_newState", "_oldState"];
    }, true] call SAS_State_fnc_onChanged;

    Parameter(s):
    0: STRING  - Scope name
    1: STRING  - Target state to filter on ("" for any change)
    2: CODE    - Callback, receives [_scope, _newState, _oldState]
    3: BOOL    - (Optional, default false) If true and current state already
                 matches, fire callback immediately (JIP catch-up).

    Returns:
    NUMBER - Handler ID (usable with BIS_fnc_removeScriptedEventHandler)
*/

params [
    ["_scope", "", [""]],
    ["_targetState", "", [""]],
    ["_callback", {}, [{}]],
    ["_fireOnJIP", false, [false]]
];

if (_scope == "") exitWith {
    ["[State:onChanged] No scope provided"] call SAS_fnc_logDebug;
    -1
};

// Build event name — generic or target-specific
private _eventName = if (_targetState == "") then {
    "SAS_State_changed_" + _scope
} else {
    "SAS_State_changed_" + _scope + "_" + _targetState
};

// Register with BIS scripted event handler system
private _handlerId = [missionNamespace, _eventName, _callback] call BIS_fnc_addScriptedEventHandler;

[format ["[State:onChanged] Handler #%1 on '%2' (JIP: %3)", _handlerId, _eventName, _fireOnJIP]] call SAS_fnc_logDebug;

// JIP catch-up: fire immediately if state already matches
if (_fireOnJIP) then {
    private _currentState = [_scope] call SAS_State_fnc_get;
    if (_currentState != "") then {
        if (_targetState == "" || {_targetState isEqualTo _currentState}) then {
            [format ["[State:onChanged] JIP catch-up for '%1' (current: '%2')", _scope, _currentState]] call SAS_fnc_logDebug;
            [_scope, _currentState, ""] call _callback;
        };
    };
};

_handlerId
