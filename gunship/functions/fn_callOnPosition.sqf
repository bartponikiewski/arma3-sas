params [["_attackPos", []], ["_jtacUnit", objNull], ["_mode", "LASER"]];

if (count _attackPos < 2) exitWith {};
if (isNull _jtacUnit) exitWith {};
if (!isPlayer _jtacUnit) exitWith {};
if (!alive _jtacUnit) exitWith {};
if (!isServer) exitWith {};

private _orbitRadius = 750;
private _fireZoneRadius = 300;
private _spawnPos = [_attackPos, _orbitRadius + 1500 + (random 500), random 360] call BIS_fnc_relPos;
private _dirTo = [_attackPos, _spawnPos] call BIS_fnc_dirTo;
private _alt = 500;

// Create gunship and send it to attack position
private _createGunshipResult = [_spawnPos, side _jtacUnit] call SAS_Gunship_fnc_createGunship;
_createGunshipResult params ["_gunship", "_weapon"];

// Set gunship mode
[_mode] call SAS_Gunship_fnc_setGunshipMode;

// Set gunship state
["ONMISSION"] call SAS_Gunship_fnc_setGunshipState;

// Set jtac unit that called the gunship
[_jtacUnit] call SAS_Gunship_fnc_setJtacUnit;

//Send gunship to attack position
private _ipPos = [_attackPos, _orbitRadius + 500, _dirTo] call BIS_fnc_relPos;
private _wpIp = [group _gunship,_ipPos,"MOVE","FULL","CARELESS","NO CHANGE",700] call SAS_fnc_addWaypoint;
private _wpLoiter = [group _gunship,_attackPos,"LOITER","LIMITED","CARELESS"] call SAS_fnc_addWaypoint;
_wpLoiter setWaypointLoiterType "CIRCLE_L";
_wpLoiter setWaypointLoiterRadius _orbitRadius;

[format["Oscar Mike. ETA %1s.",40],_gunship, _jtacUnit] call SAS_Gunship_fnc_message;

// Wait until gunship is in range of attack position
waitUntil { _gunship distance2D _attackPos < (_orbitRadius + 700) };
["Entering fire mision airspace.",_gunship, _jtacUnit] call SAS_Gunship_fnc_message;
_gunship flyInHeight _alt;

// Wait until gunship is in orbit
waitUntil { _gunship distance2D _attackPos < (_orbitRadius + 50) };
_gunship forceSpeed 60;

// Add command menu
[] remoteExec ["SAS_Gunship_fnc_addCommandMenu", _jtacUnit];

// Send message
["Ready for fire mission.",_gunship, _jtacUnit] call SAS_Gunship_fnc_message;

// For laser designated missions
if (_mode == "LASER") then {
	[_gunship, _jtacUnit] spawn SAS_Gunship_fnc_trackLaserTarget;
};















