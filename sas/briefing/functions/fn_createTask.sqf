/*
    Description:
    Creates a mission task and assigns it to all players.
    BIS_fnc_taskCreate handles network synchronisation and JIP internally.
    Should be called on the server.

    Defaults applied internally (not exposed as params):
    - owners:           allPlayers
    - priority:         0
    - showNotification: true
    - initialState:     "Created" (use param 6 to assign immediately)
    - bringUpTaskMenu:  false

    Usage:
    // Minimal — no map destination
    ["taskClearArea", "Clear the Area", "Eliminate all enemy forces."] call SAS_Tasks_fnc_createTask;

    // With a map marker name as destination
    ["taskClearArea", "Clear the Area", "Eliminate all enemy forces.", "markerObjective"] call SAS_Tasks_fnc_createTask;

    // With a position array as destination
    ["taskClearArea", "Clear the Area", "Eliminate all enemy forces.", getPos myObject] call SAS_Tasks_fnc_createTask;

    // With an object as destination (task marker will track the object)
    ["taskClearArea", "Clear the Area", "Eliminate all enemy forces.", myObject] call SAS_Tasks_fnc_createTask;

    // With a custom task icon type
    ["taskClearArea", "Clear the Area", "Eliminate all enemy forces.", "markerObjective", "Attack"] call SAS_Tasks_fnc_createTask;

    // As a sub-task nested under a parent
    ["taskDestroyRadar", "Destroy the Radar", "Blow up the radar dish.", "markerRadar", "Destroy", "taskClearArea"] call SAS_Tasks_fnc_createTask;

    // Immediately assign the task as current (only one task can be assigned at a time)
    ["taskClearArea", "Clear the Area", "Eliminate all enemy forces.", "markerObjective", "Attack", "", true] call SAS_Tasks_fnc_createTask;

    Parameters:
    0: STRING              - Unique task ID
    1: STRING              - Task title (shown in task list and on map)
    2: STRING              - Task description (shown in task details panel)
    3: (Optional) STRING   - Task type, controls the icon. Common values: "Attack", "Defend", "Move", "Destroy", "Capture", "Pickup", "Recon" (default: "Move")
    4: (Optional) STRING, ARRAY, or OBJECT - Task destination (default: "", i.e. no destination)
        STRING → marker name; position is taken from the marker
        ARRAY  → position [x, y, z]; passed directly
        OBJECT → task marker tracks the object on the map
    5: (Optional) BOOL     - Assign the task as current immediately. Only one task can be assigned at a time. (default: false)
    6: (Optional) NUMBER   - Task priority (default: -1)
    7: (Optional) STRING   - Parent task ID to nest this as a sub-task (default: "", i.e. top-level)

    Returns:
    TASK - The created task object

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

params [
    "_taskID",
    "_title",
    "_description",
    ["_type", "Move"],
    ["_destination", objNull, [objNull, [], ""]],
    ["_assign", false, [false]],
    ["_priority", -1, [0]],
    ["_parent", "", [""]]
];

if (!isServer) exitWith {
    ["SAS_Tasks_fnc_createTask: skipped (not server)"] call SAS_fnc_logDebug;
};

[format ["SAS_Tasks_fnc_createTask: creating task '%1' (type: %2, destination: %3, parent: '%4', assign: %5)", _taskID, _type, _destination, _parent, _assign]] call SAS_fnc_logDebug;

if ((typeName _destination == "STRING") && !(_destination isEqualTo "")) then {
   _destination =  getMarkerPos _destination; 
};

if (_parent isEqualTo "") then {
    _taskID = [_taskID, _parent];
};

private _initialState = if (_assign) then { "Assigned" } else { "Created" };

private _task = [
    allPlayers,
    _taskID,
    [_description, _title, ""],
    _destination,
    _initialState,
    _priority,
    missionNamespace getVariable ["SAS_Briefing_TaskShowNotification", false],
    _type,
    missionNamespace getVariable ["SAS_Briefing_Task3D", false]
] call BIS_fnc_taskCreate;


[missionNamespace, "SAS_Briefing_TaskCreated", [_taskID]] remoteExecCall ["BIS_fnc_callScriptedEventHandler", 0];

[format ["SAS_Tasks_fnc_createTask: task '%1' created successfully", _taskID]] call SAS_fnc_logDebug;

_taskID
