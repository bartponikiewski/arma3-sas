params ["_txt","_unit",["_remoteExecTarget", 0]];
private _callsign = _unit getVariable ["SAS_Gunship_callsign",""];

[_unit,_txt] remoteExec ["sideChat",_remoteExecTarget];
