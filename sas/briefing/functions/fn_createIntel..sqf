/*
    Description:
    Creates a "Intel" diary subject and populates it with provided records.
    Wrapper around SAS_Briefing_fnc_createDiarySubject.
    Diary commands are local — only executes on machines with an interface.

    Usage:
    [
        ["Enemy forces", "Armoured column spotted at grid 223344"],
        ["Civilians", "Local farmers reported increased activity in the area."],
    ] call SAS_Briefing_fnc_createIntel;

    Parameters:
    0: ARRAY - Array of [recordName, recordContent] pairs

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug info if SAS_Debug_global is true.
*/

if (!hasInterface) exitWith {
    ["SAS_Briefing_fnc_createIntel: skipped (no interface)"] call SAS_fnc_logDebug;
};

params ["_records"];

["SAS_Briefing_fnc_createIntel: creating Intel subject"] call SAS_fnc_logDebug;

["Intel", _records] call SAS_Briefing_fnc_createDiarySubject;
