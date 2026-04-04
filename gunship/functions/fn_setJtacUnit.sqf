params [["_jtacUnit", objNull]];

if (isNull _jtacUnit) exitWith {};
if (!isPlayer _jtacUnit) exitWith {};

missionNamespace setVariable ["SAS_Gunship_jtac_unit", _jtacUnit, true];

_jtacUnit addEventHandler ["Killed", {
	params ["_unit", "_killer"];
	[] remoteExec ["SAS_Gunship_fnc_rtb", 2];
}];