/*
	Description:
	Starts a gunship mission, checks call limits, manages menu, and triggers gunship attack on position.

	Usage:
	[attackPos, mode, jtacUnit] call SAS_Gunship_fnc_startMission;

	Parameter(s):
	0: Position - Target position for gunship attack
	1: String (Optional) - Gunship mode (default: "AUTO")
	2: Object (Optional) - JTAC unit (default: player)

	Returns:
	Nothing

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/
params ["_attackPos", ["_mode", "AUTO"], ["_jtacUnit", player]];

if (!hasInterface) exitWith {};
if (isDedicated) exitWith {};

waitUntil {!isNull player};

// Check if max calls has been reached
private _maxCalls = [] call SAS_Gunship_fnc_getMaxCalls;

if (_maxCalls <= 0) exitWith {
	[] call SAS_Gunship_fnc_removeCallMenu;
	hint "No more gunship calls available.";
};

// Check if gunship already operating
private _gunship = [] call SAS_Gunship_fnc_getGunshipUnit;
if (!isNull _gunship) exitWith {
	hint "Gunship is already operating. Wait until it's back to call another one.";
};

// Decrease max callExtensions by 1
private _newMaxCalls = _maxCalls - 1;
[_newMaxCalls] call SAS_Gunship_fnc_setMaxCalls;

if (_newMaxCalls <= 0) then {
	[] remoteExec ["SAS_Gunship_fnc_removeCallMenu", 0];
} else {
	[] call SAS_Gunship_fnc_removeCallMenu;
};


// Call on position on server
[_attackPos, _jtacUnit, _mode] remoteExec ["SAS_Gunship_fnc_callOnPosition", 2];







