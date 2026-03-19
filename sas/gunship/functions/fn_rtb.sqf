if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {!isNull player};

private _fakeWeapon = [] call SAS_Gunship_fnc_getGunshipUnitWeapon;
private _gunship = [] call SAS_Gunship_fnc_getGunshipUnit;
private _maxCalls = [] call SAS_Gunship_fnc_getMaxCalls;

["RTB.", _gunship] call SAS_Gunship_fnc_message;
[] call SAS_Gunship_fnc_removeCommandMenu;
[objNull] call SAS_Gunship_fnc_setJtacUnit;
[objNull] call SAS_Gunship_fnc_setGunshipUnitWeapon;
{ _fakeWeapon deleteVehicleCrew _x } forEach crew _fakeWeapon;
deleteVehicle _fakeWeapon;

{ deleteWaypoint _x } forEachReversed waypoints (group _gunship);
private _endPos = [getPos _gunship, 2500 + (random 500), random 360] call BIS_fnc_relPos;
private _dirTo = [_attackPos, _spawnPos] call BIS_fnc_dirTo;

private _exfilPos = [_attackPos, _orbitRadius + 500, _dirTo] call BIS_fnc_relPos;
private _wpExfil = [group _gunship,_exfilPos,"MOVE","FULL","CARELESS","NO CHANGE",700] call SAS_fnc_addWaypoint;

waitUntil { _gunship distance2D _exfilPos < 400 };


[objNull] call SAS_Gunship_fnc_setGunshipUnit;

[""] call SAS_Gunship_fnc_setGunshipAmmo;
[""] call SAS_Gunship_fnc_setGunshipMode;

{ _gunship deleteVehicleCrew _x } forEach crew _gunship;
deleteVehicle _gunship;

if (_maxCalls > 0) then {
	[] call SAS_Gunship_fnc_addCallMenu;
};




