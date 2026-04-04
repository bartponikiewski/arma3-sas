/*
    Description:
    Sets the loading screen state.

    Usage:
    [true] call SAS_Init_fnc_setLoadingState;

    Parameters:
    0: BOOL - true when loading screen is finished, false otherwise

    Returns:
    Nothing
*/
params [["_done", false, [false]]];

missionNamespace setVariable ["SAS_Init_screenDone", _done];
