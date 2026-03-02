/*
    Description:
    Registers a group as available for reinforcement in the global registry.

    Usage:
    [group] call SAS_Reinforcement_fnc_registerReinforcementGroup;

    Parameter(s):
    0: GROUP - The group to register as reinforcement

    Returns:
    BOOL - true if registered, false if already present or invalid

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group"];
if (isNull _group) exitWith {false};
if (!isServer) exitWith {};

private _registeredReinforcementGroups = missionNamespace getVariable ["SAS_Reinforcement_registeredReinforcementGroups", []];

if (!(_group in _registeredReinforcementGroups)) then {
	// Add to registered reinforcement groups
    _registeredReinforcementGroups pushBackUnique _group;
    missionNamespace setVariable ["SAS_Reinforcement_registeredReinforcementGroups", _registeredReinforcementGroups, true];
    
	// Set can be called variable for this group
	[_group, true] call SAS_Reinforcement_fnc_setCanBeCalled;
	
	[format ["[Reinforcement] Group %1 registered as reinforcement.", _group]] call SAS_fnc_logDebug;
    true
} else {
    [format ["[Reinforcement] Group %1 already registered as reinforcement.", _group]] call SAS_fnc_logDebug;
    false
};
