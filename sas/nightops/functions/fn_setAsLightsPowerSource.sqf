/*
    Description:
    Registers a light-control object as a lights power source. Adds an action to toggle
    nearby lights and (optionally) an event handler that turns off lights when the
    control object is damaged beyond a threshold.

    Usage:
    [_lightControl, _radius, _turnOffDamage] call SAS_NightOps_fnc_setAsLightsPowerSource;
    Example:
    [myLampObject, 60, 0.5] call SAS_NightOps_fnc_setAsLightsPowerSource;

    Parameter(s):
    0: Object - _lightControl: The object that controls nearby lights (default: objNull)
    1: (Optional) Number - _radius: Radius (meters) to affect nearby lights (default: 50)
    2: (Optional) Number - _turnOffDamage: Damage threshold to auto-turn-off nearby lights (0 disables this functionality, default: 0.5)
    3: (Optional) String - _text: Action text displayed to the player (default: "Toggle power on/off")

    Returns:
    Nothing. Side-effects: adds action and possibly an event handler on the control object.

    Debug:
    Uses namespaced variables `SAS_NightOps_lightControlRadius` and `SAS_NightOps_lightControltTurnOffDamage`.
*/

params [
	["_lightControl", objNull],
	["_radius", 50],
	["_turnOffDamage", 0.5],
    ["_text", "Toggle power on/off"]
];

if (!local _lightControl) exitWith {};

// Add event handler to turn off nearby lights if the light control object is destroyed
_lightControl setVariable ["SAS_NightOps_lightControlRadius", _radius, true];
_lightControl setVariable ["SAS_NightOps_lightControltTurnOffDamage", _turnOffDamage, true];

// Add action to toggle power on/off for a specific light control object
[_lightControl, _radius, _text] remoteExec ["SAS_NightOps_fnc_addPowerSourceAction", 0, true];

if (_turnOffDamage == 0) exitWith {};

_lightControl addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitPartIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
	if (!local _unit) exitWith {};


	private _turnOffDamage = _unit getVariable ["SAS_NightOps_lightControltTurnOffDamage", 0.5];

	if (_damage > _turnOffDamage) then {
        _unit removeEventHandler [_thisEvent, _thisEventHandler];
        [_unit] remoteExec ["SAS_NightOps_fnc_removePowerSourceAction", 0];

        private _radius = _unit getVariable ["SAS_NightOps_lightControlRadius", 50];
        [getPos _unit, _radius, "OFF"] call SAS_NightOps_fnc_switchLightsInArea;
	};
}];