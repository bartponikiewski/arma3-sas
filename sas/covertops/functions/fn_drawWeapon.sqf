/*
	Draw the covert weapon. The player becomes vulnerable immediately
	(setCaptive false) and a detection monitor starts checking if enemies
	spot the player.

	Magazines are already in inventory (added once during init).

	Usage:
	[_unit] call SAS_CovertOps_fnc_drawWeapon;

	Parameters:
	0: Object - _unit: The undercover unit

	Returns:
	Nothing
*/
params [["_unit", objNull]];

if (isNull _unit) exitWith {
	["[SAS_CovertOps_fnc_drawWeapon]: Invalid unit"] call SAS_fnc_logDebug;
};

if (!alive _unit) exitWith {
	[format ["[SAS_CovertOps_fnc_drawWeapon]: Unit %1 is not alive", _unit]] call SAS_fnc_logDebug;
};

if (!local _unit) exitWith {
	[format ["[SAS_CovertOps_fnc_drawWeapon]: Unit %1 is not local", _unit]] call SAS_fnc_logDebug;
};

if (!(_unit getVariable ["SAS_CovertOps_active", false])) exitWith {
	["[SAS_CovertOps_fnc_drawWeapon]: Covert ops not active"] call SAS_fnc_logDebug;
};

// Retrieve stored weapon class
private _weaponClass = _unit getVariable ["SAS_CovertOps_weaponClass", ""];

// Add weapon and select it (magazines already in inventory)
_unit addWeapon _weaponClass;
_unit selectWeapon _weaponClass;

// Mark weapon as drawn (used by checkDetection loop condition)
_unit setVariable ["SAS_CovertOps_weaponDrawn", true];

// Immediately vulnerable
_unit setCaptive false;

// Remove draw action, add hide action
private _drawActionId = _unit getVariable ["SAS_CovertOps_drawActionId", -1];
if (_drawActionId >= 0) then {
	_unit removeAction _drawActionId;
	_unit setVariable ["SAS_CovertOps_drawActionId", -1];
};

private _hideActionId = _unit addAction [
	"<t color='#FFD700'>Hide Weapon</t>",
	{
		params ["_target", "_caller"];
		[_caller] call SAS_CovertOps_fnc_hideWeapon;
	},
	[],
	6,
	false,
	true,
	"",
	"_this == _target",
	0
];
_unit setVariable ["SAS_CovertOps_hideActionId", _hideActionId];

// Start detection monitoring loop
[_unit] spawn SAS_CovertOps_fnc_checkDetection;

[format ["[SAS_CovertOps_fnc_drawWeapon]: Unit %1 has drawn weapon %2", _unit, _weaponClass]] call SAS_fnc_logDebug;
