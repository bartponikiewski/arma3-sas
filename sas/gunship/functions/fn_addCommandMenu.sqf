if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {!isNull player};

[] call SAS_Gunship_fnc_generateSubmenus;
private _callMenuId = [player, "SAS_CAS_Gunship_command", nil, nil, ""] call BIS_fnc_addCommMenuItem;

player setVariable ["SAS_Gunship_menu_command_id", _callMenuId];


