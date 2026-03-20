params [["_showHint", true]];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {!isNull player};
waitUntil { time > 0 };

private _callsLeft = [] call SAS_Gunship_fnc_getMaxCalls;

if (_callsLeft <= 0) exitWith {};

[] call SAS_Gunship_fnc_generateSubmenus;
private _notificationClass = if (_showHint) then {"CommunicationMenuItemAdded"} else {""};
private _callMenuId = [player, "SAS_CAS_Gunship_call", nil, nil, _notificationClass] call BIS_fnc_addCommMenuItem;

player setVariable ["SAS_Gunship_menu_call_id", _callMenuId];
