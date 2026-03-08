
// SAS global debug flag
SAS_Debug_global = true; // Set to false to disable all SAS debug output


group civ_1 addEventHandler ["KnowsAboutChanged", {
	params ["_group", "_targetUnit", "_newKnowsAbout", "_oldKnowsAbout"];

	private _unitKnowsAbout = civ_1 knowsAbout _targetUnit;
	hint format ["[KnowsAboutChanged] Group: %1, Target Unit: %2, New Knows About: %3, Old Knows About: %4, Unit Knows About: %5", _group, _targetUnit, _newKnowsAbout, _oldKnowsAbout, _unitKnowsAbout];
}];

hint "test";