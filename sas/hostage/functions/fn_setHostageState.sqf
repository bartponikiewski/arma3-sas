/*
	Handle different states of hostage.
	This script is meant to be executed on every machine, perfectly by remoteExec.

	Usage:
	[_unit, _state, _caller] remoteExec ["SAS_Hostage_fnc_setHostageState", 0, true];

	Parameters:
	0: Object - _unit: The unit to set the hostage state on (default: objNull)
	1: String - _state: The state to set on the hostage (e.g., "CUFFED", "FREE")
	2: Object - _caller: The unit that initiated the action (optional)
*/
params [["_unit", objNull], ["_state", ""], ["_caller", objNull]];

if (isNull _unit) exitWith {
	[format ["[SAS_Hostage_fnc_setHostageState]: Invalid unit: %1", _unit]] call SAS_fnc_logDebug;
}; // Invalid unit, cannot set hostage state

if (!alive _unit) exitWith {
	[format ["[SAS_Hostage_fnc_setHostageState]: Unit %1 is not alive, cannot set hostage state", _unit]] call SAS_fnc_logDebug;
}; // Unit is not alive, cannot set hostage state


/*
  If this is being called as part of JIP, hanlde anim and add action
  only if hostage is still cuffed. All other states should be handled for JIP anyway
*/
if (isRemoteExecutedJIP) then {
	_state = _unit getVariable ["SAS_Hostage_state", ""]; // Get the current hostage state from the unit variable (if it exists)
	if (_state != "CUFFED") exitWith {
		[format ["[SAS_Hostage_fnc_setHostageState]: JIP unit %1 is not in CUFFED state, current state: %2", _unit, _state]] call SAS_fnc_logDebug;
	}; 
}

if (local _unit) then {
	_unit setVariable ["SAS_Hostage_state", _state, true]; // Set the hostage state variable on the unit, replicated to all machines
}

switch (_state) do {
	case "CUFFED": {
		_unit switchMove "Acts_AidlPsitMstpSsurWnonDnon_loop";
		_unit playMoveNow "Acts_AidlPsitMstpSsurWnonDnon_loop";
		_unit disableAi "MOVE";
		_unit setCaptive true;
		[_unit] joinSilent grpNull;

		[_unit] call SAS_Hostage_fnc_addFreeHostageAction;
	};
	case "RELEASED": {
		_unit switchMove "Acts_AidlPsitMstpSsurWnonDnon_out";
		_unit playMoveNow "Acts_AidlPsitMstpSsurWnonDnon_out";
		_unit enableAi "MOVE";
		_unit disableAI "AUTOTARGET";
		_unit disableAI "TARGET";
		_unit disableAI "AUTOCOMBAT";
		_unit setBehaviour "CARELESS";
		_unit setCombatMode "BLUE";
		_unit allowFleeing 0;
		[_unit] call SAS_Hostage_fnc_removeFreeHostageAction;

		/*
		  When a hostage is released, we want them to join the player's group so they can follow the player if they want. 
		  This is temp solution until we implement proper escorting behavior. 
		  We use joinSilent to avoid any unwanted side effects of joining 
		  a new group (e.g., getting a new group icon, etc.).
		*/
		if (!isNull _caller) then {
			[_unit] joinSilent (group _caller);
		};
	};
};