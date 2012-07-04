//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////


// [unidad afectada por el script, zona interior, postura]
/*

zona interior: una vez el enemigo penetre esta zona la unidad tiene libertad de movimiento

postura = "tierra"
postura = "rodillas"
postura = "dePie"

_marker : marcador que se le pasará al UPSMON cuando se haya penetrado la zona interior

_tipo = "fortify"
_tipo = "move" 
*/

/*
*/

if (isServer) then {
///////////MODO ESPERA//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	_modo_espera = {
		_grupo = _this select 0;
		_postura = _this select 1;

		{
			_x setSkill ["aimingSpeed",1];
			_x setSkill ["spotTime",1];
			_x setSkill ["spotDistance",1];
			
			_x disableAI "MOVE";
			_x disableAI "FSM";
			
			_x setUnitPos _postura;
			[_x] spawn {
				private "_x";
				sleep 2; //espera a que la unidad complete la animacion
				_x disableAI "ANIM";
			};
			
			_x setBehaviour "AWARE";
		} forEach units _grupo;
	};
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	_unit = _this select 0;
	_trigger_int = _this select 1;
	_param_postura = _this select 2;
	_postura = "";
	if(_param_postura == "tierra") then {_postura = "DOWN"};
	if(_param_postura == "rodillas") then {_postura = "Middle"};
	if(_param_postura == "dePie") then {_postura = "UP"};
	_marker = _this select 3;
	_tipo = _this select 4;

	_grupo = group _unit;
	
	/////////////////////////////
	
	[_grupo,_postura] spawn _modo_espera;
	
	waitUntil{{alive _x} count (units _grupo) > 0};
	//El grupo permanece en la formación. Puede aguantar el ataque enemigo y aún quedan unidades vivas.
	while {not (_trigger_int getVariable ["activado",false]) and {alive _x} count (units _grupo) > 0} do {
		if(behaviour (leader _grupo) == "COMBAT")then{
			//Preparación para el combate
			if ({alive _x} count (units _grupo) > 0) then {
				{
					if (alive _x) then {
						_x setCombatMode "RED";
					};
				} forEach units _grupo;
			};
			//Fin preparación para el combate
			//Combatiendo
			waitUntil{sleep 1;(behaviour (leader _grupo) != "COMBAT") or (_trigger_int getVariable ["activado",false]) or {alive _x} count (units _grupo) == 0};
			//Fin combate
			//El grupo vuelve a la calma y espera
			if(not (_trigger_int getVariable ["activado",false]) and {alive _x} count (units _grupo) > 0) then {
				[_grupo,_postura] spawn _modo_espera;
			};
		};
		sleep 1;
	};
	
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