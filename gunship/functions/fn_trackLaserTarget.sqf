params ["_gunship", "_jtac"];

if (isNull _gunship) exitWith { hint "Invalid gunship for tracking laser target." };
if (isNull _jtac) exitWith { hint "Invalid JTAC unit for tracking laser target." };
if (!alive _jtac) exitWith { hint "JTAC unit is not alive." };	
if (!isServer) exitWith { hint "Tracking laser target can only be done on the server." };

private _state = "IDLE";

waitUntil { 
	_state = [] call SAS_Gunship_fnc_getGunshipState;
	_state == "ONMISSION";
};

private _waitingLaserTargetMessageSent = false;
private _fireingMessageSent = false;

while {alive _jtac && _state == "ONMISSION"} do {
	private _laserTarget = laserTarget _jtac;
	_state = [] call SAS_Gunship_fnc_getGunshipState;

	if (isNull _laserTarget) then {
		if (!_waitingLaserTargetMessageSent) then {
			["Waiting for laser designation.",_gunship, _jtac] spawn SAS_Gunship_fnc_message;
			_waitingLaserTargetMessageSent = true;
			_fireingMessageSent = false;
		};
		sleep 0.2;
	} else {
		if (!_fireingMessageSent) then {
			["Target acquired. Engaging.",_gunship, _jtac] spawn SAS_Gunship_fnc_message;
			_fireingMessageSent = true;
			_waitingLaserTargetMessageSent = false;
		};

		private _ammoType = [] call SAS_Gunship_fnc_getGunshipAmmo;
		[_laserTarget, _gunship, _ammoType] call SAS_Gunship_fnc_doFire;
	};
};