/*
    Description:
    Sets the state of an existing mission task using BIS_fnc_taskSetState.
    The state change is broadcast to all clients by the framework.

    Usage:
    ["taskClearArea", "Succeeded"] call SAS_Tasks_fnc_setTaskState;

    Parameters:
    0: STRING - Task ID
    1: STRING - New task state. One of: "Created", "Assigned", "Succeeded", "Failed", "Canceled"

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

params ["_taskID", "_state"];

["SAS_Tasks_fnc_setTaskState: setting task '" + _taskID + "' to state '" + _state + "'"] call SAS_fnc_logDebug;

private _oldState = [_taskID] call BIS_fnc_taskState;
[_taskID, _state] call BIS_fnc_taskSetState;

[missionNamespace, "SAS_Briefing_TaskStateChanged", [_taskID, _oldState, _state]] remoteExecCall ["BIS_fnc_callScriptedEventHandler", 0];
