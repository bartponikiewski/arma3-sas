// SAS Basic settings
// missionNamespace setVariable ["SAS_Briefing_TaskShowNotification", false];
// missionNamespace setVariable ["SAS_Briefing_Task3D", false];

// --> Uncomment for development testing
// missionNamespace setVariable ["SAS_Debug_global", true];
// missionNamespace setVariable ["SAS_Dev_mode", true];


// Disable auto reporting
enableSentences false; 


/*
	BRIEFING Section
	Usage:
		To create briefing tasks, use:
		[
			["task1", "Task Title", "Task Description", "Task Type", taskOwner],
			["task2", "Task Title 2", "Task Description 2", "Task Type 2", taskOwner2]
		] call SAS_Briefing_fnc_createTasks;

		Task types: "Attack", "Defend", "Move", "Destroy", "Capture", "Pickup", "Recon" (default: "Move")

		To create briefing sections, use:
		[
			["Section Title 1", "Section Content 1"],
			["Section Title 2", "Section Content 2"]
		] spawn SAS_Briefing_fnc_createBriefing;

*/
// SAS Example tasks
[
	["task1", "Go there", "Lorem ipsum dolor sit amet.", "Move", civ_1],
	["task2", "Destroy that", "Lorem ipsum dolor sit amet.", "Destroy", tl_opfor_1]
] call SAS_Briefing_fnc_createTasks;

// SAS Example Briefing
[
	["Mission",   "Test SAS and complete the work"],
	["Situation", "Nothing works, figure it out and fix it."],
	["Execution", "Go there, do that, win the day."],
	["Support",   "You have nothing, good luck!"]
] spawn SAS_Briefing_fnc_createBriefing;

// SAS Example additional notes
[
	["Credits", "Mission created by Sushi. Thanks for playing!<br /><img image='sas\assets\logo_bar.paa' width=400 />"],
	["Tech notes", "This mission is using Sushi Arma Scripts framework v1.0.0<br /><img image='sas\assets\powered_by_sas_large.paa' width=200 />"]
] call SAS_Briefing_fnc_createNotes;






