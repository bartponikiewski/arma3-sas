params [["_spawnPos", [0,0,0]],  ["_side", west], ["_callsign", "Swordfish"], ["_class", "B_T_VTOL_01_armed_F"]];

private _alt = 500;
private _GAU = 7000;
private _40HE = 256;
private _40AT = 256;
private _120HE = 100;
private _120AT = 100;

_spawnPos set [2,_alt + 200];
if ((_spawnPos select 2) < 700) then {
	_spawnPos set [2, _alt + 200];
};


// Spawn the vehicle and crew it with generic soldiers. The crew will be replaced with the actual gunship unit when they board.
private _createdVehicle = [_spawnPos, 0, _class, _side] call BIS_fnc_spawnVehicle; 
_createdVehicle params ["_vehicle", "_crew", "_group"];
createVehicleCrew _vehicle;
_vehicle setGroupIdGlobal [_callsign];
_vehicle setVariable ["SAS_Gunship_callsign", _callsign, true];
_vehicle allowDamage false;
(group _vehicle) setBehaviour "CARELESS";
(group _vehicle) setCombatMode "BLUE";
_vehicle flyInHeight _alt;

{_x allowDamage false;} foreach crew _vehicle;

// Add fake weapon
_vehicle addWeaponTurret ["autocannon_40mm_VTOL_01",[1]]; 
_vehicle addMagazineTurret ["40Rnd_40mm_APFSDS_Tracer_Green_shells",[1],_40AT];
_vehicle addMagazineTurret ["60Rnd_40mm_GPR_Tracer_Green_shells",[1],_40HE];

[_vehicle] call SAS_Gunship_fnc_setGunshipUnit;

[_vehicle, objNull]






