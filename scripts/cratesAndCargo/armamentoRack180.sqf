if(isServer) then {

	_crearFila = {
		private ["_pos","_dir","_separacion_h","_cantidad","_angulo_xh","_separacion_y","_separacion_x"];
		
		_pos = _this select 0;
		_dir = _this select 1; //direccion rack
		_vectorDir = _this select 2;
		_separacion_h = _this select 3; //hipotenusa
		_classname_Weapon = _this select 4;
		_cantidad = _this select 5;
		
		
		//Calcula la separación en los ejes x e y
		_angulo_xh = 90 - _dir;
		_separacion_y = _separacion_h*(sin _angulo_xh);
		_separacion_x = _separacion_h*(cos _angulo_xh);
		
		_i = 0;
		_inc_x = 0;
		_inc_y = 0;
		while {_i < _cantidad} do{
			_Weapon_Holder = "WeaponHolder" createVehicle _pos;
			_Weapon_Holder setPos [(_pos select 0) + _inc_x, (_pos select 1) + _inc_y, (_pos select 2)];
			_Weapon_Holder setDir _dir + 90;
		    _Weapon_Holder setVectorUp _vectorDir;
			_Weapon_Holder addWeaponCargoGlobal [_classname_Weapon, 1];
			_inc_x = _inc_x + _separacion_x;
			_inc_y = _inc_y + _separacion_y;
			_i = _i + 1;
		};
	};
	
	
	_rack = _this select 0;
	_classname_Weapon = _this select 1;
	_cantidad_Weapon = _this select 2;
	_separacion_armas = 0.1;
	
	//Calcula la separación en los ejes x e y
	_angulo_xh = 90 - (getDir _rack);
	_separacion_y = _separacion_armas*(sin _angulo_xh);
	_separacion_x = _separacion_armas*(cos _angulo_xh);
	
	
	_separacionFilas_x = -0.269;
	_separacionFilas_y = 0;
	
	_FilasCompletas = floor(_cantidad_Weapon / 8);
	_cantidad_Weapon = _cantidad_Weapon mod 8;
	_mediasFilasCompletas = floor(_cantidad_Weapon / 4);
	_cantidad_Weapon = _cantidad_Weapon mod 4;
	_armasSueltas = _cantidad_Weapon;
	
	_i = 0;
	while {_i < _FilasCompletas} do {
		[[(getPos _rack select 0) + 0.33 + _separacionFilas_x*_i,(getPos _rack select 1) - 0.12 + _separacionFilas_y*_i,(getPos _rack select 2) - 0.285], getDir _rack,vectorDir _rack,_separacion_armas,_classname_Weapon,4] spawn _crearFila;
		[[(getPos _rack select 0) + 0.33 + _separacionFilas_x*_i + _separacion_x*5,(getPos _rack select 1) - 0.12 + _separacionFilas_y + _separacion_y*5,(getPos _rack select 2) - 0.285], getDir _rack,vectorDir _rack,_separacion_armas,_classname_Weapon,4] spawn _crearFila;
		_i = _i + 1;
	};
	
	if (_mediasFilasCompletas == 1) then {
		[[(getPos _rack select 0) + 0.33 + _separacionFilas_x*_i,(getPos _rack select 1) - 0.12 + _separacionFilas_y*_i,(getPos _rack select 2) - 0.285], getDir _rack,vectorDir _rack,_separacion_armas,_classname_Weapon,4] spawn _crearFila;
		[[(getPos _rack select 0) + 0.33 + _separacionFilas_x*_i + _separacion_x*5,(getPos _rack select 1) - 0.12 + _separacionFilas_y + _separacion_y*5,(getPos _rack select 2) - 0.285], getDir _rack,vectorDir _rack,_separacion_armas,_classname_Weapon,_armasSueltas] spawn _crearFila;
	} else {
		[[(getPos _rack select 0) + 0.33 + _separacionFilas_x*_i,(getPos _rack select 1) - 0.12 + _separacionFilas_y,(getPos _rack select 2) - 0.285], getDir _rack,vectorDir _rack,_separacion_armas,_classname_Weapon,_armasSueltas] spawn _crearFila;
	};
	
};