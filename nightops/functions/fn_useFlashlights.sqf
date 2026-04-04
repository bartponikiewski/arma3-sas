/*
    Description:
    Equips all units in a group with flashlights. Ensures at least one unit has their flashlight switched on.

    Usage:
    [group, true] call SAS_NightOps_fnc_useFlashlights;

    Parameter(s):
    0: Group - The group to equip with flashlights
    1: (Optional) Boolean - Whether to force flashlights immediately (default: false)
    2: (Optional) Number - Percentage of units to equip with flashlights (default: 0.5)

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group", ["_force", false], ["_percent", 0.5]];
if (isNull _group) exitWith {};
if (typename _group == "OBJECT") then { _group = group _group; };
if (!local _group) exitWith {};


private _flashlightClass = "acc_flashlight";
private _units = units _group;
if ((count _units) == 0) exitWith {};

// Always give TL a flashlight
private _tl = leader _group;
if (!(_flashlightClass in (primaryWeaponItems _tl))) then {
    _tl addPrimaryWeaponItem _flashlightClass;
    [format ["[NightOps] Added flashlight to TL %1", name _tl]] call SAS_fnc_logDebug;
};

// Give a percentage of units (excluding TL) a flashlight, randomly
private _otherUnits = _units - [_tl];
private _shuffled = _otherUnits call BIS_fnc_arrayShuffle;
private _count = ceil((_percent * count _otherUnits));
{
    if ((_forEachIndex < _count) && !(_flashlightClass in (primaryWeaponItems _x))) then {
        _x addPrimaryWeaponItem _flashlightClass;
        [format ["[NightOps] Added flashlight to %1", name _x]] call SAS_fnc_logDebug;
    };
} forEach _shuffled;

// Force flashlights on if specified, otherwise just set to auto
if (_force) then {
    _group enableGunLights "forceOn";
} else {
    _group enableGunLights "auto";
};
