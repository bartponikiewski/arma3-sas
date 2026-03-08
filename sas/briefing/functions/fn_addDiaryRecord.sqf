/*
    Description:
    Adds a single record to a diary subject. If the subject does not exist yet,
    it is created automatically. Uses diarySubjectExists to check existence.
    Diary commands are local — only executes on machines with an interface.

    Usage:
    ["SubjectName", "RecordName", "Record content"] call SAS_Briefing_fnc_addDiaryRecord;

    // Example — append an intel entry to a custom subject:
    ["Intel", "New Contact", "Armoured column spotted at grid 223344"] call SAS_Briefing_fnc_addDiaryRecord;

    Parameters:
    0: STRING - Subject name (used as both class identifier and display name)
    1: STRING - Record name
    2: STRING - Record content

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

if (!hasInterface) exitWith {
    ["SAS_Briefing_fnc_addDiaryRecord: skipped (no interface)"] call SAS_fnc_logDebug;
};
if (isNull player) exitWith {
    ["SAS_Briefing_fnc_addDiaryRecord: skipped (player is null)"] call SAS_fnc_logDebug;
};

params ["_subjectName", "_recordName", "_recordContent"];

// Create the subject only if it does not already exist
if !(player diarySubjectExists _subjectName) then {
    ["SAS_Briefing_fnc_addDiaryRecord: subject '" + _subjectName + "' not found — creating it"] call SAS_fnc_logDebug;
    player createDiarySubject [_subjectName, _subjectName];
};

["SAS_Briefing_fnc_addDiaryRecord: adding record '" + _recordName + "' to '" + _subjectName + "'"] call SAS_fnc_logDebug;

private _allSubjectRecords = player allDiaryRecords _subjectName;
private _existingRecord = _allSubjectRecords select {(_x select 1) == _recordName && (_x select 2) == _recordContent};

if (count _existingRecord > 0) exitWith {
    ["SAS_Briefing_fnc_addDiaryRecord: record '" + _recordName + "' already exists in '" + _subjectName + "' — skipping"] call SAS_fnc_logDebug;
};

player createDiaryRecord [_subjectName, [_recordName, _recordContent]];