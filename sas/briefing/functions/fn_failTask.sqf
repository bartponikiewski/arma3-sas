/*
    Description:
    Marks a mission task as failed.
    Wrapper around SAS_Tasks_fnc_setTaskState.
    The state change is broadcast to all clients by the framework.

    Usage:
    ["taskClearArea"] call SAS_Briefing_fnc_failTask;

    Parameters:
    0: STRING - Task ID

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

params ["_taskID"];


["SAS_Tasks_fnc_failTask: failing task '" + _taskID + "'"] call SAS_fnc_logDebug;

[_taskID, "Failed"] remoteExec ["SAS_Briefing_fnc_setTaskState", 0, true];
