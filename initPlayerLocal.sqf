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
			["SAS", "Sushi ArmA Scripts", "v1.0.0"], 
			["LeadTrack01_F_Tacops", true]
		]
	],
	["UAV", player]
] call SAS_Intro_fnc_play;

// --> Other
[] call SAS_Intro_fnc_infoText;