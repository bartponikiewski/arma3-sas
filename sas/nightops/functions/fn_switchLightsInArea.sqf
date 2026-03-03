/*
	Description:
	Switches all lights in a given area on or off, useful for night operations and stealth scenarios.

	Usage:
	[position, radius, state] call SAS_nightops_fnc_switchLightsInArea;

	Parameter(s):
	0: ARRAY - Position in format [x, y, z] (center of area)
	1: NUMBER - Radius (meters) around the position to affect (optional: default 50)
	2: STRING - "ON" or "OFF" (optional, if not provided will toggle current state)

	Returns:
	ARRAY - List of affected light objects

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/
params ["_pos", ["_radius", 50], "_toState"];


private _lamps = nearestObjects [player, ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F"], _radius];

{
	for "_i" from 0 to (count getAllHitPointsDamage _x -1) do
	{
		[_x, _toState] call SAS_NightOps_fnc_switchLight;
	};
} forEach _lamps;
