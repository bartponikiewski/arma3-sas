/*
    Description:
    Teleports a unit to a specified altitude and position for a parachute (HALO) jump. Handles backpack preservation, chemlight attachment, and immersive effects for both player and AI. Fully modular and SAS-compliant.

    Usage:
    [unit] call SAS_fnc_doHalo;
    [unit, getPos unit, 4000, true, true, true] call SAS_fnc_doHalo;

    Parameter(s):
    0: OBJECT - Unit to perform the jump
    1: (Optional): POSITION - Jump position (default: unit's current position)
    2: (Optional): NUMBER - Jump altitude (default: 3000)
    3: (Optional): BOOL - Attach chemlight (default: true)
    4: (Optional): BOOL - Auto-open parachute at 150m (default: false)
    5: (Optional): BOOL - Preserve backpack (default: true)

    Returns:
    OBJECT - The unit that performed the jump

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

if (isDedicated) exitWith {};
params [
    ["_unit", objNull, [objNull]],
    ["_pos", [], [[]]],
    ["_altitude", 3000, [0]],
    ["_chemLight", true, [true]],
    ["_autoOpen", false, [false]],
    ["_saveLoadOut", true, [true]]
];

if (isNull _unit) exitWith { ["[SAS] doHalo: Unit parameter must not be objNull"] call SAS_fnc_logDebug; "Unit parameter must not be objNull. Accepted: OBJECT" call BIS_fnc_error };
if (!local _unit) exitWith { ["[SAS] doHalo: Unit must be local to execute"] call SAS_fnc_logDebug; "Unit must be local to execute." call BIS_fnc_error };
if (_altitude < 500) exitWith { ["[SAS] doHalo: Altitude too low"] call SAS_fnc_logDebug; "Altitude is too low for HALO. Accepted: 500 and greater." call BIS_fnc_error };
if (count _pos < 2) then { _pos = getPos _unit; };
[format ["[SAS] doHalo: Starting for %1 at %2m", _unit, _altitude]] call SAS_fnc_logDebug;

// Immersion effects for player
if (isPlayer _unit) then {
    cutText ["", "BLACK FADED", 999];
    [_unit] spawn {
        private _unit = _this select 0;
        sleep 2;
        "dynamicBlur" ppEffectEnable true;
        "dynamicBlur" ppEffectAdjust [6];
        "dynamicBlur" ppEffectCommit 0;
        "dynamicBlur" ppEffectAdjust [0.0];
        "dynamicBlur" ppEffectCommit 5;
        cutText ["", "BLACK IN", 5];
    };
};

// Add chemlight if requested
if (_chemLight) then {
    [_chemLight, _unit] spawn {
        private ["_chemLight", "_unit", "_light"];
        _chemLight = _this select 0;
        _unit = _this select 1;
        _light = "chemlight_red" createVehicle [0,0,0];
        if (headgear _unit != "") then {
            _light attachTo [_unit, [-0.07,0.1,0.25], "head"];
            _light setVectorDirAndUp [[0,1,-1],[0,1,0.6]];
        } else {
            _light attachTo [_unit, [0,-0.07,0.06], "LeftShoulder"];
        };
        waitUntil {animationState _unit == "para_pilot"};
        if (headgear _unit != "") then {
            _light attachTo [vehicle _unit, [0,0.14,0.84], "head"];
            _light setVectorDirAndUp [[0,1,-1],[0,1,0.6]];
        } else {
            _light attachTo [vehicle _unit, [-0.13,-0.09,0.56], "LeftShoulder"];
            _light setVectorDirAndUp [[0,0,1],[0,1,0]];
        };
        waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1};
        detach _light;
        deleteVehicle _light;
    };
};

// Handle backpack preservation if requested
if (_saveLoadOut && !isNull (unitBackpack _unit) && (backpack _unit) != "b_parachute") then {
    private ["_pack", "_class", "_magazines", "_weapons", "_items", "_helmet"];
    _pack = unitBackpack _unit;
    _class = typeOf _pack;
    _magazines = getMagazineCargo _pack;
    _weapons = getWeaponCargo _pack;
    _items = getItemCargo _pack;
    _helmet = headgear _unit;
    removeBackpack _unit;
    _unit addBackpack "b_parachute";
    [_unit, _class, _magazines, _weapons, _items, _helmet, _altitude] spawn {
        private ["_unit", "_class", "_magazines", "_weapons", "_items", "_helmet", "_altitude"];
        _unit = _this select 0;
        _class = _this select 1;
        _magazines = _this select 2;
        _weapons = _this select 3;
        _items = _this select 4;
        _helmet = _this select 5;
        _altitude = _this select 6;
        private _packHolder = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "can_collide"];
        _packHolder addBackpackCargoGlobal [_class, 1];
        waitUntil {animationState _unit == "HaloFreeFall_non"};
        _packHolder attachTo [_unit, [-0.12,-0.02,-.74], "pelvis"];
        _packHolder setVectorDirAndUp [[0,-1,-0.05],[0,0,-1]];
        waitUntil {animationState _unit == "para_pilot"};
        _packHolder attachTo [vehicle _unit, [-0.07,0.67,-0.13], "pelvis"];
        _packHolder setVectorDirAndUp [[0,-0.2,-1],[0,1,0]];
        waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1};
        detach _packHolder;
        deleteVehicle _packHolder;
        _unit addBackpack _class;
        clearAllItemsFromBackpack _unit;
        for "_i" from 0 to (count (_magazines select 0) - 1) do {
            (unitBackpack _unit) addMagazineCargoGlobal [(_magazines select 0) select _i, (_magazines select 1) select _i];
        };
        for "_i" from 0 to (count (_weapons select 0) - 1) do {
            (unitBackpack _unit) addWeaponCargoGlobal [(_weapons select 0) select _i, (_weapons select 1) select _i];
        };
        for "_i" from 0 to (count (_items select 0) - 1) do {
            (unitBackpack _unit) addItemCargoGlobal [(_items select 0) select _i, (_items select 1) select _i];
        };
    };
} else {
    [_unit] spawn {
        private _unit = _this select 0;
        if ((backpack _unit) != "b_parachute") then { _unit addBackpack "B_parachute" };
        waitUntil {animationState _unit == "para_pilot"};
        waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1};
        removeBackpack _unit;
    };
};

private _helmet = headgear _unit;
if (_altitude > 3040 && (headgear _unit) != "H_CrewHelmetHeli_B") then { _unit addHeadgear "H_CrewHelmetHeli_B" };

// Teleport unit to jump position and altitude
_unit setPos [_pos select 0, _pos select 1, _altitude];

// Handle AI and player differently for immersion and damage prevention during fall
if (!isPlayer _unit) then {
    _unit allowDamage false;
    _unit switchMove "HaloFreeFall_non";
    _unit disableAI "ANIM";
};

// Auto-open parachute for player if requested
if (isPlayer _unit) then {
    [_unit, _autoOpen] spawn {
        private ["_unit", "_autoOpen"];
        _unit = _this select 0;
        _autoOpen = _this select 1;
        if (_autoOpen) then {
            waitUntil {(getPos _unit select 2) < 150 && alive _unit && (vehicle _unit) == _unit};
            _unit action ["OpenParachute", _unit];
        };
        waitUntil {animationState _unit == "para_pilot"};
        setAperture 0.05;
        setAperture -1;
        "DynamicBlur" ppEffectEnable true;
        "DynamicBlur" ppEffectAdjust [8.0];
        "DynamicBlur" ppEffectCommit 0.01;
        sleep 1;
        "DynamicBlur" ppEffectAdjust [0.0];
        "DynamicBlur" ppEffectCommit 3;
        sleep 3;
        "DynamicBlur" ppEffectEnable false;
        "RadialBlur" ppEffectAdjust [0.0, 0.0, 0.0, 0.0];
        "RadialBlur" ppEffectCommit 1.0;
        "RadialBlur" ppEffectEnable false;
    };
};

// Wait until unit lands to finalize AI and player states
[_unit, _helmet] spawn {
    private ["_unit", "_helmet"];
    _unit = _this select 0;
    _helmet = _this select 1;
    waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1 && alive _unit};
    if (!isPlayer _unit) then {
        _unit enableAI "ANIM";
        _unit setPos [(getPos _unit select 0), (getPos _unit select 1), 0];
        _unit setVelocity [0,0,0];
        _unit setVectorUp [0,0,1];
        sleep 1;
        _unit allowDamage true;
    } else {
        _unit addHeadgear _helmet;
        sleep 2;
        _unit setDamage 0;
    };
};

["[SAS] parachuteJump: Completed"] call SAS_fnc_logDebug;

_unit;
