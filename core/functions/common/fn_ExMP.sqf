#include <crbprofiler.hpp>

//0, All
//1, Server
//2, Clients
//3, Local
private ["_locality","_params","_code"];

CRBPROFILERSTART("mso_core_fnc_ExMP")

_locality = _this select 0;
_params = _this select 1;
_code = _this select 2;

//diag_log str [_this,((not isserver) and (_locality == 1)) , (_locality in [0,2])];
if (((not isserver) and (_locality == 1)) or (_locality in [0,2])) then {
	RMM_MPe = _this;
	publicvariable "RMM_MPe"; 
};

//diag_log str [_this,(isserver and (_locality == 1)) , (_locality in [0,3]) , ((not isdedicated) and (_locality == 2))];
if ((isserver and (_locality == 1)) or (_locality in [0,3]) or ((not isdedicated) and (_locality == 2))) then {
	if (isnil "_params") then {call _code} else {_params call _code};
};

CRBPROFILERSTOP
