# SAS Briefing — Task Functions

Functions for creating and managing mission tasks using the Arma 3 Task Framework (`BIS_fnc_task*`).

Task state changes are **network-synchronised** by the framework. Call task functions on the server (`isServer`) or from `init.sqf` with an `isServer` guard.

---

## Functions

### `SAS_Briefing_fnc_createTask`

Creates a single mission task and assigns it to all players.

The following are fixed internally and not exposed as parameters:

| Setting | Value |
|---------|-------|
| Owners | `allPlayers` |
| Initial state | `"Created"` — use param 5 to assign immediately |
| Show notification | `SAS_Briefing_TaskShowNotification` (namespace variable) |
| 3D waypoint | `SAS_Briefing_Task3D` (namespace variable) |

```sqf
// Minimal
["taskSeize", "Seize Alpha", "Capture the compound."] call SAS_Briefing_fnc_createTask;

// With marker as destination
["taskSeize", "Seize Alpha", "Capture the compound.", "Move", "markerAlpha"] call SAS_Briefing_fnc_createTask;

// With a position array as destination
["taskSeize", "Seize Alpha", "Capture the compound.", "Move", getPos myObj] call SAS_Briefing_fnc_createTask;

// With an object as destination (task marker tracks the object)
["taskSeize", "Seize Alpha", "Capture the compound.", "Move", myObj] call SAS_Briefing_fnc_createTask;

// Immediately assign as current task
["taskSeize", "Seize Alpha", "Capture the compound.", "Move", "markerAlpha", true] call SAS_Briefing_fnc_createTask;

// Sub-task nested under a parent
["taskRadar", "Destroy Radar", "Take out the comms dish.", "Destroy", "markerRadar", false, -1, "taskSeize"] call SAS_Briefing_fnc_createTask;
```

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | STRING | Unique task ID | — |
| 1 | STRING | Task title | — |
| 2 | STRING | Task description | — |
| 3 | STRING | Task type / icon: `"Attack"`, `"Defend"`, `"Move"`, `"Destroy"`, `"Capture"`, `"Pickup"`, `"Recon"` | `"Move"` |
| 4 | STRING \| ARRAY \| OBJECT | Destination: marker name, `[x,y,z]` position, or an object the task marker will follow | `objNull` |
| 5 | BOOL | Assign as current task immediately. Only one task can be assigned at a time. | `false` |
| 6 | NUMBER | Priority — higher value means higher importance. Managed automatically by `createTasks`. | `-1` |
| 7 | STRING | Parent task ID for nesting as a sub-task | `nil` |

Returns: `TASK`
Fires: [`SAS_Briefing_TaskCreated`](#sas_briefing_taskcreated)

---

### `SAS_Briefing_fnc_createTasks`

Creates multiple tasks from an ordered array. **Priority and initial assignment are derived from position** — the first entry is the primary objective (highest priority, immediately assigned), and each subsequent entry gets a lower priority and starts as `"Created"`.

```sqf
[
    ["taskSeize",   "Seize Alpha",      "Capture the compound.",           "Move",    "markerAlpha"],
    ["taskDestroy", "Destroy Ammo",     "Blow up the ammunition storage.", "Destroy", "markerAmmo"],
    ["taskExtract", "Extract to LZ",    "Reach the landing zone.",         "Move",    "markerLZ"],
] call SAS_Briefing_fnc_createTasks;
```

Given 3 tasks, the function assigns automatically:

| Index | Priority | State |
|-------|----------|-------|
| 0 | 2 (highest) | `Assigned` |
| 1 | 1 | `Created` |
| 2 | 0 | `Created` |

Sub-tasks can be included by providing a parent task ID as the last element:

```sqf
[
    ["taskAssault", "Assault the Base",  "Clear all enemy forces.",  "Attack",  "markerBase"],
    ["taskRadar",   "Destroy the Radar", "Take out the comms dish.", "Destroy", "markerRadar", "taskAssault"],
] call SAS_Briefing_fnc_createTasks;
```

**Per-task definition:** `[taskID, title, description, type, destination, parentID]`

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | STRING | Task ID | — |
| 1 | STRING | Title | — |
| 2 | STRING | Description | — |
| 3 | STRING | Task type | `"Move"` |
| 4 | STRING \| ARRAY \| OBJECT | Destination | `objNull` |
| 5 | STRING | Parent task ID | `nil` |

Returns: `ARRAY` of `TASK` objects in the same order as the input.

---

### `SAS_Briefing_fnc_setTaskState`

Sets a task to any valid state. All state-change wrappers below call this function internally.

```sqf
["taskSeize", "Succeeded"] call SAS_Briefing_fnc_setTaskState;
```

Valid states: `"Created"`, `"Assigned"`, `"Succeeded"`, `"Failed"`, `"Canceled"`

| # | Type | Description |
|---|------|-------------|
| 0 | STRING | Task ID |
| 1 | STRING | New state |

Returns: Nothing
Fires: [`SAS_Briefing_TaskStateChanged`](#sas_briefing_taskstatechanged)

---

### `SAS_Briefing_fnc_completeTask` / `failTask` / `cancelTask`

Convenience wrappers over `SAS_Briefing_fnc_setTaskState`.

```sqf
["taskSeize"] call SAS_Briefing_fnc_completeTask;  // → "Succeeded"
["taskSeize"] call SAS_Briefing_fnc_failTask;       // → "Failed"
["taskSeize"] call SAS_Briefing_fnc_cancelTask;     // → "Canceled"
```

| # | Type | Description |
|---|------|-------------|
| 0 | STRING | Task ID |

Returns: Nothing
Fires: [`SAS_Briefing_TaskStateChanged`](#sas_briefing_taskstatechanged) (via `setTaskState`)

---

## Scripted Event Handlers

These events fire on `missionNamespace`. Register handlers with `BIS_fnc_addScriptedEventHandler`.

### `SAS_Briefing_TaskCreated`

Fired after a task is successfully created by `SAS_Briefing_fnc_createTask`.

**Arguments:** `[taskID]`

| # | Type | Description |
|---|------|-------------|
| 0 | STRING | ID of the created task |

```sqf
[missionNamespace, "SAS_Briefing_TaskCreated", {
    params ["_taskID"];
    systemChat format ["Task created: %1", _taskID];
}] call BIS_fnc_addScriptedEventHandler;
```

---

### `SAS_Briefing_TaskStateChanged`

Fired after a task state changes, triggered by `SAS_Briefing_fnc_setTaskState` and all wrappers (`completeTask`, `failTask`, `cancelTask`).

**Arguments:** `[taskID, oldState, newState]`

| # | Type | Description |
|---|------|-------------|
| 0 | STRING | Task ID |
| 1 | STRING | Previous state |
| 2 | STRING | New state |

```sqf
[missionNamespace, "SAS_Briefing_TaskStateChanged", {
    params ["_taskID", "_oldState", "_newState"];
    if (_newState == "Succeeded") then {
        ["Mission complete!"] call SAS_fnc_guiMessage;
    };
}] call BIS_fnc_addScriptedEventHandler;
```

---

## Namespace Variables

Set these before calling task functions to control behaviour globally.

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `SAS_Briefing_TaskShowNotification` | BOOL | `false` | Show a "Task Assigned" HUD notification on task creation |
| `SAS_Briefing_Task3D` | BOOL | `false` | Show a 3D waypoint marker in the world for the task |

```sqf
// Enable both in init.sqf before creating tasks
missionNamespace setVariable ["SAS_Briefing_TaskShowNotification", true];
missionNamespace setVariable ["SAS_Briefing_Task3D", true];
```
