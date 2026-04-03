params [["_showHint", true]];

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {!isNull player};

private _callsLeft = [] call SAS_Gunship_fnc_getMaxCalls;
private _jtacUnits = [] call SAS_Gunship_fnc_getJtacUnits;

waitUntil {
	 _jtacUnits = [] call SAS_Gunship_fnc_getJtacUnits;
	 count _jtacUnits > 0
};

if (_callsLeft <= 0) exitWith {};

if !(player in _jtacUnits) exitWith {
	["Player is not a registered JTAC unit. Gunship call menu will not be added."] call SAS_fnc_logDebug;
};

[] call SAS_Gunship_fnc_generateSubmenus;
private _notificationClass = if (_showHint) then {"CommunicationMenuItemAdded"} else {""};
private _callMenuId = [player, "SAS_CAS_Gunship_call", nil, nil, _notificationClass] call BIS_fnc_addCommMenuItem;

player setVariable ["SAS_Gunship_menu_call_id", _callMenuId];
