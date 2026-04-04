/*
    Description:
    Makes a civilian unit hostile and arms them with a weapon.

    Usage:
    [civ, side player, weaponClass] call SAS_civilians_fnc_makeHostile;

    Parameter(s):
    0: OBJECT/GROUP - Civilian Unit or group to make hostile
	1: (Optional) SIDE - Side that will be used to determine hostility. For example WEST will assign the civilian to be hostile towards WEST (default: WEST)
	2: (Optional) STRING - One of: PISTOL, SMG, SHOTGUN, RIFLE or exact class. (default: random)

    Returns:
    BOOL - true if successful, false otherwise
    
    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [
	["_civGroup", objNull, [objNull, grpNull]], 
	["_side", west, [west, east, resistance, civilian]], 
	["_weaponType", "AUTO", ["AUTO", "PISTOL", "SMG", "SHOTGUN","RIFLE"]]
];


// Define weapon options
private _weaponsConfig = createHashMapFromArray [
	["PISTOL", ["hgun_Pistol_heavy_01_F", "hgun_Pistol_01_F", "hgun_Rook40_F"]],
	["SMG", ["hgun_PDW2000_F"]],
	["SHOTGUN", ["sgun_HunterShotgun_01_F", "sgun_HunterShotgun_01_sawedoff_F"]],
	["RIFLE", ["srifle_DMR_06_hunter_F", "arifle_AKS_F"]]
];


// Validate parameters
if (isNull _civGroup) exitWith {
    [format ["[makeHostile] Invalid civilian group: %1", _civGroup]] call SAS_fnc_logDebug;
    false
};
if (typename _civGroup == "OBJECT") then { _civGroup = group _civGroup; };

if ((side _civGroup) != civilian) exitWith {
    [format ["[makeHostile] Invalid civilian group side: %1", _civGroup]] call SAS_fnc_logDebug;
    false
};

if (!local _civGroup) exitWith {
	[format ["[makeHostile] Civilian group %1 is not local", _civGroup]] call SAS_fnc_logDebug;
	false
};

// Determine hostile side
// remove sideEnemy if exists, this side cannot be used to create group in switchSide
private _hostileSides = (_side call BIS_fnc_enemySides) select { _x != sideEnemy };


if (count _hostileSides == 0) exitWith {
	[format ["[makeHostile] Invalid side: %1", _side]] call SAS_fnc_logDebug;
	false
};

// Select the first hostile side (could be randomized if multiple sides are valid)
private _hostileSide = _hostileSides select 0;

// Move civilian to a new hostile group (_hostileSide)
private _hostileGroup = [_civGroup, _hostileSide] call SAS_fnc_switchSide;

// Determine weapon type
private _weaponType = if (_weaponType isEqualTo "AUTO") then { selectRandom (keys _weaponsConfig) } else { _weaponType };

// Check if weapon type is valid
if !(_weaponType in _weaponsConfig) exitWith {
	[format ["[makeHostile] Invalid weapon type: %1", _weaponType]] call SAS_fnc_logDebug;
	false
};

// Select a random weapon from the chosen type
private _weaponClass = selectRandom (_weaponsConfig get _weaponType);

// set behaviour:
_hostileGroup setBehaviour "COMBAT";
_hostileGroup setCombatMode "RED";

// Add weapon and ammo to each civilian in the group, and set them to be hostile
{
	private _civ = _x;
	[_civ, _weaponClass, 2] call BIS_fnc_addWeapon;

	_civ setCaptive false;
	_civ selectWeapon _weaponClass;
} forEach units _hostileGroup;


[format ["[makeHostile] Civilian group %1 is now hostile and armed with %2", _hostileGroup, _weaponClass]] call SAS_fnc_logDebug;
true;