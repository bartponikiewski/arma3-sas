
params [["_jtacUnit", objNull]];

if (isNull _jtacUnit) exitWith {};

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};
if (!isPlayer _jtacUnit) exitWith {};
if (!local _jtacUnit) exitWith {};

[] call SAS_Gunship_fnc_generateSubmenus;
private _callMenuId = [_jtacUnit, "SAS_CAS_Gunship_command", nil, nil, ""] call BIS_fnc_addCommMenuItem;

_jtacUnit setVariable ["SAS_Gunship_menu_command_id", _callMenuId];


