
/*
	File: addWaypoint.sqf
	Author: Sushi

	Description:
	Tworzy waypoint dla grupy

	Parameter(s):
	0: GROUP 
	1: POSITION
	2 (Optional): STRING - waypointType (default: "MOVE")
	3 (Optional): STRING - waypointSpeed (default: "UNCHANGED")
	4 (Optional): STRING - waypointBehaviour (default: "UNCHANGED")
	5 (Optional): STRING - waypointFormation (default: "NO CHANGE")
	6 (Optional): NUMBER - completion radius (default: 0)
	7 (Optional): STRING - warunek (default: "true")
	8 (Optional): STRING - statement (default: "")
	9 (Optional): ARRAY - timeout (default: [0,0,0])

	Returns:
	Waypoint
*/

//-->Parameters
params [
["_grp",grpNull,[grpNull]],
["_pos",[],[[]],[2,3]],
["_wpType","MOVE",[""]],
["_wpSpeed","UNCHANGED",[""]],
["_wpBeh","UNCHANGED",[""]],
["_wpForm","NO CHANGE",[""]],
["_wpRadius",0,[0]],
["_wpCond","true",[""]],
["_wpState","",[""]],
["_wpTimeout",[],[[]],[3]]
];

//-->Validate
if ( isNull _grp ) exitWith {};

//-->Variables
private _wp = nil;
_wpState = format ["if ( local this ) then { %1 }", _wpState];

//-->Main scope
//->Create wp
_wp = _grp addWaypoint [_pos,0];
if (_wpType != "") then {_wp setWaypointType _wpType;};
if (_wpSpeed != "") then {_wp setWaypointSpeed _wpSpeed;};
if (_wpBeh != "") then {_wp setWaypointBehaviour _wpBeh;};
if (_wpForm != "") then {_wp setWaypointFormation _wpForm;};

if (_wpRadius > 0) then {_wp setWaypointCompletionRadius _wpRadius;};
_wp setWaypointStatements [_wpCond, _wpState];
if (count _wpTimeout == 3) then { _wp setWaypointTimeout _wpTimeout; };

//-->Return
_wp;
