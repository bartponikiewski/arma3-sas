/*
    Description:
    Stops a unit, turns engine off, exits vehicle and prevents re-entry.

    Usage:
    [unit] call SAS_fnc_unitExitVehicle;

    Parameter(s):
    0: OBJECT - Unit to exit vehicle

    Returns:
    Nothing
*/

params [["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith {};
if (!alive _unit) exitWith {};
if (vehicle _unit == _unit) exitWith {};

doStop _unit;

vehicle _unit engineOn false;
_unit action ["GetOut", vehicle _unit];
unassignVehicle _unit;
[_unit] allowGetIn false;

waitUntil { vehicle _unit == _unit };

sleep 0.1;
