// SAS Basic settings
missionNamespace setVariable ["SAS_Briefing_TaskShowNotification", false];
missionNamespace setVariable ["SAS_Briefing_Task3D", false];
missionNamespace setVariable ["SAS_Debug_global", true];

// SAS Example Briefing
[
	["Mission",   "Capture the enemy HQ at grid 123456."],
	["Situation", "Enemy forces are entrenched in the area."],
	["Execution", "Phase 1: Approach under cover of darkness."],
] call SAS_Briefing_fnc_createBriefing;

// SAS Example Intel
[
	["Enemy forces", "Mostly infantry with some light vehicles, estimated strength of 20-30 combatants."],
	["Civilians", "Local farmers reported increased activity in the area."],
] call SAS_Briefing_fnc_createIntel;

// SAS Example notes
[
	["Credits", "Mission created by Sushi. Thanks for playing!"],
	["Tech notes", "This mission is using Sushi Arma Scripts framework v1.0.0"],
] call SAS_Briefing_fnc_createIntel;

// SAS Example tasks
[
	["task1", "Secure the area", "Move to the designated location and secure it.", "Move", "marker1"],
	["task2", "Eliminate targets", "Engage and eliminate all hostiles in the area.", "Kill", objNull],
] call SAS_Briefing_fnc_createTasks;


