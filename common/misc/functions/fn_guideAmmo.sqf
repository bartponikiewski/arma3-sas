/*
	File: guideAmmo.sqf
	Author: Sushi

	Description:
	Kieruje amunicj (rakietami, bombami etc)

	Parameter(s):
	0: OBJECT - amunicja 
	1: OBJECT, POS - cel
	2 (Optional): NUMBER - szybko amunicji -1 dla szybkosci z konfigu (default: -1)

	Returns:
	NOTHING
	
	Example:
	
*/
//-->Parameters
params [
["_ammo",objNull],
["_trgInit",objNull],
["_speed",-1],
["_spread", 0],
["_guideToEnd",true]
];

//-->Validate
if (isNull _ammo) exitWith {};
if (typename _trgInit == "ARRAY") then {
	_trgInit = createVehicle ["sign_sphere10cm_f",_trgInit,[],0,"CAN_COLLIDE"];
	[_trgInit,true] remoteExec ["hideObject"];
};
if (_speed == -1) then {
	_speed  = [configfile >> "CfgAmmo" >> typeOf _ammo,"typicalSpeed",200] call BIS_fnc_returnConfigEntry;
};

//-->Variables
private _perSecondChecks = 25;
private _trgAlt = createVehicle ["sign_sphere10cm_f",[_trgInit,_spread + (random _spread),random 360] call BIS_fnc_relPos,[],0,"CAN_COLLIDE"];
private _cond = true;
[_trgAlt,true] remoteExec ["hideObject"];
//-->Main scope
//->Guide
while {alive _ammo && _cond} do {
	
	private _trg = if (!isNull _trgInit && _spread == 0) then { _trgInit } else { _trgAlt };
	private _travelTime = (_trg distance _ammo) / _speed;
	private _relDir = [_ammo, _trg] call BIS_fnc_DirTo;
	private _relDirVer = asin ((((getPosASL _ammo) select 2) - ((getPosASL _trg) select 2)) / (_trg distance _ammo));
	
	if (!_guideToEnd) then {
		if (_ammo distance _trg < 10) then {_cond =false;}; 
	};
	
	_relDirVer = (_relDirVer * -1);
	
	if (alive _ammo) then {
		_ammo setDir _relDir;
		[_ammo, _relDirVer, 0] call BIS_fnc_setPitchBank;
		
		private _velocityX = (((getPosASL _trg) select 0) - ((getPosASL _ammo) select 0)) / _travelTime;
		private _velocityY = (((getPosASL _trg) select 1) - ((getPosASL _ammo) select 1)) / _travelTime;
		private _velocityZ = (((getPosASL _trg) select 2) - ((getPosASL _ammo) select 2)) / _travelTime;
		private _velocityForCheck = [_velocityX,_velocityY,_velocityZ];
		
		if ({(typeName _x) == (typeName 0)} count _velocityForCheck == 3 && alive _ammo) then {_ammo setVelocity _velocityForCheck};
		if (_ammo distance _trg <= 0) then { _ammo setDamage 1; };
	
		sleep (1 / _perSecondChecks);
	};
};

//->End
deleteVehicle _trgAlt;
