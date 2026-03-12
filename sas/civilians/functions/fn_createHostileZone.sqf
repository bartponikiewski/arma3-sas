/*
	Description:
	Creates a trigger-like zone that, when entered by players, selects random civilian units
	inside the zone and makes them hostile by calling SAS_Civilians_fnc_makeHostile.

	Usage:
	[position, radius] call SAS_civilians_fnc_createHostileZone;

	Parameter(s):
	0: POSITION - Center position (array)
	1: NUMBER - Radius in metres (default: 50)
	2: NUMBER - Percentage (0-1) of civilians in the area to make hostile (default: 0.5)

	Returns:
	OBJECT - The created trigger object (can be deleted to stop monitoring)
*/

params [
	["_pos", [], [[]]],
	["_radius", 50],
	["_percent", 0.5]
];

// Resolve center position
if (count _pos < 2) exitWith {
	["[SAS_Civilians_fnc_createHostileZone]: Invalid position parameter"] call SAS_fnc_logDebug;
}; // invalid position

if (!isServer) exitWith {
	["[SAS_Civilians_fnc_createHostileZone]: Skipped (not server)"] call SAS_fnc_logDebug;
};

// Create a visible trigger object for reference. We'll monitor it via a spawned script.
private _trigger = createTrigger ["EmptyDetector", _pos];
_trigger setTriggerArea [_radius, _radius, 0, false];
_trigger setTriggerTimeout [0, 0];
_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", false];
_trigger setVariable ["SAS_Civilians_HostileZonePercent", _percent, true];
_trigger setTriggerStatements
[
	"this",
	"
	private _percent = thisTrigger getVariable ['SAS_Civilians_HostileZonePercent', 0.5];
	[thisTrigger, _percent] spawn SAS_Civilians_fnc_makeHostileInArea;
	",
	""
];

hint format["%1", _trigger];



private _debugGlobal = missionNamespace getVariable ["SAS_Debug_global", false];
if (_debugGlobal) then {
	private _triggerPos = getPos _trigger;
	private _marker = createMarker [format ["sas_hostile_zone_%1_%2", random 100, random 100], _triggerPos];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "mil_dot";
	_marker setMarkerColor "ColorYellow";
	_marker setMarkerText format ["HostileZone"];
};

_trigger

