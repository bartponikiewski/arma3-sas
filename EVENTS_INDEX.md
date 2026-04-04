# SAS Events Reference

All SAS modules emit scripted events using `BIS_fnc_callScriptedEventHandler`.
You can listen for them with `SAS_Event_fnc_onEvent` (registers on `missionNamespace`).

## Listening for events

```sqf
// Register a handler
private _id = ["SAS_CovertOps_coverBlown", {
    params ["_unit", "_enemy"];
    hint format ["%1 was spotted by %2!", name _unit, name _enemy];
}] call SAS_Event_fnc_onEvent;

// Remove a handler when no longer needed
[missionNamespace, "SAS_CovertOps_coverBlown", _id] call BIS_fnc_removeScriptedEventHandler;
```

## Emitting custom events

```sqf
// Emit locally (this machine only)
["MyCustomEvent", [_someData]] call SAS_Event_fnc_emit;

// Emit globally (all machines)
["MyCustomEvent", [_someData], true] call SAS_Event_fnc_emit;
```

---

## Event catalog

### Briefing

| Event | Scope | Args | Emitted by |
|---|---|---|---|
| `SAS_Briefing_taskCreated` | Global | `[_taskID]` | `SAS_Briefing_fnc_createTask` |
| `SAS_Briefing_taskStateChanged` | Global* | `[_taskID, _oldState, _state]` | `SAS_Briefing_fnc_setTaskState` |

### Captive

| Event | Scope | Args | Emitted by |
|---|---|---|---|
| `SAS_Captive_fnc_captiveStateChanged` | Global* | `[_unit, _state, _caller]` | `SAS_Captive_fnc_setCaptiveState` |

### CovertOps

| Event | Scope | Args | Emitted by |
|---|---|---|---|
| `SAS_CovertOps_coverBlown` | Global | `[_unit, _enemy]` | `SAS_CovertOps_fnc_checkDetection` |

### Hostage

| Event | Scope | Args | Emitted by |
|---|---|---|---|
| `SAS_Hostage_fnc_hostageStateChanged` | Global* | `[_unit, _state, _caller]` | `SAS_Hostage_fnc_setHostageState` |

### Morale

| Event | Scope | Args | Emitted by |
|---|---|---|---|
| `SAS_Morale_groupFearChanged` | Global | `[_group, _oldFear, _newFear]` | `SAS_Morale_fnc_onUnitKilled` |

### State

| Event | Scope | Args | Emitted by |
|---|---|---|---|
| `SAS_State_changed_<scope>` | Global | `[_scope, _newState, _oldState]` | `SAS_State_fnc_set` |
| `SAS_State_changed_<scope>_<state>` | Global | `[_scope, _newState, _oldState]` | `SAS_State_fnc_set` |

> Use `SAS_State_fnc_onChanged` instead of listening for these directly — it handles
> scope/target filtering and JIP catch-up automatically.

---

## Scope legend

- **Global** — emitted via `remoteExec` to all machines (target `0`). Handler fires everywhere.
- **Global\*** — the emitting function itself uses `call` (local emit), but it is designed to be
  `remoteExec`'d, which makes the event fire on every machine. If you call the function directly
  instead of via `remoteExec`, the event will only fire locally on the calling machine.
- **Local** — emitted via `call` on the machine that triggered it. Handler fires only on that machine.
