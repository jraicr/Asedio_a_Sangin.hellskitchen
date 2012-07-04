_param=_this select 3;

if (_param == 0) then {
	createdialog "Colum_Soporte_Aer_Diag";
} else {
	_Parametros=[player,parseNumber(_this select 0),parseNumber(_this select 1)];
	[0,{_this execVM "Scripts\apoyo\SoporteAereo\PedirSoporte.sqf"}, _Parametros] call CBA_fnc_globalExecute;
};