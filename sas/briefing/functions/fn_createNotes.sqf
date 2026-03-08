/*
    Description:
    Creates a "Notes" diary subject and populates it with provided records.
    Wrapper around SAS_Briefing_fnc_createDiarySubject.
    Diary commands are local — only executes on machines with an interface.

    Usage:
    [
        ["Objectives", "1. Secure the LZ<br/>2. Eliminate HVT"],
        ["Intel",      "Enemy patrol route: grid 112233 to 445566"],
    ] call SAS_Briefing_fnc_createNotes;

    Parameters:
    0: ARRAY - Array of [recordName, recordContent] pairs

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

if (!hasInterface) exitWith {
    ["SAS_Briefing_fnc_createNotes: skipped (no interface)"] call SAS_fnc_logDebug;
};

params ["_records"];

["SAS_Briefing_fnc_createNotes: creating Notes subject"] call SAS_fnc_logDebug;

["Notes", _records] call SAS_Briefing_fnc_createDiarySubject;
