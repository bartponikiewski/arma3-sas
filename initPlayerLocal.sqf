// --> Wait for loading screen to finish
waitUntil { [] call SAS_Init_fnc_getLoadingState };

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

// --> Example subtitle sequence with 3 entries and a global audio track
[
	[
		["HQ", "At ease soldier!", 0],
		["Harris", "Welcome in SAS - Sushi Arma Scripts dev environment.", 1.5],
		["Harris", "Look around and take your time.", 5]
	],
	"SAS_Welcome",
	officer_1
] call SAS_Conv_fnc_subtitle;

// --> Other
[] call SAS_Intro_fnc_infoText;
