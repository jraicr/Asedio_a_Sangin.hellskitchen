//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: (AEF)Wolffy.au [2CAV]
// Modified by: (AEF)Odin 2010/01/04
// Created: 20090922
// Contact: http://creobellum.org
// Purpose: Crew all positions within a perimeter
// Parameter: position to search
// Parameter: Search distance
// Parameter: Side (east,west,resistance,civilian) or Group to join
///////////////////////////////////////////////////////////////////

private ["_grp","_pos","_dist","_list"];
if(!isServer) exitWith{};

_pos = _this select 0;
_dist = _this select 1;

_grp = grpNull;
if (typeName (_this select 2) == "SIDE") then {
	_grp = createGroup (_this select 2);
} else {
	_grp = _this select 2;
};

_list = _pos nearObjects ["AllVehicles", _dist];
{
	[_x, _grp] call BIS_fnc_spawnCrew;
} forEach _list;

doStop units _grp;
