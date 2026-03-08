# SAS Briefing — Diary Functions

Functions for populating the in-game diary (Arma 3 intel/notes screen).

All diary commands are **local** — these functions only run on machines with an interface. Call them from `initPlayerLocal.sqf` or equivalent, never from `init.sqf` without an `hasInterface` guard.

---

## Functions

### `SAS_Briefing_fnc_createDiarySubject`

Creates a diary subject and populates it with records. If the subject already exists it is reused. Core function — all other diary helpers are wrappers around this.

```sqf
["SubjectName", [
    ["RecordName",  "Record content"],
    ["RecordName2", "Record content"],
]] call SAS_Briefing_fnc_createDiarySubject;
```

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | STRING | Subject name (identifier and display name) | — |
| 1 | ARRAY | `[recordName, recordContent]` pairs | `[]` |

Returns: Nothing

---

### `SAS_Briefing_fnc_createBriefing`

Creates a `Briefing` diary subject with standard operational sections. Defaults to empty Mission / Situation / Execution sections if no records are passed.

```sqf
// Default sections:
[] call SAS_Briefing_fnc_createBriefing;

// Custom sections:
[
    ["Mission",   "Capture the enemy HQ at grid 123456."],
    ["Situation", "Enemy forces are entrenched in the area."],
    ["Execution", "Phase 1: approach under cover of darkness."],
] call SAS_Briefing_fnc_createBriefing;
```

| # | Type | Description | Default |
|---|------|-------------|---------|
| 0 | ARRAY | `[sectionName, content]` pairs | `[["Mission",""],["Situation",""],["Execution",""]]` |

Returns: Nothing

---

### `SAS_Briefing_fnc_createNotes`

Creates a `Notes` diary subject with custom records.

```sqf
[
    ["Friendly forces", "Two squads are operating in the AO."],
    ["ROE",             "Weapons free on confirmed combatants."],
] call SAS_Briefing_fnc_createNotes;
```

| # | Type | Description |
|---|------|-------------|
| 0 | ARRAY | `[recordName, recordContent]` pairs |

Returns: Nothing

---

### `SAS_Briefing_fnc_createIntel`

Creates an `Intel` diary subject with custom records.

```sqf
[
    ["Enemy forces", "Armoured column spotted at grid 223344."],
    ["Civilians",    "Increased activity reported near the village."],
] call SAS_Briefing_fnc_createIntel;
```

| # | Type | Description |
|---|------|-------------|
| 0 | ARRAY | `[recordName, recordContent]` pairs |

Returns: Nothing

---

### `SAS_Briefing_fnc_addDiaryRecord`

Adds a single record to a diary subject. Creates the subject automatically if it does not exist. Duplicate records (same name **and** content) are silently skipped.

```sqf
["Intel", "New Contact", "T-72 spotted at grid 334455."] call SAS_Briefing_fnc_addDiaryRecord;
```

| # | Type | Description |
|---|------|-------------|
| 0 | STRING | Subject name |
| 1 | STRING | Record name |
| 2 | STRING | Record content |

Returns: Nothing

---

## Notes

- Record content supports Arma 3 structured text tags: `<br/>`, `<b>`, `<i>`, `<marker name="..."/>`, etc.
- All functions guard against non-interface machines (`hasInterface`, `isNull player`) and exit silently — safe to call without environment checks on the caller side.
