params [["_spawnPos", [0,0,0]],  ["_side", west], ["_callsign", "Swordfish"], ["_class", "B_T_VTOL_01_armed_F"]];

if (!isServer) exitWith {};


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
_vehicle setVehicleAmmo 0;
(group _vehicle) setBehaviour "CARELESS";
(group _vehicle) setCombatMode "BLUE";
_vehicle flyInHeight _alt;

{_x allowDamage false;} foreach crew _vehicle;



// Attach fake weapon to the vehicle to make sure it has the correct gunner seat available for the gunship unit when they board. The fake weapon will be hidden and deleted as soon as the gunship unit takes control of the vehicle.
private _createdWeapon = [[0,0,30], 0, "B_GMG_01_HIGH_F",_side] call BIS_fnc_spawnVehicle; 
_createdWeapon params ["_fakeWeap", "_fakeWeapCrew", "_fakeWeapGroup"];
createVehicleCrew _fakeWeap;
_fakeWeap allowDamage false;
(gunner _fakeWeap) allowDamage false;
_fakeWeap attachTo [_vehicle,[0,0,-8]];
// hideObjectGlobal _fakeWeap;
(group _fakeWeap) setBehaviour "CARELESS";
(group _fakeWeap) setCombatMode "BLUE";

_fakeWeap removeWeaponTurret ["GMG_20mm", [0]];
_fakeWeap addWeaponTurret ["gatling_20mm",[0]]; 
_fakeWeap addWeaponTurret ["autocannon_40mm_VTOL_01",[0]]; 
_fakeWeap addWeaponTurret ["cannon_120mm",[0]]; 
_fakeWeap addMagazineTurret ["1000Rnd_20mm_shells",[0],_GAU];
_fakeWeap addMagazineTurret ["40Rnd_40mm_APFSDS_Tracer_Green_shells",[0],_40AT];
_fakeWeap addMagazineTurret ["60Rnd_40mm_GPR_Tracer_Green_shells",[0],_40HE];
_fakeWeap addMagazineTurret ["30Rnd_120mm_APFSDS_shells_Tracer_Yellow",[0],_120AT];
_fakeWeap addMagazineTurret ["30Rnd_120mm_HE_shells_Tracer_Yellow",[0],_120HE];

[_vehicle] call SAS_Gunship_fnc_setGunshipUnit;
[_fakeWeap] call SAS_Gunship_fnc_setGunshipUnitWeapon;

[_vehicle, _fakeWeap]






