
/*
	Description:
	Adds an action to a hostage that allows the player to free them.

	Usage:
	[_hostage] call SAS_Hostage_fnc_addFreeHostageAction;

	Parameters:
	0: Object - _hostage: hostage unit to which the action will be added

	Returns:
	None. The function adds an action to the specified object.

	Debug:
	Use the centralized logging function for debug output: ["message"] call SAS_fnc_logDebug;
	Requires SAS_NightOps_fnc_switchLightsInArea to be registered and available.
*/
params ["_hostage"];

if (isDedicated) exitWith {};
if (isNull _hostage) exitWith {};

private _actionId = [
	_hostage,
	"Free Hostage",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa",
	"_this distance _target < 5",
	"_caller distance _target < 5",
	{},
	{},
	{
		params ["_target", "_caller"];
		[_target, "RELEASED", _caller] remoteExec ["SAS_Hostage_fnc_setHostageState", 0];
	},
	{},
	[],
	5,
	nil,
	true,
	false
] call BIS_fnc_holdActionAdd;

/* 
  Since we are probably in player local scope, we can store the action ID in a variable on the object for 
  later reference (e.g., to remove the action when the object is destroyed). But CANNOT be broadcasted 
  to other clients since action IDs are local to each machine, so we don't set it as a network-synced variable.
*/
_hostage setVariable ["SAS_Hostage_freeActionId", _actionId];


