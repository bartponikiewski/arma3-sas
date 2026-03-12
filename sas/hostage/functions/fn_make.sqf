/*
    Description:
    Makes unit a hostage. This is meant to be used for civilian units, but can technically be used on any unit.

    Usage:
    [_unit] call SAS_Hostage_fnc_makeHostage;

    Parameter(s):
    0: OBJECT - Unit to make a hostage

    Returns:
    BOOL - true if successful, false otherwise
    
    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [["_unit", objNull, [objNull, objEmpty]]];

// Validate parameters
if (isNull _unit) exitWith {
	[format ["[makeHostage] Invalid unit: %1", _unit]] call SAS_fnc_logDebug;
	false
};

if (!local _unit) exitWith {
	[format ["[makeHostage] Unit %1 is not local", _unit]] call SAS_fnc_logDebug;
	false
};

// Handle hostage state
[_unit, "CUFFED"] remoteExec ["SAS_Hostage_fnc_setHostageState", 0, true];