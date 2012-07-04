//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////


/*
arma2 blufor: "SoldierWB"
arma2 opfor: "SoldierEB"
arma2 independiente: "SoldierGB"

I44 US army: "I44_Man_A"
I44 UK: "I44_Man_B"
I44 Germany: "I44_Man_G"
I44 French resistance: "I44_Man_R"
*/

_zona = _this select 0;
_clase = _this select 1;

_cantidad = 0;

{
	if ((_x isKindOf _clase) and (alive _x)) then {_cantidad = _cantidad + 1;}
	else {
		if ((_x isKindOf "LandVehicle") and (alive _x)) then {
			{
				if ((_x isKindOf _clase) and (alive _x)) then {_cantidad = _cantidad + 1;};
			} forEach crew _x;
		};
	}
} forEach list _zona;

_cantidad