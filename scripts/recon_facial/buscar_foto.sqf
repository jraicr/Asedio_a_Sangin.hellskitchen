_nombre = _this select 0;
_array = _this select 1;

_n = count _array;
encontrado = false;

_resultado = -1;

for [{_x = 0},{_x < _n and not encontrado},{_x=_x+1}] do {
	if(name ((_array select _x) select 0) == _nombre) then {
		encontrado = true;
		_resultado = _x;
	};
};

_resultado
