/*
    Description:
    Gets the array of all registered reinforcement groups from the global registry.

    Usage:
    [] call SAS_Reinforcement_fnc_getRegisteredReinforcementGroups;

    Parameter(s):
    None

    Returns:
    ARRAY - Array of registered reinforcement groups

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

private _groups = missionNamespace getVariable ["SAS_Reinforcement_registeredReinforcementGroups", []];
[format ["[Reinforcement] getRegisteredReinforcementGroups: %1 groups", count _groups]] call SAS_fnc_logDebug;
_groups;
