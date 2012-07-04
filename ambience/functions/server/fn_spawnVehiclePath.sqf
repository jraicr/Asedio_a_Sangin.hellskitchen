#include <crbprofiler.hpp>

/* ----------------------------------------------------------------------------
Function: CBA_fnc_spawnVehiclePath

Description:
	A function for a group to spawn and follow a set path before deleting. Inspired by Kylanias runRoute script
	
Parameters:
	- Classname (String)
	- Side (Side)
	- Path (Array of XYZ, Objects, Markers or Locations, first position is spawn point)
	Optional:
	- Completion Radius
	- Speed
	- Combat Mode
	- Behaviour
	- Direction
Example:
	["A10_US_EP1",west,["mkr1","mkr2","mkr3"],10,"FULL","RED","DANGER",markerdir "mkr1"] call CBA_fnc_spawnVehiclePath
Returns:
	Group
Author:
	Rommel

---------------------------------------------------------------------------- */

CRBPROFILERSTART("mso_ambience_fnc_spawnVehiclePath")

private ["_class","_side","_positions","_radius","_speed","_behaviour","_direction","_array","_vehicle","_group","_waypoint","_count","_combat_mode"];
_class = _this select 0;
_side = _this select 1;
_positions = _this select 2;
_radius = if (count _this > 3) then {_this select 3} else {0};
_speed = if (count _this > 4) then {_this select 4} else {"limited"};
_combat_mode = if (count _this > 5) then {_this select 5} else {"yellow"};
_behaviour = if (count _this > 6) then {_this select 6} else {"safe"};
_direction = if (count _this > 7) then {_this select 7} else {0};

_array = [(_positions select 0) call CBA_fnc_getpos, _direction, _class, _side] call BIS_fnc_spawnVehicle;
_vehicle = _array select 0;
_group = _array select 2;

_waypoint = [_group,0];
_waypoint setwaypointbehaviour _behaviour;
_waypoint setwaypointcombatmode _combat_mode;
_waypoint setwaypointspeed _speed;

_count = (count _positions) - 1;

for "_i" from 1 to _count do {
	(_group addwaypoint [((_positions select _i) call CBA_fnc_getpos), 0]) setwaypointcompletionradius _radius;
};

[_group,_vehicle,_count + 1] spawn {
	private ["_group","_vehicle","_count"];
	_group = _this select 0;
	_vehicle = _this select 1;
	_count = _this select 2;
	
	while {true} do {
		if ({alive _x} count (units _group) == 0) exitwith {
			sleep 300;
			_group call CBA_fnc_deleteentity;
		};
		if ((currentwaypoint _group == _count)) exitwith {
			_group call CBA_fnc_deleteentity;
			deletevehicle _vehicle;
		};
	};
};

CRBPROFILERSTOP
