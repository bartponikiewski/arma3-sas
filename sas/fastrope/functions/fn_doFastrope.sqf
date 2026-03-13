params [["_unit", objNull], ["_rope", objNull]];

if (isNull _unit) exitWith {
	["Error: No unit provided to fn_doFastrope."] call SAS_fnc_logDebug;
};

if (!alive _unit) exitWith {
	["Error: Unit provided to fn_doFastrope is not alive."] call SAS_fnc_logDebug;
};

private _heli = objectParent  _unit;
if (isNull _heli) exitWith {
	["Error: No helicopter found for unit provided to fn_doFastrope."] call SAS_fnc_logDebug;
};

private _attachedRopes = _heli getVariable ["SAS_Fastrope_attachedRopes", []];
if (count _attachedRopes == 0) exitWith {
	["Error: No ropes attached to helicopter for fn_doFastrope."] call SAS_fnc_logDebug;
};

if (isNull _rope) then {
	_rope = selectRandom _attachedRopes;
};

private _ropePos = ropeEndPosition _rope;
private _ropeStartPos = _ropePos select 0;
private _ropeEndPos = _ropePos select 1;

private _startOfRopeZ = _ropeStartPos select 2;
private _endOfRopeZ = _ropeEndPos select 2;

_unit allowDamage false;
unassignVehicle _unit;
[_unit] allowGetIn false;
moveOut _unit;
_unit setPos [(_ropeStartPos select 0),(_ropeStartPos select 1),(_ropeStartPos select 2)-2];
_unit switchMove "LadderRifleStatic";
_unit playMove "LadderRifleStatic";

[_unit, "LadderRifleStatic"] remoteExec ["switchMove"];
[_unit, "LadderRifleStatic"] remoteExec ["playMove"];


private _descentRate = 1;   // metres per tick (lower = slower)
private _tickRate    = 0.2;  // seconds per tick (lower = smoother)

private _roping = true;
while {_roping} do {
	private _currentPos = getPosATL _unit;
	private _currentAlt = _currentPos select 2;
	private _newAlt = _currentAlt - _descentRate;

	// Clamp so we don't overshoot the rope end
    if (_newAlt <= (_endOfRopeZ + 0.5) || ((getPos _unit) select 2) <= 0.5) then {
        _newAlt  = _endOfRopeZ + 0.5;
        _roping  = false;
    };

	_unit setPos [_currentPos select 0, _currentPos select 1, _newAlt];	
	sleep _tickRate;
};

_unit setVelocity [0,0,0];

[_unit, "LadderRifleDownOff"] remoteExec ["playMove"];
[_unit, ""] remoteExec ["switchMove"];
_unit allowDamage true;
[_unit] allowGetIn true;









