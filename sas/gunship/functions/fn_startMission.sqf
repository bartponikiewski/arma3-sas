params ["_attackPos", ["_mode", "AUTO"]];

if (!hasInterface) exitWith {};
if (isDedicated) exitWith {};

waitUntil {!isNull player};

// Check if max calls has been reached
private _maxCalls = [] call SAS_Gunship_fnc_getMaxCalls;

if (_maxCalls <= 0) exitWith {
	[] call SAS_Gunship_fnc_removeCallMenu;
	hint "No more gunship calls available.";
};

// Chek if gunship already operate
private _gunship = [] call SAS_Gunship_fnc_getGunshipUnit;
if (!isNull _gunship) exitWith {
	hint "Gunship is already operating. Wait untill it's back to call another one.";
};

// Decrease max callExtensions by 1
private _newMaxCalls = _maxCalls - 1;
[_newMaxCalls] call SAS_Gunship_fnc_setMaxCalls;


// Call on position for everyone
[_attackPos, player, _mode] remoteExec ["SAS_Gunship_fnc_callOnPosition", 2];
[] call SAS_Gunship_fnc_removeCallMenu;







