
private["_debug","_logicCiv","_logicVeh","_logicAni"];

_debug = debug_mso;

if(isNil "ambientCivs") then {ambientCivs = 1;};
if(isNil "ambientVehs") then {ambientVehs = 1;};
if(isNil "ambientAnimals") then {ambientAnimals = 1;};

waitUntil{!isNil "BIS_fnc_init"};

if(isServer && isNil "CRB_LOCS") then {
        CRB_LOCS = [] call mso_core_fnc_initLocations;
};

if (ambientCivs == 1) then {
	if(isNil "BIS_alice_mainscope") then {
		BIS_alice_mainscope = (createGroup sideLogic) createUnit ["LOGIC", [0,0,0], [], 0, "NONE"];
	};
	if(_debug) then {
		BIS_alice_mainscope setVariable ["debug", true];
	};
	BIS_alice_mainscope setVariable ["townlist",(BIS_functions_mainscope getVariable "locations")];
	BIS_ALICE2_fnc_civilianSet = compile preprocessFileLineNumbers "ca\modules_e\alice2\data\scripts\fn_civilianSet.sqf";
	BIS_ALICE_fnc_houseEffects = compile preprocessFileLineNumbers "CA\modules\Alice\data\scripts\fnc_houseEffects.sqf";
	[] call compile preprocessFileLineNumbers "ambience\modules\crb_civilians\crB_AmbCivSetup.sqf";
	[BIS_alice_mainscope] call compile preprocessFileLineNumbers "ca\modules_e\alice2\data\scripts\main.sqf";
	if(!isDedicated) then {
		[] call compile preprocessFileLineNumbers "ambience\modules\crb_civilians\ALICE2_houseEffects.sqf";
	};
};

if(isServer) then {        
        if (isNil "BIS_silvie_mainscope" && ambientVehs == 1) then {
                _logicVeh = (createGroup sideLogic) createUnit ["LOGIC", [0,0,0], [], 0, "NONE"];
                BIS_silvie_mainscope = _logicVeh;
                private ["_ok"];
                if(_debug) then {
                        _logicVeh setVariable ["debug", true];
                };
                BIS_silvie_mainscope setVariable ["townlist",(BIS_functions_mainscope getVariable "locations")];
                _ok = [_logicVeh] execVM "ca\modules\silvie\data\scripts\main.sqf";
                [] call compile preprocessFileLineNumbers "ambience\modules\crb_civilians\crB_AmbVehSetup.sqf";
        };
        
        if (isNil "BIS_Animals_debug" && ambientAnimals == 1) then {
                _logicAni = (createGroup sideLogic) createUnit ["LOGIC", [0,0,0], [], 0, "NONE"];
                BIS_Animals_debug = _debug;
                private ["_ok"];
                _ok = [_logicAni] execVM "CA\Modules\Animals\Data\scripts\init.sqf";
        };
};

switch(toLower(worldName)) do {
        case "zargabad": {
                [] call compile preprocessFileLineNumbers "ambience\modules\crb_civilians\CIV_City.sqf";
        };
};
