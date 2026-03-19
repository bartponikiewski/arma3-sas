params [["_jtacUnits", []],["_maxCalls", 5], ["_availableModes", ["LASER", "MANUAL"]]];

if (!isServer) exitWith {};

if (count _jtacUnits <= 0) exitWith {
	["No JTAC units defined. Gunship system will not work without a JTAC unit."] call SAS_fnc_logDebug;
};

missionnamespace setVariable ["SAS_Gunship_allowLaserMode", (if (_availableModes find "LASER" != -1) then {true} else {false}), true];
missionnamespace setVariable ["SAS_Gunship_allowManualMode", (if (_availableModes find "MANUAL" != -1) then {true} else {false}), true];
[_maxCalls] call SAS_Gunship_fnc_setMaxCalls;

remoteExec ["SAS_Gunship_fnc_addCallMenu", _jtacUnits, true];
