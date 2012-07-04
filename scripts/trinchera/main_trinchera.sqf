//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////


// [unidad afectada poer el script, zona interior, zona exterior, postura]
/*

zona interior: una vez el enemigo penetre esta zona la unidad tiene libertad de movimiento
zona exterior: una vez el enemigo haya sido detectado la unidad se pone en alerta e inicia el bucle de posturas definido en postura

postura = "tierra/rodillas"
postura = "tierra/dePie"
postura = "rodillas/dePie"

_marker : marcador que se le pasará al UPSMON cuando se haya penetrado la zona interior

_tipo = "fortify"
_tipo = "move" 
*/

/*
-volver a estado de espera
*/

if (isServer) then {
///////////ESTABLECER CENTINELAS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_establecer_centinelas = {
		_grupo = _this select 0;
		_baja = _this select 1;
		_alta = _this select 2;
		
		//Se definen los centinelas de cada sector y todos los miembros están en modo espera
		_centinela_n = objNull;
		_centinela_n_alt = objNull;
		_centinela_w = objNull;
		_centinela_w_alt = objNull;
		_centinela_e = objNull;
		_centinela_e_alt = objNull;
		_centinela_s = objNull;
		_centinela_s_alt = objNull;
		{
			_azimut = getDir _x;
			if (_azimut > 316 or (_azimut >= 0 and _azimut < 46)) then {
				private "_altura";
				_altura = (getPos _x) select 2;
				if(not isNull _centinela_n) then {
					if (_altura > _centinela_n_alt) then {_centinela_n = _x;_centinela_n_alt = _altura;};
				} else {
					_centinela_n = _x;_centinela_n_alt = _altura;
				};
			} else {
				if (_azimut > 225 and _azimut <= 316) then {
					private "_altura";
					_altura = (getPos _x) select 2;
					if(not isNull _centinela_w) then {
						if (_altura > _centinela_w_alt) then {_centinela_w = _x;_centinela_w_alt = _altura;};
					} else {
						_centinela_w = _x;_centinela_w_alt = _altura;
					};
				} else {
					if (_azimut >= 46 and _azimut <= 135) then {
						private "_altura";
						_altura = (getPos _x) select 2;
						if(not isNull _centinela_e) then {
							if (_altura > _centinela_e_alt) then {_centinela_e = _x;_centinela_e_alt = _altura;};
						} else {
							_centinela_e = _x;_centinela_e_alt = _altura;
						};
					} else {
						if (_azimut > 135 and _azimut <= 225) then {
							private "_altura";
							_altura = (getPos _x) select 2;
							if(not isNull _centinela_s) then {
								if (_altura > _centinela_s_alt) then {_centinela_s = _x;_centinela_s_alt = _altura;};
							} else {
								_centinela_s = _x;_centinela_s_alt = _altura;
							};
						};
					};
				};
			};
			
			if (_x == _centinela_n or _x == _centinela_w or _x == _centinela_e or _x == _centinela_s) then {
				_x setUnitPos _alta;
			} else {
				_x setUnitPos _baja;
			};
			
			_x setSkill ["aimingAccuracy",0.35];
			_x setSkill ["aimingSpeed",1];
			_x setSkill ["spotTime",1];
			_x setSkill ["spotDistance",1];

			_x disableAI "MOVE";
			_x disableAI "FSM";
			
			_x setBehaviour "AWARE";
			
			//Si no es centinela
			if (_x != _centinela_n and _x != _centinela_w and _x != _centinela_e and _x != _centinela_s) then {
				[_x] spawn {
					private "_x";
					sleep 1; //espera a que la unidad complete la animacion
					_x disableAI "ANIM";
					_x disableAI "AUTOTARGET";
					_x disableAI "TARGET";
				};
			};
		} forEach units _grupo;
	};
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	_unit = _this select 0;
	_trigger_int = _this select 1;
	_postura = _this select 2;
	_marker = _this select 3;
	_tipo = _this select 4;

	_grupo = group _unit;
	
	_baja = "";
	_alta = "";

	switch (_postura) do 
	{
		case "tierra/rodillas" : {_baja = "DOWN";_alta = "MIDDLE";}; 
		case "tierra/dePie" : {_baja = "DOWN";_alta = "UP";}; 
		case "rodillas/dePie" : {_baja = "MIDDLE";_alta = "UP";}; 
		default {};
	};
	
	/////////////////////////////
	
	[_grupo,_baja,_alta] spawn _establecer_centinelas;
	
	{
		_EH_unidad_tocada = _x addEventHandler ["Hit", {[_this select 0,_this select 1,_this select 2] execVM "scripts\trinchera\handlerUnidadHerida.sqf"}];
		_x setVariable ["EH_unidad_tocada",_EH_unidad_tocada];
		_EH_unidad_asesinada = _x addEventHandler ["Killed", {[_this select 0,_this select 1,group (_this select 2)] execVM "scripts\trinchera\handlerUnidadAsesinada.sqf"}];
		_x setVariable ["EH_unidad_asesinada",_EH_unidad_asesinada];
	} forEach units _grupo;
	
	waitUntil{{alive _x} count (units _grupo) > 0};
	//El grupo permanece en las trincheras. Puede aguantar el ataque enemigo y aún quedan unidades vivas.
	while {not (_trigger_int getVariable ["activado",false]) and {alive _x} count (units _grupo) > 0} do {
		if(behaviour (leader _grupo) == "COMBAT")then{
			//Preparación para el combate
			if ({alive _x} count (units _grupo) > 0) then {
				{
					if (alive _x) then {
						_x enableAI "AUTOTARGET";
						_x enableAI "TARGET";
						_x enableAI "ANIM";
						_x setCombatMode "RED";
						_x setUnitPos _baja;
						_x setVariable ["t_ult_anim",time];
					};
				} forEach units _grupo;
			};
			//Fin preparación para el combate
			//Combatiendo
			while{(behaviour (leader _grupo) == "COMBAT") and not (_trigger_int getVariable ["activado",false]) and {alive _x} count (units _grupo) > 0}do{
				{
					if (alive _x and (time-(_x getVariable "t_ult_anim")) > (4 + (random 3))) then {		 
						if (unitPos _x == _baja and not (_x getVariable["herida",false])) then {
							_x enableAI "AUTOTARGET";
							_x enableAI "TARGET";
							_x setUnitPos _alta;
						} else {
							_x setUnitPos _baja;
							_x disableAI "AUTOTARGET";
							_x disableAI "TARGET";
						};
						_x setVariable ["t_ult_anim",time];
						sleep 0.2;
					};
				} forEach units _grupo;
			};
			//Fin combate
			//El grupo vuelve a la calma y espera
			if(not (_trigger_int getVariable ["activado",false]) and {alive _x} count (units _grupo) > 0) then {
				[_grupo,_baja,_alta] spawn _establecer_centinelas;
			};
		};
		sleep 1;
	};

	//Ya no son necesarios estos eventhandlers porque las unidades que están vivas abandonan las trincheras
	{
		_x removeEventHandler ["Killed", _x getVariable "EH_unidad_tocada"];
		_x removeEventHandler ["Hit", _x getVariable "EH_unidad_asesinada"];
	} forEach units _grupo;
	
	//El grupo ha caido por completo o los enemigos han penetrado las defensas. Si todavía queda alguna unidad viva, el grupo abandona las trincheras y ejecuta UPSMON
	if ({alive _x} count (units _grupo) > 0) then {
		_lider = leader _grupo;
		if (alive _lider) then {
			switch (_tipo) do 
			{		
				case "fortify" : {[_lider,_marker,"nomove","nofollow","delete:",100,"fortify","noveh","spawned"] execVM "scripts\upsmon.sqf";}; 
				case "move" : {[_lider,_marker,"move","delete:",100,"spawned"] execVM "scripts\upsmon.sqf";}; 
				default {};
			};
		};
		
		{
			if (alive _x) then {
				_x enableAI "AUTOTARGET";
				_x enableAI "TARGET";
				_x enableAI "MOVE";
				_x enableAI "ANIM";
				_x enableAI "FSM";
			};
		} forEach units _grupo;
	};
	/////////////////////////////
};