params [["_ammo", "20mm", ["20mm", "40mmHE", "40mmAT", "120mmHE", "120mmAT"]]];

private _gunship = [] call SAS_Gunship_fnc_getGunshipUnit;

if (!isNull _gunship) then {
	[format ["Ready to fire %1",_ammo], _gunship] call SAS_Gunship_fnc_message;
};

missionNamespace setVariable ["SAS_Gunship_ammo", _ammo];