/*
	Initialize covert ops mode on a unit. Removes all weapons,
	sets the unit as captive so enemies ignore them, and adds a
	"Draw Weapon" self-action for the covert weapon.

	If weaponClass is provided, that weapon will be used when drawing.
	If weaponClass is empty, the unit's current primary weapon is used.

	Magazines are added once via BIS_fnc_addWeapon and persist through
	draw/hide cycles.

	Usage:
	[_unit] call SAS_CovertOps_fnc_init;
	[_unit, "hgun_PDW2000_F"] call SAS_CovertOps_fnc_init;

	Parameters:
	0: Object - _unit: The unit to set as undercover (typically player)
	1: String - _weaponClass: Classname of the covert weapon (default: unit's primary weapon)

	Returns:
	Nothing
*/
params [["_unit", objNull], ["_weaponClass", ""]];

if (isNull _unit) exitWith {
	["[SAS_CovertOps_fnc_init]: Invalid unit"] call SAS_fnc_logDebug;
};

if (!local _unit) exitWith {
	[format ["[SAS_CovertOps_fnc_init]: Unit %1 is not local", _unit]] call SAS_fnc_logDebug;
};

if (!alive _unit) exitWith {
	[format ["[SAS_CovertOps_fnc_init]: Unit %1 is not alive", _unit]] call SAS_fnc_logDebug;
};

if (_unit getVariable ["SAS_CovertOps_active", false]) exitWith {
	[format ["[SAS_CovertOps_fnc_init]: Covert ops already active on %1", _unit]] call SAS_fnc_logDebug;
};

// Set captive and state variables ASAP
_unit setCaptive true;
_unit setVariable ["SAS_CovertOps_active", true, true];
_unit setVariable ["SAS_CovertOps_coverBlown", false, true];

private _useCurrent = (_weaponClass == "");
// If no weapon class provided, use unit's current primary weapon
if (_useCurrent) then {
	_weaponClass = primaryWeapon _unit;
};

if (_weaponClass == "") exitWith {
	["[SAS_CovertOps_fnc_init]: No weapon class provided and unit has no primary weapon"] call SAS_fnc_logDebug;
};

// Remove all weapons and magazines
removeAllWeapons _unit;

// Remve old magazines and ensure the unit has it in inventory for magazines to be added
removeAllMagazines _unit;

// Add covert weapon with magazines via BIS_fnc_addWeapon, then hide the weapon
// Magazines remain in inventory and persist through draw/hide cycles
[_unit, _weaponClass, 4] call BIS_fnc_addWeapon;
_unit removeWeapon _weaponClass;

// Store weapon class for draw/hide
_unit setVariable ["SAS_CovertOps_weaponClass", _weaponClass];

// Add "Draw Weapon" self-action
private _drawActionId = _unit addAction [
	"<t color='#FFD700'>Draw Weapon</t>",
	{
		params ["_target", "_caller"];
		[_caller] call SAS_CovertOps_fnc_drawWeapon;
	},
	[],
	6,
	false,
	true,
	"",
	"_this == _target",
	0
];
_unit setVariable ["SAS_CovertOps_drawActionId", _drawActionId];

// Killed event handler for cleanup
private _ehId = _unit addEventHandler ["Killed", {
	params ["_unit"];
	[_unit] call SAS_CovertOps_fnc_reset;
}];
_unit setVariable ["SAS_CovertOps_killedEH", _ehId];

[format ["[SAS_CovertOps_fnc_init]: Unit %1 is now undercover, covert weapon %2", _unit, _weaponClass]] call SAS_fnc_logDebug;
