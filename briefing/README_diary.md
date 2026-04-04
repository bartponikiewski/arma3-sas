
# SAS Briefing Module  Diary Functions

This module provides functions for populating the in-game diary (Arma 3 intel/notes screen). Key features include diary subject creation and briefing section management.

## Key Functions

### Create Diary Subject
**SAS_Briefing_fnc_createDiarySubject**

Creates a diary subject and populates it with records.

**Usage:**
```
[subjectName, records] call SAS_Briefing_fnc_createDiarySubject;
```

**Parameters:**
- subjectName: Subject name (identifier and display name)
- records: Array of `[recordName, recordContent]` pairs

---

### Create Briefing
**SAS_Briefing_fnc_createBriefing**

Creates a `Briefing` diary subject with standard operational sections.

**Usage:**
```
[] call SAS_Briefing_fnc_createBriefing;
[sections] call SAS_Briefing_fnc_createBriefing;
```

---

## Additional Functions
- Add diary records, create notes

See the functions directory for more details.

---

## Usage Example
```sqf
["Mission", [["Situation", "Enemy forces detected."]]] call SAS_Briefing_fnc_createDiarySubject;
[] call SAS_Briefing_fnc_createBriefing;
```

## Debugging
Enable `SAS_Debug_global` for debug output. All debug messages use `SAS_fnc_logDebug`.

## Standards
Follow [copilot-instructions.md](../../.github/copilot-instructions.md) for documentation and coding conventions.
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
