/*
	Description:
	Displays a random quote video

	Usage:
	[] call SAS_Intro_fnc_quote;

	Parameters(s):

	Returns:
	Nothing

	Debug:
	Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/
hint "TEST";

if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {(!isNull player)};

private _qArr = [
	["a3\missions_f_epa\video\",["c_ea_quotation", "c_eb_quotation", "c_m01_quotation", "b_hub01_quotation","b_in_quotation","b_m01_quotation","b_m02_1_quotation","b_m03_quotation","b_m05_quotation","b_m06_quotation"]]
	//-->Add more quote sources here as needed
];
private _tmpArr = _qArr call BIS_fnc_selectRandom;
private _path = _tmpArr select 0;
private _v = (_tmpArr select 1) call BIS_fnc_selectRandom;
private _vid = _path + _v + ".ogv";

["[SAS_intro_fnc_quote] Displayed quote video: " + _vid] call SAS_fnc_logDebug;
[_vid] call BIS_fnc_quotations;	

