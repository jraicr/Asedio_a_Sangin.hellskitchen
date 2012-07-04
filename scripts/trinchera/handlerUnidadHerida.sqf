_unit = _this select 0;
_grupo = group _unit;
_causedBy = _this select 1;
_damage = _this select 2;
_bando_unit = side _unit;
_bando_causedBy = side _causedBy;

if(_unit getVariable ["disponibleEHUnidadHerida",true]) then{
	if((_bando_unit getFriend _bando_causedBy < 0.6)) then {
		_unit setVariable ["disponibleEHUnidadHerida",false];
		_unit setVariable ["herida",true];
		
		_tiempo = objNull;
		if(_damage > 0 and _damage < 0.4) then {
			_tiempo = 20 + (random 10);
		} else {
			if(_damage >= 0.4 and _damage < 0.8) then {
				_tiempo = 50 + (random 10);
			} else {
				_tiempo = 80 + (random 10);
			};
		};
		sleep _tiempo;
		_unit setVariable ["herida",false];
		_unit setVariable ["disponibleEHUnidadHerida",true];
	};
};

if (true) exitWith {};






		