/*
    Description:
    Assigns a defend task to a group. Units will man nearby static defenses and guard the position. Optionally garrisons buildings and creates a marker if debug is enabled.

    Usage:
    [group, position, radius, garrisonBuildings, doPatrol] call SAS_Task_fnc_defend;

    Parameter(s):
    0: Group - the group to defend the position
    1: Position - the position to defend (Array)
    2: (Optional) Number - radius to search for statics/buildings (default: 100)
    3: (Optional) Boolean - garrison nearby buildings (default: true)
    4: (Optional) Boolean - enable patrol behavior (default: false)
    
	Returns:
    Boolean - true if defend task assigned, false otherwise

    Debug:
    If SAS_Debug_global is true, creates a map marker at the defend position.
    Calls SAS_fnc_logDebug to output debug information.
*/

params ["_group", "_position", ["_radius", 100], ["_garrisonBuildings", true],  ["_doPatrol", false]];

if (isNull _group) exitWith {
    ["[SAS_task_fnc_defend] ERROR: Group is null"] call SAS_fnc_logDebug;
    false
};
if ((typeName _position) != (typeName [])) exitWith {
    ["[SAS_task_fnc_defend] ERROR: Position must be an Array"] call SAS_fnc_logDebug;
    false
};

if(!local _group) exitWith {
    ["[SAS_task_fnc_defend] ERROR: Group is not local"] call SAS_fnc_logDebug;
    false
};

_group setBehaviour "SAFE";


// 1. Find all nearby static weapons (with empty gunner slots)
private _staticWeapons = [];
{
    if ((_x emptyPositions "gunner") > 0) then {
        _staticWeapons pushBack _x;
    };
} forEach (_position nearObjects ["StaticWeapon", _radius]);
private _numStatics = count _staticWeapons;

// 2. If garrisonBuildings, find all building positions; else, set to 0
private _buildingPositions = [];
if (_garrisonBuildings) then {
    private _buildings = nearestObjects [_position, ["House", "Building"], _radius];
    {
        _buildingPositions append (_x buildingPos -1);
    } forEach _buildings;
};
private _numBuildings = count _buildingPositions;

// 3. Shuffle units for randomness
private _allUnits = (units _group) - [leader _group];
private _units = _allUnits call BIS_fnc_arrayShuffle;
private _numUnits = count _units;



// 4. Decide split: statics, buildings, patrol, idle
private _numPatrol = if (_doPatrol) then {ceil (_numUnits * 0.15) max 1} else {0};
private _numIdle = ceil (_numUnits * 0.15) max 1;
private _numStaticsFinal = (_numStatics min (_numUnits - _numPatrol - _numIdle)) max 0;
private _numBuildingsFinal = (_numBuildings min (_numUnits - _numPatrol - _numIdle - _numStaticsFinal)) max 0;

// 5. Assign units by array slicing
private _assignedStatics = _units select [0, _numStaticsFinal];
private _assignedBuildings = _units select [_numStaticsFinal, _numBuildingsFinal];
private _assignedPatrol = _units select [_numStaticsFinal + _numBuildingsFinal, _numPatrol];
private _assignedIdle = _units select [_numStaticsFinal + _numBuildingsFinal + _numPatrol, _numIdle];


// 6. Assign statics
{
    if (_forEachIndex < count _staticWeapons) then {
        _x assignAsGunner (_staticWeapons select _forEachIndex);
        [_x] orderGetIn true;
    };
} forEach _assignedStatics;

// 7. Assign buildings (use SAS_Task_fnc_garrisonUnits)
if (_garrisonBuildings && {count _assignedBuildings > 0 && count _buildingPositions > 0}) then {
    [_assignedBuildings, _position, _radius, true] call SAS_Task_fnc_garrisonUnits;
};

// 9. Assign idle (sit/ambient anim)
if (count _assignedIdle > 0) then {
    private _anims = ["STAND","STAND_IA","SIT_LOW","KNEEL","LEAN","WATCH","WATCH1","WATCH2"];
    private _handle = _assignedIdle spawn {
        sleep 2;
        {
            if ((random 1) > 0.2) then {
                private _anim = selectRandom ["STAND","STAND_IA","SIT_LOW","KNEEL","LEAN","WATCH","WATCH1","WATCH2"];
                [_x, _anim, "ASIS"] call BIS_fnc_ambientAnimCombat;
            } else {
                _x action ["SitDown", _x];
            };
        } forEach _this;
    };
};

// 8. Assign patrol (optional)
if (_doPatrol && {count _assignedPatrol > 0}) then {
	[_group, _position, (_radius * 0.5)] call SAS_Task_fnc_patrol;
};



private _debugGlobal = missionNamespace getVariable ["SAS_Debug_global", false];
if (_debugGlobal) then {
    private _marker = createMarker [format ["sas_defend_%1", groupId _group], _position];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "mil_flag";
    _marker setMarkerColor "ColorRed";
    _marker setMarkerText format ["Defend: %1", groupId _group];
    [format ["[SAS_task_fnc_defend] Created defend marker for group %1 at %2", groupId _group, _position]] call SAS_fnc_logDebug;
    [format ["[SAS_task_fnc_defend] Assigned: %1 statics, %2 buildings, %3 patrol, %4 idle", count _assignedStatics, count _assignedBuildings, count _assignedPatrol, count _assignedIdle]] call SAS_fnc_logDebug;
};

true;