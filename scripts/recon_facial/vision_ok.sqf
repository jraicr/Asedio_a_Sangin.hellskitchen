//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////



_vision_ok = false;

_mes = (_this select 0) - 1;

if (daytime >= (((_this select 1) select _mes) select 0) and daytime <= (((_this select 1) select _mes) select 1)) then {
	if (currentVisionMode player != 2) then {
		_vision_ok = true;
	};
	
} else {
	if (currentVisionMode player == 1) then {
		_vision_ok = true;
	};
};

_vision_ok