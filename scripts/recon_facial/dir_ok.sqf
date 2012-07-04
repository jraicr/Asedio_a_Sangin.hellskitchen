//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////


//_dir_player = round (getDir (_this select 0));
_dir_player = round(([_this select 0] call CBA_fnc_HeadDir) select 0);
//hintSilent str(_dir_player);
//_dir_object = round (getDir (_this select 1));
_dir_object = (([_this select 1] call CBA_fnc_modelHeadDir) select 0);
//hintSilent str(_dir_object);
//_dir_object = (([_this select 1] call CBA_fnc_HeadDir) select 0);

//Angulos máximos a derecha e izquierda 
//respecto la orientacion del objetivo que permiten ver su nombre
_rango = round (_this select 2);

private ["_tope_alto", "_tope_bajo"];

if (_dir_player >= 180) then {
	_dir_player = _dir_player - 180;						
} else {
	_dir_player = _dir_player + 180;
};

if (_dir_object >= (360 - _rango)) then {
	_tope_alto = _dir_object - (360 - _rango);						
} else {
	_tope_alto = _dir_object + _rango;
};

if (_dir_object < _rango) then {
	_tope_bajo = _dir_object + (360 - _rango);						
} else {
	_tope_bajo = _dir_object - _rango;
};

if (not (_tope_alto > _tope_bajo)) then {
	_dif = _tope_alto;
	_tope_alto = 359;
	_tope_bajo = _tope_bajo - (_dif + 1);
	if (_dif >= _dir_player) then {
		_dir_player = _dir_player + (360 - (_dif + 1));
	} else {
		_dir_player = _dir_player - (_dif + 1);	
	};	
};

//hintSilent format["Player(invertido): %1\nTarget: %2\nTope bajo: %3\nTope alto: %4",_dir_player,_dir_object,_tope_bajo,_tope_alto];

_dir_ok = _dir_player >= _tope_bajo and _dir_player <= _tope_alto;

_dir_ok