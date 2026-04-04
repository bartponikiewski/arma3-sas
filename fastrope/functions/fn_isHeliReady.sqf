params ["_heli", ["_maxAlt", 70], ["_minAlt", 10], ["_maxSpeed", 5]];

private _alt = (getPosATL _heli select 2);
private _speed = abs (speed _heli);

private _ready = (_alt <= _maxAlt) && 
			   (_alt >= _minAlt) && 
			   (_speed <= _maxSpeed);

_ready;