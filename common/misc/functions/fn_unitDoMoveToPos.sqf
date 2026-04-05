/*
    Description:
    Moves a unit to a position with approach slowdown. Caches and restores the group's behaviour settings.

    Usage:
    [unit, pos, slowdownDist, arriveDist, nearCallback] call SAS_fnc_doMoveToPos;

    Parameter(s):
    0: OBJECT - Unit to move
    1: ARRAY - Target position [x, y, z]
    2: NUMBER - (Optional) Distance at which unit slows down (default: 50)
    3: NUMBER - (Optional) Distance at which unit is considered arrived (default: 10)
    4: ARRAY - (Optional) [CODE, NUMBER] - Callback and distance at which to trigger it (default: [{}, 20])

    Callback gets passed the following parameters as _this: [_unit, _grp, _pos, _behaviourCache]
        _unit - Unit being moved
        _grp - Group of the unit being moved
        _pos - Target position
        _behaviourCache - Cached behaviour settings of the group, in format [behaviour, combatMode, speedMode]

    Returns:
    BOOL - true if arrived, false if unit died
*/

params [["_unit", objNull], ["_pos", []], ["_slowdownDist", 50], ["_arriveDist", 10], ["_nearCallback", [{}, 20]]];
_nearCallback params ["_callback", "_callbackDist"];

if (isNull _unit) exitWith {};
if (!alive _unit) exitWith { false };
if (isNil "_pos" || count _pos == 0) exitWith { false };
if (_arriveDist < 1) then { _arriveDist = 1 };
if (_arriveDist >= _slowdownDist) then {
    _slowdownDist = _arriveDist + 1;
};



private _grp = group _unit;
private _behaviourCache = [behaviour (leader _grp), combatMode _grp, speedMode _grp];

_grp setBehaviour "CARELESS";
_grp setCombatMode "BLUE";
_grp setSpeedMode "NORMAL";

_unit doMove _pos;

// Slow down when within slowdown distance, or if unit is taking too long (e.g. stuck)
waitUntil { !alive _unit || vehicle _unit distance _pos < _slowdownDist };
if (!alive _unit) exitWith { false };

_grp setSpeedMode "LIMITED";

// Handle callback
waitUntil { !alive _unit || vehicle _unit distance _pos < _callbackDist };
[_unit, _grp, _pos, _behaviourCache] call _callback;


private _startTime = time;
waitUntil {
	!alive _unit ||
	vehicle _unit distance _pos <= _arriveDist
	|| (
		(time - _startTime > ((vehicle _unit distance _pos) - _arriveDist)) &&
		speed (vehicle _unit) < 0.1
	) // Timeout after calculated time to prevent infinite loops
};
if (!alive _unit) exitWith { false };

doStop _unit;
_grp setBehaviour (_behaviourCache select 0);
_grp setCombatMode (_behaviourCache select 1);
_grp setSpeedMode (_behaviourCache select 2);


true
