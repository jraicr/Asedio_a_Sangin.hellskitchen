#include <crbprofiler.hpp>

private ["_position","_radius","_name","_debug","_currentSideCount","_maxSideCount","_side","_units"];

CRBPROFILERSTART("mso_core_fnc_getDominantSide")

_position = _this select 0;
_radius = _this select 1;
_name = _this select 2;
_debug = _this select 3;

_currentSideCount = 0;
_maxSideCount = 0;

// Get units at location
_units = [_position, _radius] call mso_core_fnc_getUnitsInArea;

if (_debug) then 
{
		diag_log format ["MSO-%1 Dominant Side: %2 has %3 units", time, _name, str(count _units)];
};

{
		_currentSideCount = _x countSide _units;
		if ((_debug) && (_currentSideCount > 0)) then 
		{
				diag_log format ["MSO-%1 Dominant Side: %2 side %3 has %4 units", time, _name, _x, _currentSideCount];
		};
		If (_currentSideCount > _maxSideCount) then 
		{
				_side = _x;
				_maxSideCount = _currentSideCount;
		};
} foreach [WEST,EAST,resistance];

if (_maxSideCount == 0) then 
{
	_side = civilian;
};

if (_debug) then
{
		diag_log format ["MSO-%1 Dominant Side: %2 Dominant side is %3 and has %4 units", time, _name, _side, _maxSideCount];
};

CRBPROFILERSTOP

_side;