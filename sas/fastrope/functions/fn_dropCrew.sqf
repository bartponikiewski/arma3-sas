/*
  Heli ddrop crew from helicopter on fastropes. 
  Should be used in conjunction with fn_fastrope and fn_cutRopes to create a complete fast rope experience.

  Usage:
  [heli] spawn SAS_Fastrope_fnc_dropCrew;

  Parameter(s):
  0: OBJECT - Helicopter to use for fast rope transport
  1: ARRAY - Position to drop troops at (e.g., marker position)
  2: ARRAY - Position for helicopter to return to after fast rope operation
  3: BOOL - Whether to delete the helicopter at the end of the mission
*/

params ["_heli"];

// Check params
if (isNull _heli) exitWith {
	["Error: No helicopter provided to fn_createRopes."] call SAS_fnc_logDebug;
};

private _ropes = _heli getVariable ["SAS_Fastrope_attachedRopes", []];
if (count _ropes == 0) exitWith {
	["Error: No ropes attached to helicopter for fn_dropCrew."] call SAS_fnc_logDebug;
};


private _passangersData = (fullCrew _heli) select { (_x select 2) != -1};

if (count _passangersData == 0) exitWith {
	["Error: No passengers found in helicopter for fn_dropCrew."] call SAS_fnc_logDebug;
};

/*
	Prepare passangers arrays
	Split passangaers quealy into as many groups as existing ropes
*/
private _groups = [];
private _groupSize = ceil (count _passangersData / count _ropes);
for "_i" from 0 to (count _ropes - 1) do {
	private _startIndex = _i * _groupSize;
	private _endIndex = (_startIndex + _groupSize) min count _passangersData;
	private _group = _passangersData select [_startIndex, (_endIndex - _startIndex)];
	_groups pushBack _group;
};

// Spawn rope descent scripts for each group
private _scriptsHandlers = [];
{
	private _group = _x;
  	private _rope = _ropes select _forEachIndex;

	private _scriptHandle = [_group, _rope] spawn {
		params ["_group", "_rope"];

		{
			private _unit = _x select 0;
			[_unit, _rope] call SAS_Fastrope_fnc_doFastrope;

			sleep 2;
		} forEach _group;
	};

	_scriptsHandlers pushBack _scriptHandle;

} forEach _groups;


// Wait for all rope descent scripts to finish
{
	waitUntil {scriptDone _x};
} forEach _scriptsHandlers;

true;