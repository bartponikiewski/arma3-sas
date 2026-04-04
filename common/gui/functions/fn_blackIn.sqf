params [["_callback", {}]];

//-->Validate
if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {(!isNull player)};
waitUntil {time > 0};

private _radioState = missionNamespace getVariable ["SAS_BlackOut_radioState", true];

//-->Black in
"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [6];
"dynamicBlur" ppEffectCommit 0;
"dynamicBlur" ppEffectAdjust [0.0];
"dynamicBlur" ppEffectCommit 5;

1 cutText ["", "BLACK IN", 2];

enableEnvironment true;
enableRadio _radioState;

player action ["SwitchWeapon", vehicle player, vehicle player, 0];

if (!isNil "_callback") then {
	[] call _callback;
};

3 fadeSound 1;