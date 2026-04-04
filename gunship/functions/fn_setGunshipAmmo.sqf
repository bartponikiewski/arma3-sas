params [["_ammo", "20mm", ["20mm", "40mmHE", "40mmAT", "120mmHE", "120mmAT"]]];

private _gunship = [] call SAS_Gunship_fnc_getGunshipUnit;
private _jtacUnit = [] call SAS_Gunship_fnc_getJtacUnit;

if (!isNull _gunship && !isNull _jtacUnit) then {
	[format ["Ready to fire %1",_ammo], _gunship, _jtacUnit] call SAS_Gunship_fnc_message;
};

missionNamespace setVariable ["SAS_Gunship_ammo", _ammo, true];