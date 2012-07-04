//[rack,"ClassName Weapon",cantidad weapon] execVM "...\armamentoVisible.sqf"


if(isServer) then {

	_JO_AR_Fila = {
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
			// _Weapon_Holder setDir _dir + 90;
		    _Weapon_Holder setVectorUp _vectorDir;
			_Weapon_Holder addWeaponCargoGlobal [_classname_Weapon, 1];
			_inc_x = _inc_x + _separacion_x;
			_inc_y = _inc_y + _separacion_y;
			_i = _i + 1;
		};
	};
	

	_JO_AR_rack = _this select 0;
	_JO_AR_classname_Weapon = _this select 1;
	_JO_AR_cantidad_Weapon = _this select 2;
	
	/*
	angulo: angulo entre la direccion del rack y la direccion de h
	h: norma de la distancia entre el centro del rack y la posición inicial de la primera arma a colocar 
	(hallado resolviendo el triangulo de la situación en que la direccion de rack es 0)
	*/
	_angulo = 37,303948277983430813101817505664;
	_h = 0.39601136347332256824151501227663;
	_offset_x = _h*sin(getDir _JO_AR_rack - _angulo);
	_offset_y = _h*cos(getDir _JO_AR_rack - _angulo);
	
	
	//dir rack 0: -0.24, + 0.315, - 0.285
	//dir rack 180: +0.33 - 0.12 - 0.285
	//[[(getPos _JO_AR_rack select 0) + _offset_x,(getPos _JO_AR_rack select 1) +_offset_y,(getPos _JO_AR_rack select 2)], getDir _JO_AR_rack,vectorDir _JO_AR_rack,0.1,_JO_AR_classname_Weapon,1] spawn _JO_AR_Fila;
	[[(getPos _JO_AR_rack select 0),(getPos _JO_AR_rack select 1),(getPos _JO_AR_rack select 2)], getDir _JO_AR_rack,vectorDir _JO_AR_rack,0.1,_JO_AR_classname_Weapon,1] spawn _JO_AR_Fila;
	 
	// _JO_AR_i = 0;
	// _JO_AR_inc_x = 0;
	// _JO_AR_inc_y = 0;
	// _JO_AR_girada = 0;
	// while {_JO_AR_i < _JO_AR_cantidad_Weapon} do{
		// _JO_AR_Weapon_Holder = "WeaponHolder" createVehicle (getPos _JO_AR_rack);
		// _JO_AR_Weapon_Holder setPos [(getPos _JO_AR_rack select 0) + _JO_AR_inc_x - _JO_AR_separacion_x*2.2, (getPos _JO_AR_rack select 1) + _JO_AR_inc_y - _JO_AR_separacion_y*2.2, (getPos _JO_AR_rack select 2) + 0.81];
		// if(_JO_AR_girada == 0) then {
			// _JO_AR_Weapon_Holder setDir (getDir _JO_AR_rack + 90);
			// _JO_AR_girada = 1;
		// } else {
			// _JO_AR_Weapon_Holder setDir (getDir _JO_AR_rack + 90 + 180);
			// _JO_AR_girada = 0;
		// };
		// _JO_AR_Weapon_Holder addWeaponCargoGlobal [_JO_AR_classname_Weapon, 1];
		// _JO_AR_inc_x = _JO_AR_inc_x + _JO_AR_separacion_x;
		// _JO_AR_inc_y = _JO_AR_inc_y + _JO_AR_separacion_y;
		// _JO_AR_i = _JO_AR_i + 1;
	// };
	
	// _JO_AV_caja setPos [(getPos _JO_AV_mesa select 0) + _JO_AV_inc_x + _JO_AV_separacion_x*0.8 - _JO_AV_separacion_x*2.2, (getPos _JO_AV_mesa select 1) + _JO_AV_inc_y + _JO_AV_separacion_y*0.8 - _JO_AV_separacion_y*2.2, (getPos _JO_AV_mesa select 2) + 0.81];
	// _JO_AV_caja setDir (getDir _JO_AV_mesa + 90);
	
	// if(count _JO_AV_magazines == 0) then {
		// deleteVehicle _JO_AV_caja;
	// } else {
		// clearMagazineCargoGlobal _JO_AV_caja;
		// clearWeaponCargoGlobal _JO_AV_caja;
		// {
			// _JO_AV_caja addMagazineCargoGlobal [_x select 0, _x select 1];
		// } forEach _JO_AV_magazines;
	// };
	

};


