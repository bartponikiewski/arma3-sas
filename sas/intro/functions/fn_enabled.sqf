private _isEnabledNumeric = ["SAS_Intro_Enabled", 1] call BIS_fnc_getParamValue;

// _isEnabled willbe 0 or 1, map tp true/false for easier use in code
private _isEnabled = if (_isEnabledNumeric isEqualTo 1) then { true } else { false };
_isEnabled;