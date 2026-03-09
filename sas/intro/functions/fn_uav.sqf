/*
	Description:
	Displays an introusing UAV shot

	Usage:
	[_target, _str, _mode] call SAS_Intro_fnc_uav;

	Parameters(s):
	0: (Optional): OBJ or Array - target or target's position (default: player)
	1: (Optional): STRING - Text to display (default: "")
	2: (Optional): STRING - Mode - "Normal", "TI, "NVG" (default: "Normal") 

	Returns:
	Nothing

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

//-->Parameters
params [
	["_target", player, [objNull, []]],
	["_str", "", [""]],
	["_mode", "Auto", ["Auto", "Normal", "TI", "NVG"]]
];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {(!isNull player)};
waitUntil {time > 0};

private _prefix = toUpper(worldName)+", "+((getPos _target) call BIS_fnc_locationDescription);

if (_str != "") then {
	_str = _prefix + ", " + _str;
} else {
	_str = _prefix;
};

private _scriptHandle = [_target, _str] spawn BIS_fnc_establishingShot;

if (_mode == "Auto") then {
	//-->Determine mode based on time of day
	private _sunriseSunsetTimes = date call BIS_fnc_sunriseSunsetTime;
	private _sunrise = _sunriseSunsetTimes select 0;
	private _sunset = _sunriseSunsetTimes select 1;
	
	if ((dayTime > _sunrise) && (dayTime < _sunset)) then {
		//-->Daytime, use normal mode
		_mode = "Normal";
	} else {
		//-->Nighttime, use NVG mode
		_mode = "NVG";
	};
};

switch (_mode) do {
	case "TI": {
		true setCamUseTI 1;
	};
	case "NVG": {
		camUseNVG true;
	};
	case "Normal": {
		//-->Default, do nothing
	};
};

waitUntil {scriptDone _scriptHandle};

["[SAS_intro_fnc_uav] Starting UAV intro | Target: " + str _target + " | Text: " + _str + " | Mode: " + _mode] call SAS_fnc_logDebug;