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
params [["_attackPos", []], ["_mode", "LASER"], ["_jtacUnit", objNull]];

if (count _attackPos < 2) exitWith { hint "Invalid position for gunship attack." };
if (isNull _jtacUnit) exitWith { hint "Invalid JTAC unit for gunship attack." };
if (!isPlayer _jtacUnit) exitWith { hint "JTAC unit is not a player." };
if (!local _jtacUnit) exitWith { hint format ["JTAC unit must be local to %1, %2", _jtacUnit, local _jtacUnit] };

// Check if max calls has been reached
private _maxCalls = [] call SAS_Gunship_fnc_getMaxCalls;
if (_maxCalls <= 0) exitWith {
	remoteExec ["SAS_Gunship_fnc_removeCallMenu", _jtacUnit];
	["No more gunship calls available."] remoteExec ["hint", _jtacUnit];
};

// Check if gunship is available
private _gunshipState = [] call SAS_Gunship_fnc_getGunshipState;
if (_gunshipState != "IDLE") exitWith {
	["Gunship is currently busy. Wait until it's back to call another one."] remoteExec ["hint", _jtacUnit];
};

// Decrease max callExtensions by 1
private _newMaxCalls = _maxCalls - 1;
[_newMaxCalls] call SAS_Gunship_fnc_setMaxCalls;

// If max calls has been reached, remove call menu for everyone
if (_newMaxCalls <= 0) then {
	remoteExec ["SAS_Gunship_fnc_removeCallMenu", 0];
} else {
	remoteExec ["SAS_Gunship_fnc_removeCallMenu", _jtacUnit];
};

// Call on position on server
[_attackPos, _jtacUnit, _mode] remoteExec ["SAS_Gunship_fnc_callOnPosition", 2];







