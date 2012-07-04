//[mesa,caja,"ClassName Weapon",cantidad weapon,[["className magazine",cantidad municion],[....,....]]] execVM "...\armamentoVisible.sqf"


if(isServer) then {

	_mesa = _this select 0;
	_caja = _this select 1;
	_classname_Weapon = _this select 2;
	_cantidad_Weapon = _this select 3;
	_magazines = _this select 4;
	
	
	[-2, {_mesa enableSimulation false;}] call CBA_fnc_globalExecute;
	
	//Calcula la separación en los ejes x e y
	_separacion_h = 0.3; //hipotenusa
	_angulo_xh = 90 - (getDir _mesa + 90);
	_separacion_y = _separacion_h*(sin _angulo_xh);
	_separacion_x = _separacion_h*(cos _angulo_xh);
	 
	
	_i = 0;
	_inc_x = 0;
	_inc_y = 0;
	_girada = 0;
	while {_i < _cantidad_Weapon} do{
		_Weapon_Holder = "WeaponHolder" createVehicle (getPos _mesa);
		_Weapon_Holder setPos [(getPos _mesa select 0) + _inc_x - _separacion_x*2.2, (getPos _mesa select 1) + _inc_y - _separacion_y*2.2, (getPos _mesa select 2) + 0.81];
		if(_girada == 0) then {
			_Weapon_Holder setDir (getDir _mesa + 90);
			_girada = 1;
		} else {
			_Weapon_Holder setDir (getDir _mesa + 90 + 180);
			_girada = 0;
		};
		_Weapon_Holder addWeaponCargoGlobal [_classname_Weapon, 1];
		_inc_x = _inc_x + _separacion_x;
		_inc_y = _inc_y + _separacion_y;
		_i = _i + 1;
	};
	
	_caja setPos [(getPos _mesa select 0) + _inc_x + _separacion_x*0.8 - _separacion_x*2.2, (getPos _mesa select 1) + _inc_y + _separacion_y*0.8 - _separacion_y*2.2, (getPos _mesa select 2) + 0.81];
	_caja setDir (getDir _mesa + 90);
	
	if(count _magazines == 0) then {
		deleteVehicle _caja;
	} else {
		clearMagazineCargoGlobal _caja;
		clearWeaponCargoGlobal _caja;
		{
			_caja addMagazineCargoGlobal [_x select 0, _x select 1];
		} forEach _magazines;
	};
	

};


