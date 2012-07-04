#include <crbprofiler.hpp>

private ["_types","_debug","_color","_icon","_dest"];

CRBPROFILERSTART("mso_core_fnc_findLocationsByType")

_types = _this select 0;
_debug = _this select 1;
_color = _this select 2;
_icon = _this select 3;

// Get Locations
if(isNil "CRB_LOCS") then {
        CRB_LOCS = [] call mso_core_fnc_initLocations;
};

_dest = [];
// Loop through destinations and return array of locations that meet the type(s)
{
		if (type _x in _types) then 
		{
				_dest set [count _dest, _x];
				// Mark the dest
				if (_debug) then 
				{
						private["_t","_m"];
						_t = format["%1", floor(random 10000)];
						_m = [_t, position _x, "Icon", [1,1], "TYPE:", _icon, "TEXT:", format["%1",type _x], "COLOR:", _color, "GLOBAL", "PERSIST"] call CBA_fnc_createMarker;
				};
		};
} forEach CRB_LOCS;

CRBPROFILERSTOP

_dest;