/*
    Description:
    Displays a black loading screen with animated "typing" loading text, shows mission
    name and author when available, credits SAS framework, and displays a centered
    logo bar at the end. The screen stays up until SAS_Init_fnc_finish is called.

    Usage:
    Runs automatically via postInit. To end the loading screen, call:
    [] call SAS_Init_fnc_finish;

    Parameters:

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};


private _customLines = [];
private _endDelay = 4;

// Spawn so postInit returns immediately and does not block mission loading.
// postInit suspends the loading pipeline while a function is suspended,
// so all waitUntil/sleep logic must run in its own scheduled thread.
[_customLines, _endDelay] spawn {
    params ["_customLines", "_endDelay"];


    // Black out
    waitUntil { time > 0 };
    waitUntil { !isNull player };
    private _devMode = missionNamespace getVariable ["SAS_Dev_mode", false];
    if (_devMode) exitWith {
        [true] call SAS_Init_fnc_setLoadingState;
        ["[SAS_Init]: Skipping loading screen due to dev mode"] call SAS_fnc_logDebug;
    };

    [] call SAS_fnc_blackOut;

    private _startTime = time;
    [false] call SAS_Init_fnc_setLoadingState;
    ["[SAS_Init] fn_loadingScreen: Started"] call SAS_fnc_logDebug;

  



    // Determine mission/author if present in description.ext
    private _author = getMissionConfigValue ["author", "Unknown"];
    private _missionName = getMissionConfigValue ["briefingName", "Classified"];
    private _onLoadMissionName = getMissionConfigValue ["onLoadName", ""];
    private _subText = format ["<t size='1' font='RobotoCondensed' color='#FFFFFFFF' align='center'><br/><br/>Author: %1 Mission: %2</t><br/><img image='sas\assets\images\logo_bar.paa' size='4' />", _author, _missionName];

    if (_onLoadMissionName != "") then {
        _missionName = _onLoadMissionName;
    };

    // Loading lines pool
    private _lines = [];
    if ((count _customLines) > 0) then {
        _lines = _customLines;
    } else {
        _lines = [
            "Initializing mission...",
            "Loading scripts...",
            "Synchronizing players...",
            "Preparing assets...",
            "Configuring environment...",
            "Setting up objectives...",
            "Loading terrain data...",
            "Calibrating equipment...",
            "Establishing communications..."
        ];
    };

    // Build static HTML block for mission/author and a smaller logo below
    2 cutText [_subText, "PLAIN", -1, true, true];

    // Show random lines until init is done
    private _isDone = missionNamespace getVariable ["SAS_Init_done", false];
    private _playersPresent = ({alive _x && isPlayer _x} count allPlayers) > 0;
    private _minDisplayTime = 10; // Minimum time to show loading screen

    private _shownLines = [];
    while { !_isDone || !_playersPresent || time < (_startTime + _minDisplayTime) } do {
        // Pick a random line that hasn't been shown yet
        _isDone = missionNamespace getVariable ["SAS_Init_done", false];
        _playersPresent = ({alive _x && isPlayer _x} count allPlayers) > 0;

        private _available = _lines - _shownLines;
        if (count _available == 0) then {
            _shownLines = [];
            _available = _lines;
        };
        private _line = selectRandom _available;
        _shownLines pushBack _line;

        if (count _shownLines == count _lines) then {
            _shownLines = [];
        };

        if (_isDone && _playersPresent && time >= (_startTime + _minDisplayTime)) then {
           _line = "Finalizing setup...";
        };

        [
            [_line],
            0,
            0.4,
            "<t color='#FFFFFFFF' align='center'>%1</t>"
        ] call BIS_fnc_typeText;
    };


    // Black in and restore environment
    2 cutFadeOut 1;
    sleep 2;
    [] call SAS_fnc_blackIn;

    // Mark screen as done and log completion
    [true] call SAS_Init_fnc_setLoadingState;
    ["[SAS_Init] fn_loadingScreen: Completed"] call SAS_fnc_logDebug;
};
