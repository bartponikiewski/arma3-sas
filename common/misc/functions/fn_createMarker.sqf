/*
	File: createMarker.sqf
	Author: Sushi

	Description:
	Tworzy marker na mapie

	Parameter(s):
	0: STRING - nazwa markera
	1: POSITION - pozycja markera
	2 (Optional): STRING - Tekst markera
	3 (Optional): STRING - Kolor markera (default: "Default")
	4 (Optional): STRING or ARRAY - Typ/shape markera 
		STRING - jeśli marker jest ikoną: nazwa ikony(default: "mil_dot")
		ARRAY - tylko jeśli marker nie jest ikoną [SHAPE,SIZE,BRUSH]
			0: STRING - kształt "RECTANGLE" lub "ELLIPSE" 
			1: ARRAY - wielkość [a-axis,b-axis] 
			2 (Optional): STRING - wypełnienie (default: "SOLID")
		
	5 (Optional): NUMBER - Alpha markera (default: 1)
	6 (Optional): BOOL - Czy globalnie (default: true)

	Returns:
	Marker
*/

//-->Parameters
params [
["_mrkName","",[""]],
["_mrkPos",[],[[]],[2,3]],
["_mrkText","",[""]],
["_mrkColor","DEFAULT",[""]],
["_mrkType","mil_dot",["",[]],[2,3]],
["_mrkAlpha",1,[0]],
["_isGlobal",true,[false]]
];

//-->Variables
private _mrk = nil;
private _mrkShape = nil;
private _mrkSize = nil;
private _mrkBrush = nil;

if (typeName _mrkType == "ARRAY") then {
	_mrkShape = _mrkType param [0,"RECTANGLE"];
	_mrkSize = _mrkType param [1,[50,50]];
	_mrkBrush  = _mrkType param [2,"SOLID"];
};

//-->Main scope
if (_isGlobal) then { 
	_mrk = createMarker[_mrkName,_mrkPos];
	
	if (!isNil "_mrkShape") then {
		_mrk setMarkerShape _mrkShape;
		_mrk setMarkerSize _mrkSize;
		_mrk setMarkerBrush _mrkBrush;
	} else {
		_mrk setMarkerType _mrkType;
	};
	
	_mrk setMarkerColor _mrkColor;
	_mrk setMarkerAlpha _mrkAlpha;
	if (_mrkText != "") then { _mrk setMarkerText _mrkText; };
	
	
} else { 
	_mrk = createMarkerLocal[_mrkName,_mrkPos];
	
	if (!isNil "_mrkShape") then {
		_mrk setMarkerShapeLocal _mrkShape;
		_mrk setMarkerSizeLocal _mrkSize;
		_mrk setMarkerBrushLocal _mrkBrush;
	} else {
		_mrk setMarkerTypeLocal _mrkType;
	};
	
	_mrk setMarkerColorLocal _mrkColor;
	_mrk setMarkerAlphaLocal _mrkAlpha;
	if (_mrkText != "") then { _mrk setMarkerTextLocal _mrkText; };
	
};

//-->Return
_mrk;
