/*
  Create ropes for fast roping from a helicopter.
   The function checks the helicopter type and creates ropes at the appropriate positions, 
   then animates the crew out of the helicopter. The ropes are destroyed after 10 seconds.

  Usage:
  [_heli] spawn SAS_Fastrope_fnc_createRopes;

  Parameter(s):
  0: OBJECT - Helicopter to fast rope from

  Returns:
  ropes array
*/

params [["_heli", objNull]];

// Check params
if (isNull _heli) exitWith {
	["Error: No helicopter provided to fn_createRopes."] call SAS_fnc_logDebug;
};
if (!local _heli) exitWith {
	["Error: Helicopter provided to fn_createRopes is not local."] call SAS_fnc_logDebug;
};
if (!alive _heli) exitWith {
	["Error: Helicopter provided to fn_createRopes is not alive."] call SAS_fnc_logDebug;
};

// Get heli config
private _heliConfig = [_heli] call SAS_Fastrope_fnc_getHeliConfig;
_heliConfig params ["_heliRopesPositions", "_heliDoors", "_existingRopes"];

// Exit if ropes exists
if (count _existingRopes > 0) exitWith {
	["Error: Maximum number of ropes already created for this helicopter."] call SAS_fnc_logDebug;
};



// Open doors
{
	_heli animateDoor [_x, 1];
} forEach _heliDoors;

// Create ropes and store them in an array variable on the helicopter
private _ropeLength = ((getPos _heli) select 2) + 5;
private _ropes = [];
{
	private _ropePos = _x;
	private _rope = ropeCreate [_heli, _ropePos, _ropeLength];
	_ropes pushBack _rope;
} forEach _heliRopesPositions;


// Store ropes in variable on the helicopter
_heli setVariable ["SAS_Fastrope_attachedRopes", _ropes, true];

_ropes;