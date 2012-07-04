scriptName "garbage_collector\data\scripts\trashIt.sqf";
/*
	File: trashIt.sqf
	Author: Joris-Jan van 't Land

	Description:
	Sends an object to the garbage collection queue.

	Parameter(s):
	_this select 0: the object.
	
	Returns:
	Success flag (Boolean).
*/

//Valid parameter count
if (isNil "_this") exitWith {debugLog "Log: [trashIt] There should be 1 mandatory parameter!"; false};

private ["_object", "_queue", "_timeToDie"];
_object = _this select 0;

_queue = [];
if(typeName (BIS_GC getVariable "queue") == "ARRAY") then {
	_queue = BIS_GC getVariable "queue";
};

switch (typeName _object) do
{
	case (typeName objNull):
	{
		if (alive _object) then
		{
			_timeToDie = time + 30;
		}
		else
		{
			_timeToDie = time + 60;
		};
	};

	case (typeName grpNull):
	{
		_timeToDie = time + 60;
	};

	default
	{
		_timeToDie = time;
	};
};

_queue = _queue + [[_object, _timeToDie]];
BIS_GC setVariable ["queue", _queue];

true