params [["_callback", {}]];

//-->Validate
if (isDedicated) exitWith {};
if (!hasInterface) exitWith {};

waitUntil {(!isNull player)};
waitUntil {time > 0};

missionNamespace setVariable ["SAS_BlackOut_radioState", radioEnabled, true];

//-->Black out
1 cutText ["", "BLACK FADED", 999];
0 fadeSound 0;
enableEnvironment false;
clearRadio;
enableRadio false;

player action ["SwitchWeapon", vehicle player, vehicle player, 99];

if (!isNil "_callback") then {
	[] call _callback;
};


