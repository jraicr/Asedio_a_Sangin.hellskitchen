#include <crbprofiler.hpp>

private ["_mapsize","_height","_debug","_name","_color","_icon","_edgepos","_edge","_ex","_ey","_ez","_center","_cx","_cy","_offset"];

CRBPROFILERSTART("mso_core_fnc_randomEdgePos")

_mapsize = _this select 0;
_height = _this select 1;
_debug = _this select 2;
_name = _this select 3;
_color = _this select 4;
_icon = _this select 5;

_edgepos = [];
_center = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
_cx = _center select 0;
_cy = _center select 1;
_offset = _mapsize / 2;

_edge = round(random 3);
switch (_edge) do 
{
		case 0: {_ex = (random _mapsize) - _offset + _cx; _ey = _mapsize - _offset + _cy;}; // top edge
		case 1: {_ex = _mapsize - _offset + _cx; _ey = (random _mapsize) - _offset + _cy;}; // right edge
		case 2: {_ex = (random _mapsize) - _offset + _cx; _ey =  - _offset + _cy;}; // bottom edge
		case 3: {_ex =  - _offset + _cx; _ey = (random _mapsize) - _offset + _cy;}; // left edge
};
_ez = _height;

_edgepos = [_ex,_ey,_ez];

if (_debug) then 
{

		private["_t"];
		_t = format["rep_%1", _name];
		_m = [_t, _edgepos, "Icon", [0.5,0.5], "TYPE:", _icon, "TEXT:", _name, "COLOR:", _color, "GLOBAL"] call CBA_fnc_createMarker;
};

CRBPROFILERSTOP

_edgepos;
