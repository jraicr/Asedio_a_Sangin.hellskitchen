#include <crbprofiler.hpp>

private ["_nearest","_pos","_neighbours","_debug"];

CRBPROFILERSTART("mso_core_fnc_getNearestTown")

_pos = _this select 0;
_debug = _this select 1;

waitUntil{!isNil "bis_alice_mainscope"};
waitUntil{typeName (bis_alice_mainscope getvariable "townlist") == "ARRAY"};

_nearest = (bis_alice_mainscope getvariable "townlist") select 0;
{
		if(_nearest distance _pos > _x distance _pos) then {
				_nearest = _x;
		};
} forEach (bis_alice_mainscope getvariable "townlist");

//      _neighbours = _nearest getVariable "neighbors"; // Removed this as it was not compatible with towns without neighbours defined - was causing issues/errors.

_neighbours = [];

{
		if(_nearest distance _x < 1000) then {
				_neighbours set [count _neighbours, _x];
		};
} forEach (bis_alice_mainscope getvariable "townlist") - [_nearest];

_neighbours set [count _neighbours, _nearest];

_nearest = _neighbours call BIS_fnc_selectRandom;

if(isNil "_nearest") then {
	_nearest = (bis_alice_mainscope getvariable "townlist") select 0;
	diag_log format["MSO-%1 GetNearestTown: Nearest town not found", time];
}; 

CRBPROFILERSTOP
_nearest;