//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////

_zona = _this select 0;
_unidad = _this select 1;
_esta_dentro = false;
_lista_trigger = list _zona;
if (_unidad in _lista_trigger) then {_esta_dentro = true;}
else {
	_size = count _lista_trigger;
	for [{_i = 0},{_i < _size and not _esta_dentro},{_i =_i + 1}] do {
		_elem = _lista_trigger select _i;
		if (_elem isKindOf "LandVehicle") then {
			if (_unidad in (crew _elem)) then {_esta_dentro = true;};
		};
	};
};

_esta_dentro