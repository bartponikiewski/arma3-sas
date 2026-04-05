/*
    Description:
    Terminates a running subtitle sequence started by SAS_Conv_fnc_subtitle.
    Stops both the subtitle text display and any associated audio.

    Usage:
    ["myHandle"] call SAS_Conv_fnc_subtitleTerminate;

    Parameter(s):
    0: STRING - The handle variable name that was passed to SAS_Conv_fnc_subtitle

    Returns:
    Nothing
*/

params [
    ["_handle", "", [""]]
];

if (_handle isEqualTo "") exitWith {
    (["[SAS_Conv_fnc_subtitleTerminate] No handle provided"]) call SAS_fnc_logDebug;
};

private _textVar  = format ["%1_text", _handle];
private _soundVar = format ["%1_sound", _handle];

private _textHandle = missionNamespace getVariable [_textVar, scriptNull];
private _soundSrc   = missionNamespace getVariable [_soundVar, objNull];

// Terminate subtitle script
if (!isNull _textHandle) then {
    terminate _textHandle;
    (["[SAS_Conv_fnc_subtitleTerminate] Terminated subtitle text for handle '" + _handle + "'"]) call SAS_fnc_logDebug;
};

// Stop audio
if (!isNull _soundSrc) then {
    deleteVehicle _soundSrc;
    (["[SAS_Conv_fnc_subtitleTerminate] Deleted sound source for handle '" + _handle + "'"]) call SAS_fnc_logDebug;
};

// Clean up
missionNamespace setVariable [_textVar, nil];
missionNamespace setVariable [_soundVar, nil];

(["[SAS_Conv_fnc_subtitleTerminate] Cleanup complete for handle '" + _handle + "'"]) call SAS_fnc_logDebug;
