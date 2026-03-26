/*
	Escorts an arrested captive. Attaches the unit in front of the player,
	forces walk speed, and starts a monitor loop for auto-release.

	Usage:
	[_target, _caller] call SAS_Captive_fnc_escort;

	Parameters:
	0: Object - _target: The arrested unit to escort
	1: Object - _caller: The player escorting the unit
*/
params ["_target", "_caller"];

// Guard against race condition — another player may have started escort simultaneously
if ((_target getVariable ["SAS_Captive_state", ""]) != "ARRESTED") exitWith {};

// Guard: caller is already escorting someone
if (!isNull (_caller getVariable ["SAS_Captive_escortingUnit", objNull])) exitWith {};

// Guard: someone else is already escorting this target
if (!isNull (_target getVariable ["SAS_Captive_escortedBy", objNull])) exitWith {};

// Set state
[_target, "ESCORTED", _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];
_caller setVariable ["SAS_Captive_escortingUnit", _target];

// Disable collision
[_target, _caller] remoteExecCall ["disableCollisionWith", 0];

// Attach in front of player
_target attachTo [_caller, [0.5, 1.2, 0]];
[_target, 0] remoteExec ["setDir", 0];

// Lock to walk
_caller forceWalk true;

// Add "Stop Escort" action on the target
private _stopActionId = _target addAction [
	"<t color='#FFAF00'>Stop Escort</t>",
	{
		params ["_target", "_caller"];
		[_target, _caller] call SAS_Captive_fnc_stopEscort;
	},
	[],
	6,
	true,
	false,
	"",
	"_this == (_target getVariable ['SAS_Captive_escortedBy', objNull])",
	3
];

_target setVariable ["SAS_Captive_stopEscortActionId", _stopActionId];

// Add "Load into Vehicle" hold action on the player (self-action)
private _loadActionId = [
	_caller,
	"Load Captive into Vehicle",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loadVehicle_ca.paa",
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_loadVehicle_ca.paa",
	"(cursorTarget isKindOf 'LandVehicle' || cursorTarget isKindOf 'Air' || cursorTarget isKindOf 'Ship') && cursorTarget emptyPositions 'cargo' > 0 && cursorTarget distance (_this getVariable ['SAS_Captive_escortingUnit', objNull]) < 5",
	"true",
	{},
	{},
	{
		params ["_target", "_caller", "_actionId", "_arguments"];
		private _captive = _arguments select 0;
		[_captive, _target] call SAS_Captive_fnc_loadInVehicle;
	},
	{},
	[_target],
	3,
	nil,
	true,
	false
] call BIS_fnc_holdActionAdd;

_caller setVariable ["SAS_Captive_loadActionId", _loadActionId];

// Monitor loop — auto-stop escort on incap, death
[_target, _stopActionId, _loadActionId, _caller] spawn {
	params ["_target", "_stopActionId", "_loadActionId", "_caller"];

	// Wait for the ESCORTED state to propagate from the server before monitoring.
	// Without this, the loop exits immediately in multiplayer because the broadcast
	// hasn't arrived yet and the local state is still "ARRESTED".
	waitUntil {
		(_target getVariable ["SAS_Captive_state", ""]) == "ESCORTED"
		|| !alive _target
		|| !alive _caller
	};

	while {
		alive _caller
		&& lifeState _caller != "INCAPACITATED"
		&& alive _target
		&& vehicle _caller == _caller
		&& (_target getVariable ["SAS_Captive_state", ""]) == "ESCORTED"
	} do {
		sleep 1;
	};

	// Always clean up escort player state — the loop exited because something changed
	_target removeAction _stopActionId;
	[_caller, _loadActionId] call BIS_fnc_holdActionRemove;
	_caller forceWalk false;

	// Only transition back to ARRESTED if captive is still alive and escorted
	private _currentState = _target getVariable ["SAS_Captive_state", ""];
	if (alive _target && _currentState == "ESCORTED") then {
		[_target, _caller] call SAS_Captive_fnc_stopEscort;
	} else {
		// Captive died or state changed externally — just clean up references
		[_target, _caller] remoteExecCall ["enableCollisionWith", 0];
		_target setVariable ["SAS_Captive_escortedBy", objNull, true];
		_caller setVariable ["SAS_Captive_escortingUnit", objNull];
	};
};
