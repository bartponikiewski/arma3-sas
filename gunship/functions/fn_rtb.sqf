private _gunship = [] call SAS_Gunship_fnc_getGunshipUnit;
private _jtac = [] call SAS_Gunship_fnc_getJtacUnit;
private _maxCalls = [] call SAS_Gunship_fnc_getMaxCalls;

["RTB"] call SAS_Gunship_fnc_setGunshipState;
["RTB. Good luck!", _gunship, _jtac] call SAS_Gunship_fnc_message;
remoteExec ["SAS_Gunship_fnc_removeCommandMenu", _jtac];

[objNull] call SAS_Gunship_fnc_setJtacUnit;
[objNull] call SAS_Gunship_fnc_setGunshipUnitWeapon;
[objNull] call SAS_Gunship_fnc_setGunshipUnit;
[""] call SAS_Gunship_fnc_setGunshipAmmo;
[""] call SAS_Gunship_fnc_setGunshipMode;

private _currentPos = getPos _gunship;

{ deleteWaypoint _x } forEachReversed waypoints (group _gunship);
private _endPos = [_currentPos, 2500 + (random 500), random 360] call BIS_fnc_relPos;
private _dirTo = [_currentPos, _endPos] call BIS_fnc_dirTo;
private _wpExfil = [group _gunship, _endPos,"MOVE","FULL","CARELESS","NO CHANGE",700] call SAS_fnc_addWaypoint;

waitUntil { _gunship distance2D _endPos < 400 };

{ _gunship deleteVehicleCrew _x } forEach crew _gunship;
deleteVehicle _gunship;

["IDLE"] call SAS_Gunship_fnc_setGunshipState;

if (_maxCalls > 0) then {
	[false] remoteExec ["SAS_Gunship_fnc_addCallMenu", _jtac];
};




