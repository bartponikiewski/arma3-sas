// SAS Basic settings
// missionNamespace setVariable ["SAS_Briefing_TaskShowNotification", false];
// missionNamespace setVariable ["SAS_Briefing_Task3D", false];

// --> Uncomment for development testing
// missionNamespace setVariable ["SAS_Debug_global", true];
// missionNamespace setVariable ["SAS_Dev_mode", true];


// Disable auto reporting
enableSentences false; 

// -------------------------------------------------------------------------
// Some helper things for testing

// Add action t switch day/light
laptop_1 addAction ["Switch day/night", {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	private _now = date;

	private _isNight = [] call SAS_fnc_isNightTime;

	if (_isNight) then {
		_now set [3, 12];
	} else {
		_now set [3, 23];
	};

	[_now] remoteExec ["setDate"];
}, [],1.5,true, true, "", "true", 5];

// Add action to parachute
laptop_1 addAction ["Parachute", {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	[_caller, getPos _caller, 2000, true, true, true] call SAS_fnc_doHalo;
},[],1.5,true, true, "", "true", 5];

// -------------------------------------------------------------------------

/*
	BRIEFING Section
	Usage:
		To create briefing tasks, use:
		[
			["task1", "Task Title", "Task Description", "Task Type", taskOwner],
			["task2", "Task Title 2", "Task Description 2", "Task Type 2", taskOwner2]
		] spawn SAS_Briefing_fnc_createTasks;

		Task types: "Attack", "Defend", "Move", "Destroy", "Capture", "Pickup", "Recon" (default: "Move")

		To create briefing sections, use:
		[
			["Section Title 1", "Section Content 1"],
			["Section Title 2", "Section Content 2"]
		] spawn SAS_Briefing_fnc_createBriefing;

*/
// SAS Example tasks
[
	["task1", "Test reinforcements", "Lorem ipsum dolor sit amet.", "Attack", "mrk_reinforcements_1"],
	["task2", "Destroy that", "Lorem ipsum dolor sit amet.", "Destroy", tl_opfor_1]
] spawn SAS_Briefing_fnc_createTasks;

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
] spawn SAS_Briefing_fnc_createNotes;

// -------------------------------------------------------------------------

/*
  	Reinforcemets Example
	Simple system when units can call each other if they are in contact and losing.

  	To register group to reinforcements system, use:
	[group unit_1, true, false] call SAS_Reinforcement_fnc_registerGroup;

	where:
	0: OBJECT or GROUP - Group leader or group
    1: BOOL - Can call reinforcements
    2: BOOL - Can be called as reinforcement

  
  	Note: Groups should be created and set up in the editor, then passed as arrays of their members to the function. Delays are counted from mission start.
*/

// Example: Registering a group as reinforcement caller (can call reinforcements, but not be called as reinforcement)
[group tl_opfor_1, true, false] call SAS_Reinforcement_fnc_registerGroup;

// Example: Registering a group as reinforcement (can be called as reinforcement, but not call reinforcements)
[group tl_opfor_2, false, true] call SAS_Reinforcement_fnc_registerGroup;

// Example: Registering a group as both reinforcement caller and reinforcement (can call reinforcements and be called as reinforcement)
[group tl_opfor_3, true, true] call SAS_Reinforcement_fnc_registerGroup;

// -------------------------------------------------------------------------

/*
	Night Ops Example
	Set of simple scripts to enhance night time gameplay, 
	including: 
	- turning on/off lights 
	- equipping units with flashlights and flares.
*/

/*
	Flashlights and flares example

	To equip a group with flares use:
	[group] call SAS_NightOps_fnc_useFlares;

	To equip a group with flashlights use:
	[group, true] call SAS_NightOps_fnc_useFlashlights;

	where:
	0: Group - The group to equip with flares/flashlights
	1: (Optional) Boolean - Whether to force flashlights on, if false AI can decide on its own (default: false)
*/

[group tl_opfor_4] call SAS_NightOps_fnc_useFlares;
[group tl_opfor_4] call SAS_NightOps_fnc_useFlashlights;

/*
	Light switch example:

	To switch ligh on light source object directly 
	(for example construction lights that can be added in editor) use:
	[object, "ON"] call SAS_NightOps_fnc_switchLight;

	where:
	0: OBJECT - The light object to switch
	1: (Optional) STRING - "ON" or "OFF" (if not provided will toggle current state)

	To switch all lights in area use:
	[position, radius] call SAS_NightOps_fnc_switchLightsInArea;

	where:
	0: ARRAY - Position in format [x, y, z] (center of area)
	1: NUMBER - Radius (meters) around the position to affect (optional: default 50)
	2: STRING - "ON" or "OFF" (optional, if not provided will toggle current state)
*/

