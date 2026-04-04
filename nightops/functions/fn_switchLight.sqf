/*
	Description:
	Switches a single light object on or off.

	Usage:
	[lightObject, state] call SAS_nightops_fnc_switchLight;

	Parameter(s):
	0: OBJECT - The light object to switch
	1: STRING - "ON" or "OFF"
	2: STRING - "ON" or "OFF" (optional, if not provided will toggle current state)

	Returns:
	BOOL - true if the operation succeeded, false otherwise

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/
params ["_light", "_toState"];

if (isNull _light) exitWith {};
if (isNil "_toState") then {
	private _currentState = _light getVariable ["SAS_NightOps_LightState", "AUTO"];

	switch (_currentState) do
	{
		case "ON": { _toState = "OFF"; };
		case "OFF": { _toState = "ON"; };
		case "AUTO": {
			private _isNight = [] call SAS_fnc_isNightTime;
			_toState = if (_isNight) then {"OFF"} else {"ON"};
		};
	};
};

switch (_toState) do {
    case "ON": {
		_light setVariable ["SAS_NightOps_LightState", "ON", true];
		[_light, "ON"] remoteExec ["switchLight", 0, true];
    };
    case "OFF": {
		_light setVariable ["SAS_NightOps_LightState", "OFF", true];
		[_light, "OFF"] remoteExec ["switchLight", 0, true];
    };
};

true;