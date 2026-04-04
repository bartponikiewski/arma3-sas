/*
    Description:
    Returns the loading screen state.

    Usage:
    waitUntil { [] call SAS_Init_fnc_getLoadingState };

    Parameters:
    None

    Returns:
    BOOL - true when loading screen has finished, false otherwise
*/

missionNamespace getVariable ["SAS_Init_screenDone", false];
