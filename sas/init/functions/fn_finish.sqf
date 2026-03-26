/*
    Description:
    Signals the loading screen to finish and fade in.
    Call this when all mission initialization scripts have completed.

    Usage:
    [] call SAS_Init_fnc_finish;

    Parameters:
    None

    Returns:
    Nothing
*/

if (!isServer) exitWith {
    ["[SAS_Init] fn_finish: Must be called on server"] call SAS_fnc_logDebug;
    false
};


missionNamespace setVariable ["SAS_Init_done", true, true];

["[SAS_Init] fn_finish: Init marked as done"] call SAS_fnc_logDebug;
