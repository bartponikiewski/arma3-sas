/*
    Description:
    Creates a "Notes" diary subject and populates it with provided records.
    Wrapper around SAS_Briefing_fnc_createDiarySubject.
    Diary commands are local — only executes on machines with an interface.

    Usage:
    [
        ["Credits", "Mission designed by XYZ"],
        ["Tech notes", "This mission is using Sushi Arma Scripts framework v1.1.0"],
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


["SAS_Briefing_fnc_createNotes: creating Notes subject"] call SAS_fnc_logDebug;

["Notes", _this] call SAS_Briefing_fnc_createDiarySubject;
