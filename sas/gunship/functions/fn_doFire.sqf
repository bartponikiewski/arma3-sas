params ["_fakeWeap", "_trg", ["_ammoType", "20mm"]];

if (isNull _fakeWeap) exitWith { hint "Invalid weapon for firing." };
if (isNull _trg) exitWith { hint "Invalid target for firing." };
if (!isServer) exitWith { hint "Firing can only be done on the server." };

private _rounds = 1;
private _sleepNextBarrage = 0.4;
private _sleepNextRounds = 0.2;
private _weapon = currentWeapon _fakeWeap;
private _ammoClass = "";
private _spread = 0;


switch (_ammoType) do {
	case "20mm": {
		_ammoClass = "B_20mm_Tracer_Red";
		_rounds = 10;
		_sleepNextRounds = 0.2;
		_sleepNextBarrage = 2;
		_spread = 5;	
	};
	case "40mmHE": {
		_ammoClass = "B_40mm_GPR_Tracer_Green";
		_rounds = 4;
		_sleepNextRounds = 1;
		_sleepNextBarrage = 5;
		_spread = 1;
	};
	case "40mmAT": {
		_ammoClass = "B_40mm_APFSDS_Tracer_Green";
		_rounds = 4;
		_sleepNextRounds = 1;
		_sleepNextBarrage = 5;
		_spread = 1;
	};
	case "120mmHE": {
		_ammoClass = "Sh_120mm_HE_Tracer_Green";
		_rounds = 1;
		_sleepNextRounds = 0;
		_sleepNextBarrage = 10;
	};
	case "120mmAT": {	
		_ammoClass = "Sh_120mm_APFSDS_Tracer_Yellow";
		_rounds = 1;
		_sleepNextRounds = 0;
		_sleepNextBarrage = 10;
	};
};

private _dir = [_fakeWeap, _trg] call BIS_fnc_dirTo;
_fakeWeap setDir _dir;

for "_i" from 1 to _rounds do {;
	private _pos = getPosATL _fakeWeap;
	_pos set [2,(_pos select 2) - 2.5]; 
	private _ammo = createVehicle [_ammoClass,_pos,[],0,"NONE"];
	[_ammo,_trg,-1, _spread] spawn SAS_fnc_guideAmmo;
	sleep _sleepNextRounds;
};

sleep _sleepNextBarrage;
