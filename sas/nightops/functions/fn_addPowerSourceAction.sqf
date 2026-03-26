
/*
	Description:
	Adds an action to a light control object that toggles power for lights
	within a specified radius.

	Usage:
	[_lightControl, _radius, _text] call SAS_NightOps_fnc_addPowerSourceAction;

	Parameters:
	0: Object - _lightControl: object to which the action will be added (e.g., lamp or switch)
	1: (Optional) Number - _radius: radius in meters for lights affected when toggling (default: 50)
	2: (Optional) String - _text: action text displayed to the player (default: "Toggle power on/off")

	Returns:
	None. The function adds an action to the specified object.

	Debug:
	Use the centralized logging function for debug output: ["message"] call SAS_fnc_logDebug;
	Requires SAS_NightOps_fnc_switchLightsInArea to be registered and available.
*/
params ["_lightControl", ["_radius", 50], ["_text", "Toggle power on/off"]];

if (isDedicated) exitWith {};
if (isNull _lightControl) exitWith {};

private _turnOffDamage = _lightControl getVariable ["SAS_NightOps_lightControltTurnOffDamage", 0.5];

// Don't add action if the object is already damaged beyond the threshold (e.g., when repairing and re-adding action to an existing object)
if (damage _lightControl > _turnOffDamage) exitWith {
	["[SAS_NightOps_fnc_setAsLightsPowerSource]: Light control object is already damaged beyond the threshold, not adding action"] call SAS_fnc_logDebug;
	
}; 

private _actionId = [
	_lightControl,
	_text,
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_off_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_off_ca.paa",
	"_this distance _target < 5",
	"_caller distance _target < 5",
	{},
	{},
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		_arguments params ["_radius"];
		[getPos _target, _radius] call SAS_NightOps_fnc_switchLightsInArea;
	},
	{},
	[_radius],
	3,
	nil,
	false,
	false
] call BIS_fnc_holdActionAdd;

/* 
  Since we are probably in player local scope, we can store the action ID in a variable on the object for 
  later reference (e.g., to remove the action when the object is destroyed). But CANNOT be broadcasted 
  to other clients since action IDs are local to each machine, so we don't set it as a network-synced variable.
*/
_lightControl setVariable ["SAS_NightOps_lightControlActionId", _actionId];


