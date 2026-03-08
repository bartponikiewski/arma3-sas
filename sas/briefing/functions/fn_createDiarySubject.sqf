/*
    Description:
    Creates a diary subject and populates it with provided records.
    Diary commands are local — only executes on machines with an interface.

    Usage:
    ["SubjectName", [
        ["RecordName1", "Record content"],
        ["RecordName2", "Record content"],
    ]] call SAS_Briefing_fnc_createDiarySubject;

    Parameters:
    0: STRING - Subject name (used as both class identifier and display name)
    1: ARRAY  - Array of [recordName, recordContent] pairs

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

if (!hasInterface) exitWith {
    ["SAS_Briefing_fnc_createDiarySubject: skipped (no interface)"] call SAS_fnc_logDebug;
};
if (isNull player) exitWith {
    ["SAS_Briefing_fnc_createDiarySubject: skipped (player is null)"] call SAS_fnc_logDebug;
};

params ["_subjectName", ["_records", []]];

["SAS_Briefing_fnc_createDiarySubject: creating subject '" + _subjectName + "'"] call SAS_fnc_logDebug;

if !(player diarySubjectExists _subjectName) then {
    player createDiarySubject [_subjectName, _subjectName];
};

{
    _x params ["_recordName", "_recordContent"];
    ["SAS_Briefing_fnc_createDiarySubject: adding record '" + _recordName + "'"] call SAS_fnc_logDebug;
    [_subjectName, _recordName, _recordContent] call SAS_Briefing_fnc_addDiaryRecord;
} forEach _records;
