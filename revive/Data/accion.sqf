private["_parametro","_lanzador","_Activador"];
_parametro= _this select 3;
_lanzador= _this select 0;
_Activador= _this select 1;

switch (_parametro) do 
{
	case 0: {[0,{[_this] spawn Colum_revive_HeliEvac}, getpos player ] call CBA_fnc_globalExecute};
	case 1: {[0,{_this spawn Colum_revive_HeliEvac_VueltaBase}, _lanzador ] call CBA_fnc_globalExecute};
};