
if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {!isNull player};

private _callMenuId = player getVariable ["SAS_Gunship_menu_command_id", -1];
if (_callMenuId == -1) exitWith { hint "No command menu to remove." };

[player, _callMenuId] call BIS_fnc_removeCommMenuItem;
player setVariable ["SAS_Gunship_menu_command_id", -1];
