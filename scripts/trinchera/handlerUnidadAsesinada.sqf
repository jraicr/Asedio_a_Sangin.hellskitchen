_unit = _this select 0;
_killer = _this select 1;
_grupo = _this select 2;
_bando_unit = side _unit;
_bando_killer = side _killer;

if(_unit getVariable ["disponibleEHUnidadAsesinada",true]) then{
	if((_bando_unit getFriend _bando_killer < 0.6)) then {
		_unit setVariable ["disponibleEHUnidadAsesinada",false];
		//sin implementar, preparado para posibles mejoras
		_unit setVariable ["disponibleEHUnidadAsesinada",true];
	};	
};

if (true) exitWith {};





		