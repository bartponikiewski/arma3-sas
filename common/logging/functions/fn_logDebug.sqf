/*
    Description:
    Logs debug messages for SAS framework. Displays in-game hint if global debug flag is enabled.

    Usage:
    ["Your debug message"] call SAS_fnc_logDebug;

    Parameter(s):
    0: STRING - The debug message to display
    1: (Optional) STRING - Scope of the debug message, either "global" or "mission" (default: "global")

    Returns:
    Nothing
*/

params ["_msg", ["_scope", "global", ["global", "mission"]]];

private _debugGlobal = missionNamespace getVariable ["SAS_Debug_global", false];
private _debugMission = missionNamespace getVariable ["SAS_Debug_mission", false];

if (_debugGlobal && _scope == "global") then {
    hint format ["[SAS DEBUG] %1", _msg];
};

if (_debugMission && _scope == "mission") then {
    hint format ["[SAS DEBUG] %1", _msg];
};
