/*
    Description:
    Garrisons units into nearby buildings within a given radius. Each available building position is filled in order until all units are placed or positions run out. Optionally prioritizes high (Z) positions (e.g., towers/roofs).

    Usage:
    [group, position, radius, prioritizeByHeight] call SAS_Task_fnc_garrisonUnits;

    Parameter(s):
    0: Units - the array of units that will be garrisoned
    1: Position - the center position (Array)
    2: (Optional) Number - radius to search for buildings (default: 100)
    3: (Optional) Boolean - prioritize by Z (height) (default: false)

    Returns:
    Number - number of units garrisoned
    
    Debug:
    If SAS_Debug_global is true, logs the number of units garrisoned and prioritization mode.
*/


params ["_units", "_position", ["_radius", 100], ["_prioritizeByHeight", false]];

if (isNil "_units" || count _units == 0) exitWith {
    ["[SAS_Task_fnc_garrison] ERROR: Units array is null or empty"] call SAS_fnc_logDebug;
    0
};
if ((typeName _position) != (typeName [])) exitWith {
    ["[SAS_Task_fnc_garrison] ERROR: Position must be an Array"] call SAS_fnc_logDebug;
    0
};


private _buildings = nearestObjects [_position, ["House", "Building"], _radius];
private _allPositions = [];
{
    _allPositions append (_x buildingPos -1);
} forEach _buildings;

// Prioritize by Z (height) if requested
private _positionsSorted = [];
if (_prioritizeByHeight) then {
    _positionsSorted = _allPositions apply { [_x, (_x select 2)] };
    _positionsSorted sort false; // sort descending by Z
    _positionsSorted = _positionsSorted apply { _x select 0 };
    if (SAS_Debug_global) then {
        ["[SAS_task_fnc_garrison] Prioritizing by Z (height): highest positions first"] call SAS_fnc_logDebug;
    };
} else {
    // Shuffle for randomness (legacy behavior)
    _positionsSorted = _allPositions call BIS_fnc_arrayShuffle;
    if (SAS_Debug_global) then {
        ["[SAS_task_fnc_garrison] Not prioritizing by height: using randomized positions"] call SAS_fnc_logDebug;
    };
};


private _garrisoned = 0;
{
    if (_garrisoned >= (count _units)) exitWith {};
    private _unit = _units select _garrisoned;
    private _pos = _x;
    _unit setPosATL _pos;
    doStop _unit;
    _unit setUnitPos "UP";

    if (SAS_Debug_global) then {
        private _marker = createMarker [format ["sas_garrison_%1_%2", groupId (group _unit), _garrisoned], _pos];
        _marker setMarkerShape "ICON";
        _marker setMarkerType "mil_dot";
        _marker setMarkerColor "ColorBlue";
        _marker setMarkerText format ["Garrison %1", _garrisoned + 1];
    };
    _garrisoned = _garrisoned + 1;
} forEach _positionsSorted;



if (SAS_Debug_global) then {
    [format ["[SAS_task_fnc_garrison] Garrisoned %1 units in building positions (prioritizeByHeight: %2)", _garrisoned, _prioritizeByHeight]] call SAS_fnc_logDebug;
};

_garrisoned;
