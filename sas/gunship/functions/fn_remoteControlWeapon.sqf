if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {!isNull player};

private _gunshipUnit = [] call SAS_Gunship_fnc_getGunshipUnit;

private _gunner = gunner _gunshipUnit;

player remoteControl _gunner;
_gunshipUnit switchCamera "GUNNER";

while {cameraOn == _gunshipUnit} do {
	if (cameraView != "GUNNER") then {
		_gunshipUnit switchCamera "GUNNER";
		player remoteControl _gunner;
	};

	if(!(_gunner in _gunshipUnit)) then {
		_gunner moveInGunner _gunshipUnit;
		player remoteControl _gunner;
	};
	sleep 0.1;
};


