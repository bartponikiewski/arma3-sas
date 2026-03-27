/*
	Monitor loop that checks if any enemy unit detects the player while armed.
	Runs every 0.3 seconds. If an enemy has knowsAbout >= 1.5 AND has line of
	sight to the player, cover is permanently blown - the hide action is removed
	and the system resets.

	This function is meant to be spawned, not called directly.

	Usage:
	_handle = [_unit] spawn SAS_CovertOps_fnc_checkDetection;

	Parameters:
	0: Object - _unit: The undercover unit to monitor

	Returns:
	Nothing
*/
params [["_unit", objNull]];

if (isNull _unit) exitWith {
	["[SAS_CovertOps_fnc_checkDetection]: Invalid unit"] call SAS_fnc_logDebug;
};

if (!alive _unit) exitWith {
	[format ["[SAS_CovertOps_fnc_checkDetection]: Unit %1 is not alive", _unit]] call SAS_fnc_logDebug;
};

if (!local _unit) exitWith {
	[format ["[SAS_CovertOps_fnc_checkDetection]: Unit %1 is not local", _unit]] call SAS_fnc_logDebug;
};

[format ["[SAS_CovertOps_fnc_checkDetection]: Starting detection monitor for %1", _unit]] call SAS_fnc_logDebug;

private _coverBlown = _unit getVariable ["SAS_CovertOps_coverBlown", false];
private _playerSide = side (group _unit);
private _nearUnits = _unit nearEntities ["Man", 500];
private _tick = 0;

while {
	alive _unit
	&& (_unit getVariable ["SAS_CovertOps_active", false])
	&& (_unit getVariable ["SAS_CovertOps_weaponDrawn", false])
	&& !_coverBlown
} do {
	{
		if (
			alive _x
			&& {[_playerSide, side (group _x)] call BIS_fnc_sideIsEnemy}
			&& {(_x knowsAbout _unit) >= 1.5}
			&& {[_x, _unit] call SAS_fnc_canSeeTarget}
		) exitWith {
			_coverBlown = true;
			_unit setVariable ["SAS_CovertOps_coverBlown", true, true];

			[_unit] call SAS_CovertOps_fnc_reset;

			hint "An enemy has spotted you! Your cover is blown!";

			[format [
				"[SAS_CovertOps_fnc_checkDetection]: Cover blown! Enemy %1 detected %2 (knowsAbout: %3)",
				_x, _unit, _x knowsAbout _unit
			]] call SAS_fnc_logDebug;
		};
	} forEach _nearUnits;

	if (!_coverBlown) then {
		sleep 0.3;
	};

	// Refresh nearby units every 100 ticks (30 seconds) to account for movement and new spawns
	if (_tick % 100 == 0) then {
		_nearUnits = _unit nearEntities ["Man", 500];
	};

	_tick = _tick + 1;
};

[format ["[SAS_CovertOps_fnc_checkDetection]: Monitor ended for %1, coverBlown=%2", _unit, _coverBlown]] call SAS_fnc_logDebug;
