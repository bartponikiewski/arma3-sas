/*
    Description:
    Registers a group into the reinforcement system, allowing it to call reinforcements or be called as reinforcement.

    Usage:
    [group player, true, false] call SAS_Reinforcement_fnc_registerGroup;
    [player, false, true] call SAS_Reinforcement_fnc_registerGroup;

    Parameters(s):
    0: OBJECT or GROUP - Group leader or group
    1: BOOL - Can call reinforcements
    2: BOOL - Can be called as reinforcement

    Returns:
    BOOL - true if registered, false if already registered or invalid

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params [
	"_group",
	["_canCall", false, [false]],
	["_canBeCalled", false, [false]]
];
if (isNull _group) exitWith {false};
if (typename _group == "OBJECT") then { _group = group _group; };
if (!local _group) exitWith {false};

// Register as group that can be called as reinforcement if applicable
if (_canBeCalled) then {
    [_group] call SAS_Reinforcement_fnc_registerReinforcementGroup;
};

// Register as caller group if applicable
if (_canCall) then {
    [_group] call SAS_Reinforcement_fnc_registerCallerGroup;
};

[format ["Reinforcement register: group=%1 canCall=%2 canBeCalled=%3", _group, _canCall, _canBeCalled]] call SAS_fnc_logDebug;
true;