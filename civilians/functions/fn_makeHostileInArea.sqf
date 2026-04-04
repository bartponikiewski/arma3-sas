/*
	Script for making a percentage of civilians in a given area hostile to the player. 
	Can be used for dynamic encounters or to add some variability to patrols/convoys.

	Usage:
	[position, radius, percent] call SAS_civilians_fnc_makeHostileInArea;

	Parameter(s):
	0: AREA:
		Object - trigger
		Location - location
		String - marker name
	1: (Optional) NUMBER - Percentage (0-1) of civilians in the area to make hostile (default: 0.5)
	2: (Optional) NUMBER - Delay in seconds between making each civilian hostile (default: random from 0 to 5 seconds)

*/

params ["_area", ["_percent", 0.5], ["_delay", -1]];

private _civilians = (allUnits select {side _x == civilian && alive _x}) inAreaArray _area;
private _civiliansCount = count _civilians; 
private _numToMakeHostile = floor _civiliansCount * _percent;

for '_i' from 0 to _numToMakeHostile - 1 do {
	private _civilian = _civilians select _i;
	[group _civilian] spawn SAS_Civilians_fnc_makeHostile;
	if (_delay < 0) then { _delay = random 5; };
	sleep _delay;
};