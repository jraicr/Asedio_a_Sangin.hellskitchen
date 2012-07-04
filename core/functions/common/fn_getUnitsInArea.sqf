#include <crbprofiler.hpp>

private ["_pos","_radius","_units"];

CRBPROFILERSTART("mso_core_fnc_getUnitsInArea")

_pos = _this select 0;
_radius = _this select 1;

_units = [];
{
	if(_pos distance _x < _radius) then {
		_units set [count _units, _x];
	};
} forEach allUnits;

CRBPROFILERSTOP

_units;