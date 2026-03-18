if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {!isNull player};

private _hasCallMenu = player getVariable ["SAS_Gunship_menu_call_id", -1] != -1;
private _hasCommandMenu = player getVariable ["SAS_Gunship_menu_command_id", -1] != -1;
private _jtacUnit = [] call SAS_Gunship_fnc_getJtacUnit;

[] call SAS_Gunship_fnc_generateSubmenus;

// If the player is the JTAC and doesn't have the command menu, add it. This can happen if the player calls in a gunship on themselves, then takes over as JTAC.
if (player == _jtacUnit && !_hasCommandMenu) exitWith {
	[] call SAS_Gunship_fnc_addCommandMenu;
};

// If player has call menu, refresh it
if (_hasCallMenu) then {
	[] call SAS_Gunship_fnc_removeCallMenu;
	[false] call SAS_Gunship_fnc_addCallMenu;
};

// If player has command menu, refresh it.
if (_hasCommandMenu) then {
	[] call SAS_Gunship_fnc_removeCommandMenu;
	[] call SAS_Gunship_fnc_addCommandMenu;
};

// If player doesn't have either menu, add the call menu, add call menu
if (!_hasCallMenu && !_hasCommandMenu) then {
	[] call SAS_Gunship_fnc_addCallMenu;
};