// Example: Allow player to manually switch lights
{
	_x addAction ["Toggle light", {
		params ["_target", "_caller", "_actionId", "_arguments"];
		[_target] call SAS_NightOps_fnc_switchLight;
	}];
} foreach [lamp_1, lamp_2];

// Example: Switch all lights in area on at mission start
[[1000, 1000, 0], 50] call SAS_NightOps_fnc_switchLightsInArea;

/*
	Example: Set given object as "power source" for nearby lights, 
	allowing player to toggle them on/off and automatically turning them off 
	if the object is destroyed.

	To set a light control object use:
	_lightControl, _radius, _turnOffDamage] call SAS_NightOps_fnc_setAsLightsPowerSource;

	where:
	0: Object - _lightControl: The object that controls nearby lights 
	1: (Optional) Number - _radius: Radius (meters) to affect nearby lights (default: 50)
	2: (Optional) Number - _turnOffDamage: Damage threshold to auto-turn-off nearby lights (0 disables this functionality, default: 0.5)
	3: (Optional) String - _text: Action text displayed to the player (default: "Toggle power on/off")

	After taking this much damage, object is considered as destroyed and al lighs in are aare off (default: 0.5)
*/
[light_control, 60, 0.2, "Toggle power on/off"] call SAS_NightOps_fnc_setAsLightsPowerSource;

// -------------------------------------------------------------------------
/*
	Hostile Zone Example
	Simple system to make civilians hostile.

	To make civilian hostile use:
	[civ_1, side player, "SHOTGUN"] call SAS_Civilians_fnc_makeHstile;

	where:
	0: OBJECT/GROUP - Civilian Unit or group to make hostile
	1: (Optional) SIDE - Side that will be used to determine hostility. For example WEST will assign the civilian to be hostile towards WEST (default: WEST)
	2: (Optional) STRING - One of: PISTOL, SMG, SHOTGUN, RIFLE or exact class. (default: random)

	To create a hostile zone, use:
	[position, radius] call SAS_Civilians_fnc_createHostileZone;

	where:
	0: POSITION - Center position (array)
	1: NUMBER - Radius in metres (default: 50)
	2: NUMBER - Percentage (0-1) of civilians in the area to make hostile (default: 0.5)

	The function returns the created trigger object, which can be deleted to stop monitoring the area.
*/

// Example: Create civilians hostile zone
[getMarkerPos "mrk_hostile_1", 10, 0.5] call SAS_Civilians_fnc_createHostileZone;


/*
	AI Conversation
	Simple system create conversations with ai.

	To create conversation use:
	["Sgt. Harris", targetObject, "Message text",
		[
			["Answer 1", { hint "Answer 1 selected"; }],
			["Answer 2", { hint "Answer 2 selected"; }]
		]
	] call SAS_Conv_fnc_messageDialog;

	where:
	0: STRING - Name of the AI character
	1: OBJECT - Target object for the conversation
	2: STRING - Message text
	3: ARRAY - Array of answers, each answer is an array with text and code to execute when the answer is selected.		
*/
//Example Conversation
civ_1 addAction ["Talk With", {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	["Sgt. Harris", _target, "How are you?",
		[
			["Fine!", { hint "Answer FINE selected"; ["task1"] call SAS_Briefing_fnc_completeTask; }],
			["Not so good...", { hint "Answer NOT SO GOOD selected"; ["task2"] call SAS_Briefing_fnc_failTask; }]
		]
	] call SAS_Conv_fnc_messageDialog;
},[],1.5,true, true, "", "true", 5];

/*
	AI Tasks Example
	Simple system to make AI patrol or defend area

	To assign a patrol task to a group, use:
	[group, position, distance, blacklist] call SAS_Task_fnc_patrol;

	where:
	0: Group - the group to patrol
	1: Position - the position on which to base the patrol
	2: Number - maximum distance between waypoints in meters
	3: (Optional) Array - blacklist of areas (default: [])

	To assign a defend task to a group, use:
	[group, position, radius, garrisonBuildings, doPatrol] call SAS_Task_fnc_defend;

	where:
	0: Group - the group to defend the position
	1: Position - the position to defend (Array)
	2: (Optional) Number - radius to search for statics/buildings (default: 100)
	3: (Optional) Boolean - garrison nearby buildings (default: true)
	4: (Optional) Boolean - enable patrol behavior (default: false)

	If SAS_Debug_global is true, creates map markers for each generated waypoint and outputs debug information via SAS_fnc_logDebug.
*/

// Example Garrison
[group tl_blufor_1, getPos tl_blufor_1, 60, true, true] call SAS_Task_fnc_defend;

// Example Patrol
[group tl_blufor_2, getPos tl_blufor_2, 100] call SAS_Task_fnc_patrol;





