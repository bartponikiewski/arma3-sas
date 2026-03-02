/*
    Description:
    Fires a flare from the group leader or specified unit. Allows choosing flare color (white, red, green, blue).

    Usage:
    [groupOrUnit, color, position] call SAS_fnc_fireFlare;

    Parameter(s):
    0: OBJECT or GROUP - Unit or group leader to fire the flare
    1: (Optional) STRING - Flare color: "white" (default), "red", "green", "blue"
    2: (Optional) ARRAY - Position where the flare should be fired (default: in front of leader)


    Returns:
    OBJECT - The created flare object

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [
    ["_grp", grpNull, [grpNull, objNull]],
    ["_color", "white", [""]],
    ["_position", [], [[]], [2,3]]
];

if (isNull _grp) exitWith {};
if (typename _grp == "OBJECT") then { _grp = group _grp; };
if (!local (leader _grp)) exitWith {};

private _unit = leader _grp;

private _ammoType = switch (toLower _color) do {
    case "red":   { "F_20mm_Red" };
    case "green": { "F_20mm_Green" };
    case "blue":  { "F_20mm_Cyan" };
    default { "F_20mm_White" };
};

private _pos = if (count _position > 1) then { _position } else { _unit modelToWorld [0,50,200] };
private _flare = _ammoType createVehicle _pos;
_flare setVelocity [0,0,-10];

if (SAS_Debug_global) then {
    [format ["Fired flare: %1 at %2 (color: %3)", _flare, _pos, _color]] call SAS_fnc_logDebug;
};

_flare;
