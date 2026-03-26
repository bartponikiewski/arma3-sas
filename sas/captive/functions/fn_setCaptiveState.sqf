/*
	Handle different states of a captive unit.
	This script is meant to be executed on every machine via remoteExec.

	Usage:
	[_unit, _state, _caller] remoteExec ["SAS_Captive_fnc_setCaptiveState", 0, true];

	Parameters:
	0: Object - _unit: The unit to set the captive state on (default: objNull)
	1: String - _state: The state to set (e.g., "CAPTURABLE", "SURRENDERED", "ARRESTED", "ESCORTED", "IN_VEHICLE", "RELEASED", "NONE")
	2: Object - _caller: The unit that initiated the action (optional)
*/
params [["_unit", objNull], ["_state", ""], ["_caller", objNull]];

if (isNull _unit) exitWith {
	["[SAS_Captive_fnc_setCaptiveState]: Invalid unit"] call SAS_fnc_logDebug;
};

if (!alive _unit) exitWith {
	[format ["[SAS_Captive_fnc_setCaptiveState]: Unit %1 is not alive", _unit]] call SAS_fnc_logDebug;
};

// JIP handling: re-apply visual state only
if (isRemoteExecutedJIP) then {
	_state = _unit getVariable ["SAS_Captive_state", ""];
	if (_state == "") exitWith {};
};

// Set state variable (only on owning machine)
if (local _unit) then {
	_unit setVariable ["SAS_Captive_state", _state, true];
};

