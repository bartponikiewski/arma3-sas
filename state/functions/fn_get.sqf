/*
    Description:
    Get the current state value for a given scope.

    Usage:
    private _state = ["meeting"] call SAS_State_fnc_get;

    Parameter(s):
    0: STRING - Scope name (e.g. "meeting", "mission")

    Returns:
    ANY - Current state value, or "" if not set

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

params [
    ["_scope", "", [""]]
];

if (_scope == "") exitWith {
    ["[State:get] No scope provided"] call SAS_fnc_logDebug;
    ""
};

missionNamespace getVariable ["SAS_State_" + _scope, ""]
