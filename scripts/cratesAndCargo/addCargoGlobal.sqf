//[caja,[["className magazine",cantidad municion],[....,....]]] execVM "...\addCargoGlobal.sqf"


if(isServer) then {
	_caja = _this select 0;
	_vaciar = _this select 1;
	_municiones = _this select 2;
	
	if (_vaciar) then {
		clearMagazineCargoGlobal _caja;
		clearWeaponCargoGlobal _caja;
	};
	
	if(count _municiones > 0) then {
		{
			_caja addMagazineCargoGlobal [_x select 0, _x select 1];
		} forEach _municiones;
	} ;
};