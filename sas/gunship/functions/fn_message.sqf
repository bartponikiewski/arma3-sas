params ["_txt","_unit",["_remoteExecTarget", 0]];
private _callsign = _unit getVariable ["SAS_Gunship_callsign","Swordfish"];

[_callsign, "sas\assets\images\pilot_face.jpg", _txt, 4] remoteExec ["SAS_Conv_fnc_message", _remoteExecTarget];

// [_unit,_txt] remoteExec ["sideChat",_remoteExecTarget];
