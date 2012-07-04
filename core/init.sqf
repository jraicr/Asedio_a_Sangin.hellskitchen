#ifndef execNow
#define execNow call compile preprocessfilelinenumbers
#endif

//All client should have the Functions Manager initialized, to be sure.
if (isnil "BIS_functions_mainscope") then {
	createCenter sideLogic;
    (createGroup sideLogic) createUnit ["FunctionsManager", [0,0,0], [], 0, "NONE"];
	BIS_fnc_locations = compile preprocessFileLineNumbers "CA\modules\functions\systems\fn_locations.sqf";
};

waitUntil{!isNil "BIS_fnc_init"};

diag_log format["AsedioSangin_MSO-Civiles-%1 Version: %2", time, "R4.30"];

//http://community.bistudio.com/wiki/enableSaving
enableSaving [false, false];

if(isNil "debug_mso_setting") then {debug_mso_setting = 0;};
if(debug_mso_setting == 0) then {debug_mso = false; debug_mso_loc = false;};
if(debug_mso_setting == 1) then {debug_mso = true; debug_mso_loc = false;};
if(debug_mso_setting == 2) then {debug_mso = true; debug_mso_loc = true;};
publicvariable "debug_mso";
publicvariable "debug_mso_loc";

"Localizaciones personalizadas(" + worldName + ")" call mso_core_fnc_initStat;

if(isServer) then {
	["CityCenter",[],debug_mso_loc] call BIS_fnc_locations;
	CRB_LOCS = [] call mso_core_fnc_initLocations;
};

"Garbage collector" call mso_core_fnc_initStat;

//--- Is Garbage collector running?
if (isnil "BIS_GC") then {
	BIS_GC = (group BIS_functions_mainscope) createUnit ["GarbageCollector", position BIS_functions_mainscope, [], 0, "NONE"];
};
if (isnil "BIS_GC_trashItFunc") then {
	BIS_GC_trashItFunc = compile preprocessFileLineNumbers "ca\modules\garbage_collector\data\scripts\trashIt.sqf";
};
waitUntil{!isNil "BIS_GC"};
BIS_GC setVariable ["auto", true];
