/*
    Description:
    Reset group to default state

    Parameters(s):
    0: OBJECT or GROUP - group leader

	Returns:
	Nothing
*/

params [
    ["_grp", objNull, [objNull, grpNull]]
];

// Validate
if (isNull _grp) exitWith {};
if (typename _grp == "OBJECT") then { _grp = group _grp; };
if (!local _grp) exitWith {};

// Enable AI
{ _x enableAI "ALL"; } forEach units _grp;

// Clear waypoints
{ deleteWaypoint _x } forEachReversed waypoints _grp; 

// Reset behaviour
_grp setBehaviour "SAFE";
_grp setCombatBehaviour "SAFE";
_grp setCombatMode "WHITE";
_grp setSpeedMode "NORMAL";
_grp setFormation "WEDGE";