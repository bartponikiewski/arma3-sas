/*
    Description:
    Creates multiple mission tasks from an ordered array of definitions.
    Task importance is derived from position in the array:
    - First entry  → highest priority, immediately assigned as current task
    - Last entry   → lowest priority, created but not assigned

    Wrapper around SAS_Briefing_fnc_createTask.
    BIS_fnc_taskCreate handles network synchronisation and JIP internally.
    Should be called on the server.

    Usage:
    [
        ["taskSeize",   "Seize Objective Alpha", "Capture the compound.",           "Move",    "markerAlpha"],
        ["taskDestroy", "Destroy Ammo Depot",    "Blow up the ammunition storage.", "Destroy", "markerAmmo"],
        ["taskExtract", "Extract to LZ",         "Reach the landing zone.",         "Move",    "markerLZ"],
    ] call SAS_Briefing_fnc_createTasks;

    // Sub-tasks can be defined by providing a parent task ID
    [
        ["taskAssault", "Assault the Base",   "Clear all enemy forces.",   "Attack",  "markerBase"],
        ["taskRadar",   "Destroy the Radar",  "Take out the comms dish.",  "Destroy", "markerRadar", "taskAssault"],
    ] call SAS_Briefing_fnc_createTasks;

    Parameters:
    0: ARRAY - Array of task definitions, ordered from most to least important.
        Each definition: [taskID, title, description, type, destination, parent]
            0: STRING                        - Unique task ID
            1: STRING                        - Task title
            2: STRING                        - Task description
            3: (Optional) STRING             - Task type (default: "Move")
            4: (Optional) STRING, ARRAY, or OBJECT - Task destination (default: objNull)
            5: (Optional) STRING             - Parent task ID (default: "")

    Returns:
    ARRAY - Created TASK objects in the same order as the input

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

if (!isServer) exitWith {
    ["SAS_Briefing_fnc_createTasks: skipped (not server)"] call SAS_fnc_logDebug;
};

["SAS_Briefing_fnc_createTasks: creating " + str (count _this) + " task(s)"] call SAS_fnc_logDebug;

private _count = count _this;
private _createdTasks = [];

{
    _x params [
        "_taskID",
        "_title",
        "_description",
        ["_type", "Move"],
        ["_destination", objNull],
        ["_parent", ""]
    ];

    private _priority = _count - 1 - _forEachIndex;
    private _assign   = (_forEachIndex == 0);

    ["SAS_Briefing_fnc_createTasks: task " + str (_forEachIndex + 1) + "/" + str _count + " '" + _taskID + "' (priority: " + str _priority + ", assign: " + str _assign + ")"] call SAS_fnc_logDebug;

    private _task = [_taskID, _title, _description, _type, _destination, _assign, _priority, _parent] call SAS_Briefing_fnc_createTask;
    _createdTasks pushBack _task;
} forEach _this;

["SAS_Briefing_fnc_createTasks: done"] call SAS_fnc_logDebug;

_createdTasks
