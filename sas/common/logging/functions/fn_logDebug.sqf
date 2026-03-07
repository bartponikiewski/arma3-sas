/*
    Description:
    Logs debug messages for SAS framework. Displays in-game hint if global debug flag is enabled.

    Usage:
    ["Your debug message"] call SAS_fnc_logDebug;

    Parameter(s):
    0: STRING - The debug message to display

    Returns:
    Nothing
*/

params ["_msg"];

if (!isNil "SAS_Debug_global" && SAS_Debug_global) then {
    hint format ["[SAS DEBUG] %1", _msg];
};
