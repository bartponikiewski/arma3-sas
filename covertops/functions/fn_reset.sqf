/*
	Reset/clear covert ops state on a unit.
	Terminates any monitoring loop, removes all actions, clears all variables,
	and removes the killed event handler.

	Does NOT change setCaptive or remove/add weapons - the caller is
	responsible for the unit's final weapon and captive state.

	Usage:
	[_unit] call SAS_CovertOps_fnc_reset;

	Parameters:
	0: Object - _unit: The unit to reset

	Returns:
	Nothing
*/
params [["_unit", objNull]];

if (isNull _unit) exitWith {
	["[SAS_CovertOps_fnc_reset]: Invalid unit"] call SAS_fnc_logDebug;
};

// Remove actions
private _drawId = _unit getVariable ["SAS_CovertOps_drawActionId", -1];
private _hideId = _unit getVariable ["SAS_CovertOps_hideActionId", -1];
if (_drawId >= 0) then { _unit removeAction _drawId; };
if (_hideId >= 0) then { _unit removeAction _hideId; };

// Remove killed event handler
private _ehId = _unit getVariable ["SAS_CovertOps_killedEH", -1];
if (_ehId >= 0) then {
	_unit removeEventHandler ["Killed", _ehId];
};

// Clear all variables
_unit setVariable ["SAS_CovertOps_active", false, true];
_unit setVariable ["SAS_CovertOps_coverBlown", nil, true];
_unit setVariable ["SAS_CovertOps_weaponClass", nil];
_unit setVariable ["SAS_CovertOps_weaponDrawn", nil];
_unit setVariable ["SAS_CovertOps_drawActionId", nil];
_unit setVariable ["SAS_CovertOps_hideActionId", nil];
_unit setVariable ["SAS_CovertOps_killedEH", nil];

[format ["[SAS_CovertOps_fnc_reset]: Covert ops reset for %1", _unit]] call SAS_fnc_logDebug;
