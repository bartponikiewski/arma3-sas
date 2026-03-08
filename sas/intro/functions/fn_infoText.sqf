/*
	Description:
	Displays an intro info text overlay in the bottom-right corner of the screen,
	showing player name, location, date, and time. Optionally shows cinema borders.

	Usage:
	[_line1, _line2, _border] call SAS_Intro_fnc_infoText;

	Parameters(s):
	0: (Optional): STRING - First line of text, defaults to player name (default: "")
	1: (Optional): STRING - Second line of text, defaults to nearest village name (default: "")
	2: (Optional): BOOL - Whether to show cinema border (default: false)

	Returns:
	Nothing

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

//-->Parameters
params [
	["_line1", "", [""]],
	["_line2", "", [""]],
	["_border", false, [false]]
];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {(!isNull player)};

["[SAS_intro_fnc_infoText] Starting info text intro | Line1: " + _line1 + " | Line2: " + _line2 + " | Border: " + str _border] call SAS_fnc_logDebug;

//-->Variables
if (_line1 == "") then {
	_line1 = format["%1", name player];
};
if (_line2 == "") then {
	_line2 = player call BIS_fnc_locationDescription;
};

private _date = str(date select 1) + "." + str(date select 2) + "." + str(date select 0);

//-->Get time
private _timeH = if ((date select 3) < 10) then { format["0%1", date select 3] } else { str (date select 3) };
private _timeM = if ((date select 4) < 10) then { format["0%1", date select 4] } else { str (date select 4) };
private _time = format["%1:%2", _timeH, _timeM];

["[SAS_intro_fnc_infoText] Displaying info text | Line1: " + _line1 + " | Line2: " + _line2] call SAS_fnc_logDebug;

//-->Main scope
private _output = [
	[_date, "<t size='0.9' font='PuristaMedium'>%1</t>", 0],
	[_time, "<t size='0.9' font='PuristaBold'>%1</t><br/>", 5],
	[toUpper _line1, "<t size='1.2' font='PuristaBold'>%1</t><br/>", 5],
	[_line2, "<t size='0.8'>%1</t><br/>", 30]
];

if (_border) then { [0, 2, false, true] call BIS_fnc_cinemaBorder; };

// Info text
[_output, -safezoneX, 0.85, "<t color='#FFFFFFFF' align='right'>%1</t>"] call BIS_fnc_typeText;

if (_border) then { sleep 3; [1, 2, false, true] call BIS_fnc_cinemaBorder; };

