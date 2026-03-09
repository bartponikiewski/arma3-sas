/*
    Description:
    Plays the intro sequence with scrolling text lines, an optional title card,
    screen blackout, and optional music.

    Usage:
    [["line1","line2","line3"], ["Title1", "Title2", "Title3"], ["MusicClassName", true]] spawn SAS_Intro_fnc_opening;

    Parameters:
    0: ARRAY  - Array of text strings to display sequentially
    1: ARRAY  - (Optional) Array of title lines displayed after the text lines (default: [[]])
    2: ARRAY  - (Optional) Array of music class and control to stop or not (default: ["", true])
		- 0: Music class name to play (empty for no music)
		- 1: Boolean whether to stop music at the end (default: true)
	3: ARRAY  - (Optional) Array of fade control (default: [true, true])
		- 0: Boolean whether to black out the screen (default: true)
		- 1: Boolean whether to black in the screen at the end (default: true)
	4: CODE   - (Optional) Callback code to execute after the intro finishes, before black in (default: {})

    Returns:
    Nothing
*/

//-->Parameters
params [
    ["_strArr", [], [[]]],
    ["_titleLines", [], [[]]],
	["_musicControl", ["", true], [[]]],
	["_fadeControl", [true, true], [[]]],
	["_callback", {}]
];
 _musicControl params ["_musicClass", "_stopMusic"];
 _fadeControl params ["_blackOut", "_blackIn"];

private _radioState = radioEnabled;

//-->Validate
if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {(!isNull player)};
waitUntil {time > 0};

//-->Black out
if (_blackOut) then {
    [] call SAS_fnc_blackOut;
};



if (_musicClass != "") then {
    playMusic _musicClass;
};


{
	private _txt = _x;
	private _time = (count _txt * 0.07) max 4;

	2 cutText [ format["<t size='1.5' font='RobotoCondensed' color='#FFFFFFFF' align='center'>%1</t>",_txt], "PLAIN", 0, true, true];
	sleep _time;
	2 cutFadeOut 1;
	sleep 0.5;
	2 cutText ["", "PLAIN", 0];
} forEach _strArr;

if (!isNil "_titleLines") then {

	//-->Format title lines with different sizes
	private _formattedLines = [];

	for "_i" from 0 to (count _titleLines - 1) do {
		private _line = _titleLines select _i;
		switch _i do {
			case 0: { _formattedLines pushBack [_line, "<t size='2.5' font='RobotoCondensedBold'>%1</t><br/>", 15], };
			case 1: { _formattedLines pushBack [_line, "<t size='1' font='RobotoCondensed'>%1</t><br/>", 15], };
			default { _formattedLines pushBack [_line, "<t size='0.8' font='RobotoCondensed'>%1</t><br/>", 15], };;
		};
	};

	// private _type = [_formattedLines, 0, 0.5, "<t color='#FFFFFFFF' align='center'>%1</t>"] call BIS_fnc_typeText;
	_type = [_formattedLines, 0, 0.3, "<t color='#FFFFFFFF' align='center'>%1</t>"] call BIS_fnc_typeText;
};

if (!isNil "_callback") then {
	[] call _callback;
};

if (_stopMusic) then {
	[] spawn {5 fadeMusic 0; sleep 5; playMusic ""};
};

if (_blackIn) then {
	[] call SAS_fnc_blackIn;
};