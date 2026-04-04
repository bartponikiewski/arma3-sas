//-->Determine mode based on time of day
private _sunriseSunsetTimes = date call BIS_fnc_sunriseSunsetTime;
private _sunrise = _sunriseSunsetTimes select 0;
private _sunset = _sunriseSunsetTimes select 1;
private _currentDaytime = dayTime;

// Is Night?
if ((_currentDaytime > _sunrise) && (_currentDaytime < _sunset)) then {
	//-->Daytime
	false
} else {
	//-->Nighttime
	true
};

