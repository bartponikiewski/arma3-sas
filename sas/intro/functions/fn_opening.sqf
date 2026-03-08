/*
    Description:
    Plays the intro sequence with scrolling text lines, an optional title card,
    screen blackout, and optional music.

    Usage:
    [["line1","line2","line3"], "Title", true, "MusicClassName"] spawn SAS_Intro_fnc_opening;

    Parameters:
    0: ARRAY  - Array of text strings to display sequentially
    1: ARRAY  - (Optional) Array of title lines displayed after the text lines (default: [[]])
    2: STRING - (Optional) Music class name to play (default: "")
	3: BOOL   - (Optional) Whether to black out the screen (default: true)
	4: BOOL   - (Optional) Whether to black in the screen at the end (default: true)
	5: CODE   - (Optional) Callback code to execute after the intro finishes, before black in (default: {})

    Returns:
    Nothing
*/

//-->Parameters
params [
    ["_strArr", [], [[]]],
    ["_titleLines", [], [[]]],
	["_music", "", [""]],
    ["_blackOut", true, [true]],
	["_blackIn", true, [true]],
	["_callback", {}]
];
private _radioState = radioEnabled;

//-->Validate
if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

//-->Black out
if (_blackOut) then {
    1 cutText ["", "BLACK FADED", 999];
	0 fadeSound 0;
    enableEnvironment false;
    clearRadio;
    enableRadio false;
};

waitUntil {(!isNull player)};

[] spawn { player action ["SwitchWeapon", vehicle player, vehicle player, 99] };

if (_music != "") then {
    playMusic _music;
};


{
	private _txt = _x;
	private _time = (count _txt * 0.08) max 4;

	2 cutText [_txt, "PLAIN", 0];
	2 cutFadeOut _time;
	sleep _time;
	cutText ["", "PLAIN", 0];
} forEach _strArr;

if (!isNil "_titleLines") then {

	//-->Format title lines with different sizes
	private _formattedLines = [];

	for "_i" from 0 to (count _titleLines - 1) do {
		private _line = _titleLines select _i;
		switch _i do {
			case 0: { _formattedLines pushBack [_line, "<t size='1.2' font='RobotoCondensedBold'>%1</t><br/>", 15], };
			case 1: { _formattedLines pushBack [_line, "<t size='1.0' font='RobotoCondensed'>%1</t><br/>", 15], };
			default { _formattedLines pushBack [_line, "<t size='0.8' font='RobotoCondensed'>%1</t><br/>", 15], };;
		};
	};

	private _type = [_formattedLines, 0, 0.5, "<t color='#FFFFFFFF' align='center'>%1</t>"] call BIS_fnc_typeText;
};

if (!isNil "_callback") then {
	[] call _callback;
};

if (_blackIn) then {
	//Blur effect
	sleep 3;
	"dynamicBlur" ppEffectEnable true;
	"dynamicBlur" ppEffectAdjust [6];
	"dynamicBlur" ppEffectCommit 0;
	"dynamicBlur" ppEffectAdjust [0.0];
	"dynamicBlur" ppEffectCommit 5;

	//Black in
	1 cutText ["", "BLACK IN", 5];
};

[] spawn { waitUntil { time > 3 }; player action ["SwitchWeapon", vehicle player, vehicle player, 0] };
enableEnvironment true;
enableRadio _radioState;
3 fadeSound 1;
