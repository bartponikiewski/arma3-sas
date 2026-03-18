if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {!isNull player};

private _jtacUnit = [] call SAS_Gunship_fnc_getJtacUnit;
if (isNull _jtacUnit) exitWith {};

if (!isPlayer _jtacUnit) exitWith {};
if (player != _jtacUnit) exitWith {};

private _fakeWeapon = [] call SAS_Gunship_fnc_getGunshipUnitWeapon;
if (isNull _fakeWeapon) exitWith {};

private _gunner = gunner _fakeWeapon;
_gunner doWatch player;

player remoteControl _gunner; 
_fakeWeapon switchCamera "GUNNER";


while {cameraOn == _fakeWeapon} do {
	if (cameraView != "GUNNER") then {
		_fakeWeapon switchCamera "GUNNER";
		player remoteControl _gunner;
	};

	if(vehicle _gunner != _fakeWeapon) then {
		_gunner moveInGunner _fakeWeapon;
		player remoteControl _gunner;
	};
	sleep 0.1;
};



