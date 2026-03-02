/*
    Description:
    Handles group fear change event for reinforcement system.

    Usage:
    [group, oldFear, newFear] call SAS_Reinforcement_fnc_onGroupFearChanged;

    Parameters(s):
    0: GROUP - The group whose fear changed
    1: NUMBER - Previous fear value
    2: NUMBER - New fear value

    Returns:
    Nothing

    Debug:
    Calls SAS_fnc_logDebug to output debug information if SAS_Debug_global is true.
*/

params ["_group", "_oldFear", "_newFear"];
[format ["Reinforcement onGroupFearChanged: group=%1 oldFear=%2 newFear=%3", _group, _oldFear, _newFear]] call SAS_fnc_logDebug;

// Only proceed if newFear is >= 0.5
if (_newFear >= 0.5) then {
    // Check if group can call reinforcements
	private _canCall = [_group] call SAS_Reinforcement_fnc_getCanCall;
    private _leader = leader _group;
    private _knownEnemy = _leader findNearestEnemy (getPos _leader);

	if (_canCall) then {
        // Remove possibility to call more reinforcements
        [_group, false] call SAS_Reinforcement_fnc_setCanCall;

		// Call reinforcements for this group
		[_group] call SAS_Reinforcement_fnc_requestReinforcements;
	};

    // Remove possibility to be called, since this group need to be reinforced, not be a reinforcement
    [_group, false] call SAS_Reinforcement_fnc_setCanBeCalled;
};
