//

_heli  = _this select 0;
_origen = _this select 1;
_destino = _this select 2;
_delay = _this select 3;
_caja = _this select 4;

_tDescarga = 300; //tiempo que se toma para descargar material
sleep _delay;

waitUntil{sleep 2;(alive _heli) && (unitReady _heli)};

_heli move _destino;

waitUntil{sleep 2;not (alive _heli) or (unitReady _heli)};

if(alive _heli)then{
	_heli land "LAND";
	waitUntil{sleep 1;(getPosATL _heli select 2) < 1};
	sleep _tDescarga;
	///////////////////////////////////////////////
	//_caja addWeaponCargoGlobal ["ACE_PRC119_ACU", 1];
	//////////////////////////////////////////////
	if(alive _heli)then{
		waitUntil{unitReady _heli};
		_heli move _origen;
		waitUntil{!(unitReady _heli) or not (alive _heli)};
		if(alive _heli)then{
			waitUntil{(unitReady _heli) or not (alive _heli)};
			if(alive _heli)then{
				_grp_heli = group _heli;
				{deleteVehicle _x} forEach (crew _heli);
				deleteVehicle _heli;
				deleteGroup _grp_heli;
			};
		};
	};
};

