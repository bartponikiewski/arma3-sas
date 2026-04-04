/*
    Description:
    Handles reinforcement requests for a group. Checks eligibility, finds nearest available reinforcement group, and dispatches reinforcements.

    Usage:
    [group] call SAS_Reinforcement_fnc_requestReinforcements;

    Parameter(s):
    0: Group - The group requesting reinforcements

    Returns:
    Boolean - True if reinforcements dispatched, false otherwise

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group"];

// Basic checks
private _leader = leader _group;
private _knownEnemy = _leader findNearestEnemy (getPos _leader);
private _reinforcementTargetPos = if (isNull _knownEnemy) then {getPos _leader} else {getPos _knownEnemy};

// Find nearest available reinforcement group
private _nearestGroup = [_group] call SAS_Reinforcement_fnc_findNearestReinforcementGroup;
if (isNull _nearestGroup) exitWith { false };

// Leader fires flare to signal for reinforcements
[_group, "red"] call SAS_fnc_fireFlare;

// Call dispatch function
[_group, _nearestGroup, _reinforcementTargetPos] call SAS_Reinforcement_fnc_sendReinforcements;
[format ["[Reinforcement] Group %1 requested reinforcements from group %2 at position %3.", _group, _nearestGroup, _reinforcementTargetPos]] call SAS_fnc_logDebug;

true;
