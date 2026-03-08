/*
    Description:
    Marks a mission task as failed.
    Wrapper around SAS_Tasks_fnc_setTaskState.
    The state change is broadcast to all clients by the framework.

    Usage:
    ["taskClearArea"] call SAS_Tasks_fnc_cancelTask;

    Parameters:
    0: STRING - Task ID

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

params ["_taskID"];

if (!isServer) exitWith {
    ["SAS_Tasks_fnc_cancelTask: skipped (not server)"] call SAS_fnc_logDebug;
};


["SAS_Tasks_fnc_cancelTask: cancelling task '" + _taskID + "'"] call SAS_fnc_logDebug;

[_taskID, "Canceled"] call SAS_Tasks_fnc_setTaskState;
