params [["_maxCalls", 5]];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

[_maxCalls] call SAS_Gunship_fnc_setMaxCalls;

remoteExec ["SAS_Gunship_fnc_addCallMenu", 0, true];
