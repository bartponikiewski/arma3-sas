/*
	Hide the covert weapon back under cover.
	If no enemy detected the player while armed, captive status is restored
	and the "Draw Weapon" action is re-added.
	If cover was blown, the system is fully reset (player keeps weapon,
	no more hiding allowed).

	Usage:
	[_unit] call SAS_CovertOps_fnc_hideWeapon;

	Parameters:
	0: Object - _unit: The undercover unit

	Returns:
	Nothing
*/
params [["_unit", objNull]];

if (isNull _unit) exitWith {
	["[SAS_CovertOps_fnc_hideWeapon]: Invalid unit"] call SAS_fnc_logDebug;
};

if (!alive _unit) exitWith {
	[format ["[SAS_CovertOps_fnc_hideWeapon]: Unit %1 is not alive", _unit]] call SAS_fnc_logDebug;
};

if (!local _unit) exitWith {
	[format ["[SAS_CovertOps_fnc_hideWeapon]: Unit %1 is not local", _unit]] call SAS_fnc_logDebug;
};

if (!(_unit getVariable ["SAS_CovertOps_active", false])) exitWith {
	["[SAS_CovertOps_fnc_hideWeapon]: Covert ops not active"] call SAS_fnc_logDebug;
};

// Signal detection loop to stop
_unit setVariable ["SAS_CovertOps_weaponDrawn", false];

// Remove hide action
private _hideActionId = _unit getVariable ["SAS_CovertOps_hideActionId", -1];
if (_hideActionId >= 0) then {
	_unit removeAction _hideActionId;
	_unit setVariable ["SAS_CovertOps_hideActionId", -1];
};

// No enemy saw us - remove weapon (magazines stay), restore captive
private _weaponClass = _unit getVariable ["SAS_CovertOps_weaponClass", ""];
_unit removeWeapon _weaponClass;

_unit setCaptive true;

// Re-add draw action
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
	"",
	-1
];
_unit setVariable ["SAS_CovertOps_drawActionId", _drawActionId];

[format ["[SAS_CovertOps_fnc_hideWeapon]: %1 successfully re-hidden, still undercover", _unit]] call SAS_fnc_logDebug;
