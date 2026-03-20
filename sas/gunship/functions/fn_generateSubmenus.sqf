// SAS_GUNSHIP_SUBMENU_MODE = 	[
// 	["Control mode", false],
// 	[
// 		"Fire at will", 
// 		[2], "", -5, 
// 		[["expression", "['AUTO'] call SAS_Gunship_fnc_setGunshipMode;"]], 
// 		"1", 
// 		if ([] call SAS_Gunship_fnc_getGunshipMode != 'AUTO') then {"1"} else {"0"}, 
// 		"\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"
// 	],
// 	[
// 		"Laser designate", 
// 		[3], "", -5, 
// 		[["expression", "['LASER'] call SAS_Gunship_fnc_setGunshipMode;"]], 
// 		"1", 
// 		if ([] call SAS_Gunship_fnc_getGunshipMode != 'LASER') then {"1"} else {"0"}, 
// 		"\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"
// 	],
// 	[
// 		"Manual", 
// 		[4], "", -5, 
// 		[["expression", "['MANUAL'] call SAS_Gunship_fnc_setGunshipMode;"]],
// 		"1", 
// 		if ([] call SAS_Gunship_fnc_getGunshipMode != 'MANUAL') then {"1"} else {"0"}, 
// 		"\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"
// 	]
// ];

SAS_GUNSHIP_SUBMENU_AMMO = 
[
	["Ammo type", false],
	[
		"20mm", 
		[2], "", -5, 
		[["expression", "['20mm'] call SAS_Gunship_fnc_setGunshipAmmo;"]], 
		"1", 
		"1",
		"\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"
	],
	[
		"40mm (GPR)", 
		[3], "", -5, 
		[["expression", "['40mmHE'] call SAS_Gunship_fnc_setGunshipAmmo;"]], 
		"1", 
		"1",
		"\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"
	],
	[
		"40mm (APFSDS)", 
		[4], "", -5, 
		[["expression", "['40mmAT'] call SAS_Gunship_fnc_setGunshipAmmo;"]], 
		"1", 
		"1",
		"\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"
	],
	[
		"120mm (HE)", 
		[5], "", -5, 
		[["expression", "['120mmHE'] call SAS_Gunship_fnc_setGunshipAmmo;"]], 
		"1", 
		"1",
		"\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"
	],
	[
		"120mm (APFSDS)", 
		[6], "", -5, 
		[["expression", "['120mmAT'] call SAS_Gunship_fnc_setGunshipAmmo;"]], 
		"1", 
		"1",
		"\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"
	]
];

SAS_GUNSHIP_SUBMENU_COMMAND = [
	["", false],
	[
		"Select weapon", 
		[2], "#USER:SAS_GUNSHIP_SUBMENU_AMMO", -5, 
		[], 
		if ([] call SAS_Gunship_fnc_getGunshipMode == 'LASER') then {"1"} else {"0"}, 
		"1"
	],
	[
		"Remote controll weapon", 
		[3], "", -5, 
		[["expression", "[] spawn SAS_Gunship_fnc_remoteControlWeapon;"]],
		if ([] call SAS_Gunship_fnc_getGunshipMode == 'MANUAL') then {"1"} else {"0"}, 
		"1"
	],
	[
		"RTB", 
		[5], "", -5, 
		[["expression", "[] remoteExec ['SAS_Gunship_fnc_rtb', 2];"]],
		"1", 
		"1"
	]
];

SAS_GUNSHIP_SUBMENU_CALL = 	[
	["Call", true],
	[
		"Call on position (Laser designated)",
		[2], "", -5, 
		[["expression", "[_pos, 'LASER', player] spawn SAS_Gunship_fnc_startMission;"]], 
		"1", 
		"1", 
		"\A3\ui_f\data\igui\cfg\cursors\iconCursorSupport_ca.paa"
	],
	[
		"Call on position (Remote fire control)",
		[3], "", -5, 
		[["expression", "[_pos, 'MANUAL', player] spawn SAS_Gunship_fnc_startMission;"]], 
		"1", 
		"1", 
		"\A3\ui_f\data\igui\cfg\cursors\iconCursorSupport_ca.paa"
	]
];