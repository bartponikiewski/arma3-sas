params ["_attackPos", "_jtacUnit", ["_mode", "AUTO"]];

if (!isServer) exitWith {};



private _orbitRadius = 750;
private _fireZoneRadius = 300;
private _spawnPos = [_attackPos, _orbitRadius + 1500 + (random 500), random 360] call BIS_fnc_relPos;
private _dirTo = [_attackPos, _spawnPos] call BIS_fnc_dirTo;
private _alt = 500;



// Create gunship and send it to attack position
private _createGunshipResult = [_spawnPos, side _jtacUnit] call SAS_Gunship_fnc_createGunship;
_createGunshipResult params ["_gunship", "_weapon"];

// Set jtac unit that called the gunship
[_jtacUnit] call SAS_Gunship_fnc_setJtacUnit;

// Set gunship mode
[_mode] call SAS_Gunship_fnc_setGunshipMode;

[_gunship, "gunship"] spawn {
	params ["_unit", "_markerName"];

	_markerName = createMarker [_markerName, position _unit];
	_markerName setMarkerShape "ICON";
	_markerName setMarkerType "mil_dot";
	_markerName setMarkerColor "ColorRed";

	while {alive _unit} do {
		_markerName setMarkerPos (getPos _unit);
		sleep 0.2;
	};

	deleteMarker _markerName;
};

//Send gunship to attack position
private _ipPos = [_attackPos, _orbitRadius + 500, _dirTo] call BIS_fnc_relPos;
private _wpIp = [group _gunship,_ipPos,"MOVE","FULL","CARELESS","NO CHANGE",700] call SAS_fnc_addWaypoint;
private _wpLoiter = [group _gunship,_attackPos,"LOITER","LIMITED","CARELESS"] call SAS_fnc_addWaypoint;
_wpLoiter setWaypointLoiterType "CIRCLE_L";
_wpLoiter setWaypointLoiterRadius _orbitRadius;

[format["Oscar Mike. ETA %1s.",40],_gunship] call SAS_Gunship_fnc_message;

waitUntil { _gunship distance2D _attackPos < (_orbitRadius + 600) };
["Entering fire mision airspace.",_gunship] call SAS_Gunship_fnc_message;
_gunship flyInHeight _alt;

waitUntil { _gunship distance2D _attackPos < (_orbitRadius + 150) };
_gunship forceSpeed 60;

// Add command menu
[_jtacUnit] remoteExec ["SAS_Gunship_fnc_addCommandMenu", _jtacUnit];

// Send message
["Ready for fire mission.",_gunship] call SAS_Gunship_fnc_message;

// For laser designated missions
if (_mode == "LASER") then {
	["Waiting for laser designation.",_gunship] call SAS_Gunship_fnc_message;

	[_gunship, _jtacUnit] spawn {
		params ["_unit", "_jtac"];
		private _weapon = [] call SAS_Gunship_fnc_getGunshipUnitWeapon;
		

		while {alive _jtac && !isNull _weapon} do {
			private _laserTarget = laserTarget _jtac;

			if (isNull _laserTarget) then {
				sleep 0.2;
			} else {
				[_laserTarget, _weapon] call SAS_Gunship_fnc_doFire;
			};
		};
	};
};













