/*
    Description:
    Creates a "Briefing" diary subject with standard briefing sections.
    Wrapper around SAS_Briefing_fnc_createDiarySubject.
    Diary commands are local — only executes on machines with an interface.

    Usage:
    // Default sections (Mission, Situation, Execution with empty content):
    [] call SAS_Briefing_fnc_createBriefing;

    // Custom sections:
    [
        ["Mission",   "Capture the enemy HQ at grid 123456."],
        ["Situation", "Enemy forces are entrenched in the area."],
        ["Execution", "Phase 1: Approach under cover of darkness."],
    ] call SAS_Briefing_fnc_createBriefing;

    Parameters:
    0: (Optional) ARRAY - Array of [sectionName, content] pairs
        Default: [["Mission", ""], ["Situation", ""], ["Execution", ""]]

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

if (!hasInterface) exitWith {
    ["SAS_Briefing_fnc_createBriefing: skipped (no interface)"] call SAS_fnc_logDebug;
};

params [
    ["_records", [
        ["Mission",   ""],
        ["Situation", ""],
        ["Execution", ""]
    ], [[]]]
];

["SAS_Briefing_fnc_createBriefing: creating Briefing subject"] call SAS_fnc_logDebug;

["Briefing", _records] call SAS_Briefing_fnc_createDiarySubject;
