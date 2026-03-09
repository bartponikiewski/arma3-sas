// --> Loading screen to make sure everything is in sync
[] call SAS_fnc_loadingScreen;

// --> Simple Intro sequence
[
	["QUOTE"],
	[
		"OPENING", 
		[
			[
				"This is",
				"a simple intro sequence example ",
				"for SAS framework"
			], 
			["SAS", "Sushi ArmA Scripts", "v1.0.0-a"], 
			["LeadTrack01_F_Tacops", true]
		]
	],
	["UAV", player]
] call SAS_Intro_fnc_play;

// --> Other
[] call SAS_Intro_fnc_infoText;