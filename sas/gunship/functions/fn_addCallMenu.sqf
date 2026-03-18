params [["_unit", player], ["_showHint", true]];

if (isNull _unit) exitWith {};
if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};
if (!isPlayer _unit) exitWith {};

waitUntil {!isNull player};

private _callsLeft = [] call SAS_Gunship_fnc_getMaxCalls;

if (_callsLeft <= 0) exitWith {};

[] call SAS_Gunship_fnc_generateSubmenus;
private _notificationClass = if (_showHint) then {"CommunicationMenuItemAdded"} else {""};
private _callMenuId = [_unit, "SAS_CAS_Gunship_call", nil, nil, _notificationClass] call BIS_fnc_addCommMenuItem;

_unit setVariable ["SAS_Gunship_menu_call_id", _callMenuId];
