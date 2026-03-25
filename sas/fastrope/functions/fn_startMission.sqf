/*
  Helicopter fast-rope transport script

  Usage:
 [heli_1, getPos heli_1, getPos heli_1, false] spawn SAS_Fastrope_fnc_startMission; 


  Parameter(s):
  0: OBJECT - Helicopter to use for fast rope transport
  1: ARRAY - Position to drop troops at (e.g., marker position)
  2: ARRAY - Position for helicopter to return to after fast rope operation
  3: BOOL - Whether to delete the helicopter at the end of the mission
*/

params ["_heli","_dropPos","_returnPos", ["_deleteAtEnd", false]];

// Check params
if (isNull _heli) exitWith {
	["Error: No helicopter provided to fn_createRopes."] call SAS_fnc_logDebug;
};

if(!local _heli) exitWith {
  ["Error: Helicopter provided to fn_createRopes is not local."] call SAS_fnc_logDebug;
};

private _grp = group _heli;


/* --- start helicopter --- */
_heli engineOn true;
_heli setSpeedMode "FULL";
_heli setBehaviour "CARELESS";

/* --- fly to drop zone --- */
_heli doMove _dropPos;

waitUntil {
	sleep 1;
	(_heli distance2D _dropPos < 200)
};

/* --- slow down and hover --- */
_heli flyInHeight 45;
_heli setSpeedMode "LIMITED";

waitUntil {
	sleep 3;
	[_heli, 50, 40, 5] call SAS_Fastrope_fnc_isHeliReady;
};

/* stabilize hover */
_heli disableAI "PATH";
_heli disableAi "MOVE";
doStop _heli;
_heli stop true;

_heli setVelocity [0,0,0];

/* --- fast rope --- */
[_heli] call SAS_Fastrope_fnc_createRopes;
sleep 2;
[_heli] call SAS_Fastrope_fnc_dropCrew;
sleep 2;
[_heli] call SAS_Fastrope_fnc_cutRopes;

/* --- restore flight --- */
_heli enableAI "MOVE";
_heli enableAI "PATH";
_heli setSpeedMode "FULL";
_heli doFollow (leader group _heli);
_heli stop false;




/* --- return to base --- */
_heli doMove _returnPos;
_heli flyInHeight 100;

waitUntil {
	sleep 2;
	(_heli distance2D _returnPos < 60)
};


if (_deleteAtEnd) then {
  // Delete heli
  deleteVehicleCrew _heli;
  deleteVehicle _heli;
} else {
  _heli land "LAND";
};