/*
    Description:
    Displays a black loading screen with animated "typing" loading text, shows mission
    name and author when available, credits SAS framework, and displays a centered
    logo bar at the end. The screen stays up until SAS_Init_fnc_finish is called.

    Usage:
    Runs automatically via postInit. To end the loading screen, call:
    [] call SAS_Init_fnc_finish;

    Parameters:
    0: (Optional) ARRAY - Array of strings to display as loading lines (default: prebuilt)
    1: (Optional) NUMBER - Delay after the sequence finishes before black in (default: 2)

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/
params [
    ["_customLines", [], [[]]],
    ["_endDelay", 4, [2]]
];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};


private _startTime = time;
["[SAS_Init] fn_loadingScreen: Started"] call SAS_fnc_logDebug;
private _devMode = missionNamespace getVariable ["SAS_Dev_mode", false];
if (_devMode) exitWith {
    ["[SAS_Init]: Skipping loading screen due to dev mode"] call SAS_fnc_logDebug;
};

// Black out
[] call SAS_fnc_blackOut;

// Determine mission/author if present in description.ext
private _author = getMissionConfigValue ["author", "Unknown"];
private _missionName = getMissionConfigValue ["briefingName", "Classified"];
private _onLoadMissionName = getMissionConfigValue ["onLoadName", ""];

if (_onLoadMissionName != "") then {
	_missionName = _onLoadMissionName;
};

// Default loading lines if none provided
private _lines = [];
if ((count _customLines) > 0) then {
    _lines = _customLines;
} else {
    _lines = ["Initializing mission...", "Loading scripts...", "Finalizing..."];
};

// Build static HTML block for mission/author and a smaller logo below
2 cutText [format ["<t size='1' font='RobotoCondensed' color='#FFFFFFFF' align='center'><br/><br/>Author: %1 | Mission: %2</t><br/><img image='sas\assets\logo_bar.paa' size='4' />", _author, _missionName], "PLAIN", -1, true, true];

{
	[
		[_x],
		0,
		0.4,
		"<t color='#FFFFFFFF' align='center'>%1</t>"
	] call BIS_fnc_typeText;
} foreach _lines;

// Wait for players to be present
waitUntil { ({alive _x && isPlayer _x} count allPlayers) > 0 };

// Wait until init is finished (SAS_Init_fnc_finish is called)
missionNamespace setVariable ["SAS_Init_done", false, true];
waitUntil { missionNamespace getVariable ["SAS_Init_done", false] };


// Black in and restore environment
2 cutFadeOut 1;
sleep 2;
[] call SAS_fnc_blackIn;

// Log completion
["[SAS_Init] fn_loadingScreen: Completed"] call SAS_fnc_logDebug;
