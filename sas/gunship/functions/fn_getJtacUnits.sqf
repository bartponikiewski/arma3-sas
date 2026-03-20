private  _units = missionNamespace getVariable ["SAS_Gunship_jtacUnits", []];

_units = _units select { !isNull _x && alive _x };

_units