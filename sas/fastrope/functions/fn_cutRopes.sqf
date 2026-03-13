/*
  Cut ropes from a helicopter for fast roping.

  Usage:
  [_heli] spawn SAS_Fastrope_fnc_cutRopes;

  Parameter(s):
  0: OBJECT - Helicopter to fast rope from

  Returns:
  bool
*/

params [["_heli", objNull]];

// Check params
if (isNull _heli) exitWith {
	["Error: No helicopter provided to fn_cutRopes."] call SAS_fnc_logDebug;
  false;
};

if(!local _heli) exitWith {
  ["Error: Helicopter provided to fn_cutRopes is not local."] call SAS_fnc_logDebug;
  false;
};

// Get heli config
private _heliConfig = [_heli] call SAS_Fastrope_fnc_getHeliConfig;
_heliConfig params ["_heliRopesPositions", "_heliDoors", "_existingRopes"];

if (count _existingRopes == 0) exitWith {
	["Error: No ropes exist for this helicopter."] call SAS_fnc_logDebug;
  false;
};

{
  ropeDestroy _x;
} forEach _existingRopes;

// Clear ropes variable on the helicopter
_heli setVariable ["SAS_Fastrope_attachedRopes", [], true];

// Close doors
{
  _heli animateDoor [_x,0];
} forEach _heliDoors; 

true;