switch (_state) do {
	case "CAPTURABLE": {
		// Unit is marked as capturable, add surrender action
		[_unit] call SAS_Captive_fnc_addSurrenderAction;
	};

	case "SURRENDERED": {
		// Remove surrender action
		[_unit] call SAS_Captive_fnc_removeSurrenderAction;

		// Disable movement and drop weapon
		if (local _unit) then {
			_unit disableAI "MOVE";
			// Drop primary weapon if armed
			if (primaryWeapon _unit != "") then {
				_unit action ["DropWeapon", _unit, primaryWeapon _unit];
			};
			_unit setCaptive true;
			[_unit] joinSilent grpNull;
		};

		// Hands up animation
		_unit switchMove "AmovPercMstpSsurWnonDnon";
		_unit playMoveNow "AmovPercMstpSsurWnonDnon";

		// Add arrest action
		[_unit] call SAS_Captive_fnc_addArrestAction;

		// Add killed EH for cleanup (only on owning machine)
		if (local _unit && isNil {_unit getVariable "SAS_Captive_killedEH"}) then {
			private _ehId = _unit addEventHandler ["Killed", {
				params ["_unit"];
				private _state = _unit getVariable ["SAS_Captive_state", ""];

				// Clean up all actions (remoteExec unload removal so clients remove their local actions)
				[_unit] call SAS_Captive_fnc_removeSurrenderAction;
				[_unit] call SAS_Captive_fnc_removeArrestAction;
				[_unit] call SAS_Captive_fnc_removeEscortAction;
				[_unit] remoteExec ["SAS_Captive_fnc_removeUnloadAction", 0];

				// Detach if escorted
				if (_state == "ESCORTED") then {
					detach _unit;
				};

				_unit setVariable ["SAS_Captive_state", "", true];
				_unit removeEventHandler ["Killed", _thisEventHandler];
				_unit setVariable ["SAS_Captive_killedEH", nil];
			}];
			_unit setVariable ["SAS_Captive_killedEH", _ehId];
		};
	};

	case "ARRESTED": {
		// Remove previous actions
		[_unit] call SAS_Captive_fnc_removeArrestAction;
		[_unit] call SAS_Captive_fnc_removeUnloadAction;

		if (local _unit) then {
			// Clear vehicle reference after action removal (so removeUnloadAction can read it)
			_unit setVariable ["SAS_Captive_vehicle", objNull, true];
			_unit disableAI "MOVE";
			_unit setCaptive true;
		};

		// Detach if was escorted
		if (!isNull attachedTo _unit) then {
			detach _unit;
		};

		// Standing hands behind back animation
		_unit switchMove "InBaseMoves_HandsBehindBack1";
		_unit playMoveNow "InBaseMoves_HandsBehindBack1";

		// Add escort and release actions
		[_unit] call SAS_Captive_fnc_addEscortAction;
	};

	case "ESCORTED": {
		// Remove escort action (already being escorted)
		[_unit] call SAS_Captive_fnc_removeEscortAction;

		if (local _unit) then {
			_unit disableAI "MOVE";
			_unit setCaptive true;
			_unit setVariable ["SAS_Captive_escortedBy", _caller, true];
		};

		// Escort mechanic is handled in fn_escort.sqf (attachTo, monitor loop, etc.)
		// This state only sets the variable and cleans actions
	};

	case "IN_VEHICLE": {
		// Remove any existing unload action before adding (guards against JIP duplicates)
		[_unit] call SAS_Captive_fnc_removeUnloadAction;

		if (local _unit) then {
			_unit setCaptive true;
		};

		// Add unload action on the vehicle (runs on all clients via remoteExec)
		if (!isDedicated) then {
			private _vehicle = _unit getVariable ["SAS_Captive_vehicle", objNull];
			if (!isNull _vehicle) then {
				private _unloadActionId = [
					_vehicle,
					"Unload Captive",
					"\a3\data_f_destroyer\data\UI\IGUI\Cfg\holdactions\holdAction_unloadVehicle_ca.paa",
					"\a3\data_f_destroyer\data\UI\IGUI\Cfg\holdactions\holdAction_unloadVehicle_ca.paa",
					format ["_this distance _target < 5 && alive %1 && (%1 getVariable ['SAS_Captive_state', '']) == 'IN_VEHICLE'", _unit],
					"_caller distance _target < 5",
					{},
					{},
					{
						params ["_target", "_caller", "_actionId", "_arguments"];
						private _captive = _arguments select 0;
						[_captive, _caller] call SAS_Captive_fnc_unloadFromVehicle;
					},
					{},
					[_unit],
					3,
					nil,
					true,
					false
				] call BIS_fnc_holdActionAdd;
				_unit setVariable ["SAS_Captive_unloadActionId", _unloadActionId];
			};
		};
	};

	case "RELEASED": {
		// Remove all actions
		[_unit] call SAS_Captive_fnc_removeArrestAction;
		[_unit] call SAS_Captive_fnc_removeEscortAction;
		[_unit] call SAS_Captive_fnc_removeUnloadAction;

		// Detach if escorted
		if (!isNull attachedTo _unit) then {
			detach _unit;
		};

		if (local _unit) then {
			_unit enableAI "MOVE";
			_unit setCaptive true;
			_unit setBehaviour "CARELESS";
			_unit allowFleeing 1;
			unassignVehicle _unit;

			// Leave current group, create own
			private _newGroup = createGroup (side _unit);
			[_unit] joinSilent _newGroup;

			// Remove killed EH
			private _ehId = _unit getVariable ["SAS_Captive_killedEH", -1];
			if (_ehId >= 0) then {
				_unit removeEventHandler ["Killed", _ehId];
				_unit setVariable ["SAS_Captive_killedEH", nil];
			};
		};

		// Stand up animation
		_unit switchMove "AmovPercMstpSnonWnonDnon";
		_unit playMoveNow "AmovPercMstpSnonWnonDnon";

		// Re-add surrender action so unit can be re-captured
		[_unit] call SAS_Captive_fnc_addSurrenderAction;

		// Update state to CAPTURABLE so the action condition works
		if (local _unit) then {
			_unit setVariable ["SAS_Captive_state", "CAPTURABLE", true];
		};
	};

	case "NONE": {
		// Full revert to normal state
		[_unit] call SAS_Captive_fnc_removeSurrenderAction;
		[_unit] call SAS_Captive_fnc_removeArrestAction;
		[_unit] call SAS_Captive_fnc_removeEscortAction;
		[_unit] call SAS_Captive_fnc_removeUnloadAction;

		// Detach if escorted
		if (!isNull attachedTo _unit) then {
			detach _unit;
		};

		if (local _unit) then {
			_unit enableAI "MOVE";
			_unit enableAI "AUTOTARGET";
			_unit enableAI "TARGET";
			_unit enableAI "AUTOCOMBAT";
			_unit setCaptive false;
			_unit setBehaviour "AWARE";

			// Remove killed EH
			private _ehId = _unit getVariable ["SAS_Captive_killedEH", -1];
			if (_ehId >= 0) then {
				_unit removeEventHandler ["Killed", _ehId];
				_unit setVariable ["SAS_Captive_killedEH", nil];
			};
		};

		_unit switchMove "";
	};
};

[missionNamespace, "SAS_Captive_fnc_captiveStateChanged", [_unit, _state, _caller]] call BIS_fnc_callScriptedEventHandler;

