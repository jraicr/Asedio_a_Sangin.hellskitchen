//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////

//En orden enero, febrero, etc. Intervalos de luz solar.
#define horas [[6.83333,17.25],[6.75,17.58333],[6.33333,17.91667],[5.66666,18.33333],[5,66666],[4.58333,19.16667],[4.58333,19.25],[4.91667,19.33333],[5.25,18.83333],[5.75,18.16667],[6.16667,17.5],[6.58333,17.16667]]
#define ruta_fotos "scripts\recon_facial\imagenes\"
_fnc_dir_ok = compile preprocessFileLineNumbers "scripts\recon_facial\dir_ok.sqf";
_fnc_dist = compile preprocessFileLineNumbers "scripts\recon_facial\dist.sqf";
_fnc_buscar_foto = compile preprocessFileLineNumbers "scripts\recon_facial\buscar_foto.sqf";

while {true} do {
	_object = cursorTarget;
	if (_object isKindOf "CAManBase") then {
		if(alive _object) then{
			_nombre = (name _object);
			_indice = [_nombre,_this] call _fnc_buscar_foto;
			if (_indice > -1) then {
			_ruta_completa = str(composeText [ruta_fotos, (_this select _indice) select 1]);
				_dist_ok = [_object,horas] call _fnc_dist;
				if (_dist_ok) then {
					_dir_ok = [player,_object,100] call _fnc_dir_ok;
					if (_dir_ok) then {
						99999 cutRsc ["JO_personaje","PLAIN DOWN",0.5];
						((JO_personaje select 0) displayCtrl 1001) ctrlSetText _nombre;
						((JO_personaje select 0) displayCtrl 1002) ctrlSetText _ruta_completa;
						while {_object == cursorTarget and alive _object and _dist_ok and _dir_ok} do {
							_dist_ok = [_object,horas] call _fnc_dist;
							_dir_ok = [player,_object,100] call _fnc_dir_ok;
							sleep 3.5;
						};
						99999 cutFadeOut 0.5;	
					};
				};
			};
		};
	};
	sleep 1.5;
};

if (true) exitWith {};



