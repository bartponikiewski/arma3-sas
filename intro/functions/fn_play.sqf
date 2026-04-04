

/*
	Description:
	Plays the mission intro sequences (opening, UAV, quote) according to provided entries.

	Usage:
	[_introEntries] call SAS_Intro_fnc_play;
	Example:
	[
		["QUOTE"],
		[
			"OPENING", 
			[
				[
					"Story Line 1.",
					"Story Line 2",
					"Story Line 3"
				], 
				["Mission Title", "Subtitle", "Additional line"], 
				["LeadTrack01_F_Tacops", true]
			]
		],
		["UAV", player]
	] call SAS_Intro_fnc_play;

	Parameters(s):
	0: Array - Array of intro entries. Each entry is an array where:
	   0: String - Type name ("OPENING", "UAV", "QUOTE")
	   1: (Optional) Array - Parameters passed to the handler for the given type (default: [])

	Returns:
	Nothing.

	Debug:
	Respects SAS_Dev_mode and uses SAS_fnc_logDebug for logging.
*/

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};
waitUntil {(!isNull player)};
waitUntil {time > 0};

private _devMode = missionNamespace getVariable ["SAS_Dev_mode", false];
if (_devMode) exitWith { ["[SAS_Intro]: Skipping intro due to dev mode"] call SAS_fnc_logDebug; };

private _introEnabled = [] call SAS_Intro_fnc_enabled;
if (!_introEnabled) exitWith { ["[SAS_Intro]: Intro is disabled."] call SAS_fnc_logDebug; };

{
	_x params ["_type", ["_typeParams", []]];

	switch (_type) do {
		case "OPENING": {
			_typeParams call SAS_Intro_fnc_opening;
		};
		case "UAV": {
			_typeParams call SAS_Intro_fnc_uav;
		};
		case "QUOTE": {
			_typeParams call SAS_Intro_fnc_quote;
		};
	}
} foreach _this;
