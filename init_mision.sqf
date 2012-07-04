//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////

//PENDIENTE
/*

*/

//muñeco prueba
//this addWeapon "ACE_map"; this addweapon "itemgps";this allowDamage false;this setCaptive true;this addMagazine "PipeBomb";this addWeapon "Binocular";onMapSingleClick "player setPos _pos"

if (!isDedicated) then {
	waitUntil {not (isNull player)};
	//Borrar marcadores UPSMON
	_marcadores = ["area1","area2","area3","area4","area5","area6","area7","area8","area9","area10","area11","area12","area13","area14","area15","area16","area17","area18",
	"area19","area20","area21","area22","area23","area24","area25","area26","area27","area28","area29","area30","area31","area32","area33","area34",
	"area35","area36","area37","area38","area39","area40","area41","area42","area43","area44","area45","area46","area47","area48","area49","area50",
	"area51","area52","area53","area54","area55","area56","area57","area58","area59","area60"];
	{_x setMarkerAlpha 0;} forEach _marcadores;
	
	//Configuración clima, distancia visión...
	0 setOvercast 0;
	0 setRain 0;
	0 setFog 0;
	
	missionNamespace setVariable ["ace_viewdistance_limit",10000];
	setViewDistance 2000;
	ace_settings_enable_vd_change = true;
	
	
	//briefing
	execVM "scriptsMision\briefing.sqf";
	
	//Quitar/poner equipo al player, radios y soportes
	//Material básico
	[] spawn {
		player addWeapon "ACE_Map";
		//Espera a que comience la misión
		waitUntil {time > 0};
		[player, "ALL"] call ACE_fnc_RemoveGear;
		removeAllWeapons player;
		removeAllItems player;
		removeBackPack player;
		//Ahora la unidad está completamente vacía
		player addWeapon "ACE_AssaultPack_BAF";
		player addWeapon "ItemCompass";
		player addWeapon "ItemWatch";
		player addWeapon "ACE_Map";
		player addWeapon "ACE_KeyCuffs";
		player addWeapon "ACE_Earplugs";
		player addWeapon "ACE_GlassesLHD_glasses";
		player addWeapon "ACRE_PRC148_UHF";	
	};
	
	//Deshabilitar "Artillery Computer"
	enableEngineArtillery false;
	
	//["ACRE_PRC148_UHF"] call acre_api_fnc_setItemRadioReplacement;
	
	[] spawn {
		_tieneRadioGrande = compile preprocessFileLineNumbers "scripts\ACRE\tieneRadioGrande.sqf";
		while {true} do {
			waitUntil{sleep 2; [] call _tieneRadioGrande;};
			_action = player addAction ["<t color='#f0FE9A2E'>Pedir Soporte Aereo</t>",'Scripts\apoyo\SoporteAereo\Accion.sqf',0,0,false,  false,"","_target == _this"];
			waitUntil{sleep 2;not ([] call _tieneRadioGrande);};
			player removeAction _action;
		};
	};
	
	//Radio Mando suministros *pendiente*
	//_actionRadioMando = radioMando addAction ["<t color='#f0FE9A2E'>Pedir suministros</t>",'suministros.sqf',[heliSuministros,position heliPadBastion,position heliPadRoyal,5,caja_suministros],0,false, true,"","true"];
	
// [] spawn {
	// sleep 12;
	// _total_enemigos = 0;
	// {if (_x isKindOf "SoldierEB") then {_total_enemigos = _total_enemigos + 1;};} forEach allUnits;
	// 4 cutText [str(_total_enemigos),"PLAIN",2];
// };

	//Crea luces base
	[] spawn {
		_luces_base = ["luz_base_1","luz_base_2","luz_base_3","luz_base_4","luz_base_5","luz_base_6","luz_base_7","luz_base_8","luz_base_9","luz_base_10",
		"luz_base_11","luz_base_12","luz_base_13","luz_base_14","luz_base_15","luz_base_16","luz_base_17","luz_base_18","luz_base_19","luz_base_20","luz_base_21","luz_base_22","luz_base_23",
		"luz_base_24","luz_base_25","luz_base_26","luz_base_27","luz_base_28","luz_base_29","luz_base_30"];
		{
			//if (not (isNil _x)) then {
				_luz  = "#lightpoint" createVehicleLocal [markerPos _x select 0,markerPos _x select 1,2];
				_luz setLightBrightness 0.05;
				_luz setLightColor[1.0, 1.0, 1.0];
				_luz setLightAmbient[1.0, 1.0, 1.0];
			//};
		} forEach _luces_base;
	};
	
	//Cuando JO_finalTalibanesTomanBase -> mensaje al player
	[] spawn {
		waitUntil{sleep 2;not (isNil "JO_finalTalibanesTomanBase")};
		0 cutText ["Los talibanes han tomado Camp Royal. Campaña fallida.","PLAIN",2];
		sleep 5;
		endMission "END1";
	};
	
	//Mensaje alarma
	// [] spawn {
		// sleep 3;
		// [West,"HQ"] SideChat "A toda la malla, aquí Camp Royal. Hay grupos de talibanes acercandose a la base por este y sureste, Fin.";
	// };
	
//Para ver la clase del objeto que apuntas
// [] spawn {
	// while {true} do {
		// 0 cutText [str(typeOf cursorTarget),"PLAIN",2];
		// sleep 0.5;
	// };
// };
};

if (isServer) then {
	//Sincroniza todas las unidades jugables con el módulo del UAV
	[] spawn {
		JO_modulo_uav synchronizeObjectsAdd playableUnits; //playableUnits en SP devuelve un array vacío
	};

	//Cajas y cargos
	caja_baf_rucks_radios execVM "scripts\cratesAndCargo\baf_rucks_radios.sqf";
	caja_baf_medic execVM "scripts\cratesAndCargo\baf_medic.sqf";
	caja_baf_explosivos execVM "scripts\cratesAndCargo\baf_explosivos.sqf";
	caja_baf_varios execVM "scripts\cratesAndCargo\baf_varios.sqf";
	
	///////Llena las mesas de armamento
	[mesa_1,caja_1,"BAF_L110A1_Aim",4,[["ACE_200Rnd_556x45_T_M249",19]]] execVM "scripts\cratesAndCargo\armamentoVisible.sqf";
	[mesa_2,caja_2,"BAF_L7A2_GPMG", 4,[["100Rnd_762x51_M240", 29]]] execVM "scripts\cratesAndCargo\armamentoVisible.sqf";
	[mesa_8,caja_8,"ACE_Javelin_CLU", 2,[]] execVM "scripts\cratesAndCargo\armamentoVisible.sqf";
	[mesa_9,caja_9,"ACE_Javelin_Direct", 3,[]] execVM "scripts\cratesAndCargo\armamentoVisible.sqf";
	[mesa_10,caja_10,"ACE_M72A2", 12,[]] execVM "scripts\cratesAndCargo\armamentoVisible.sqf";
	[mesa_11,caja_11,"BAF_NLAW_Launcher", 2,[]] execVM "scripts\cratesAndCargo\armamentoVisible.sqf";
	[mesa_12,caja_12,"ACE_L9A1", 4,[["ACE_13Rnd_9x19_L9A1", 80]]] execVM "scripts\cratesAndCargo\armamentoVisible.sqf";
	[mesa_13,caja_13,"ACE_P226", 4,[["ACE_15Rnd_9x19_P226", 80]]] execVM "scripts\cratesAndCargo\armamentoVisible.sqf";
	
	/////Llena los armeros de armamento y sus cajas correspondientes
	[rack,"BAF_L85A2_UGL_Holo",11] execVM "scripts\cratesAndCargo\armamentoRack0.sqf";
	[caja_3,true,[["ACE_30Rnd_556x45_T_Stanag", 100],["1Rnd_HE_M203", 35],["ACE_HuntIR_M203", 10]]] execVM "scripts\cratesAndCargo\addCargoGlobal.sqf";
	
	[rack_1,"BAF_L85A2_UGL_Holo",11] execVM "scripts\cratesAndCargo\armamentoRack180.sqf";
	[caja_4,true,[["ACE_30Rnd_556x45_T_Stanag", 100],["1Rnd_HE_M203", 35],["ACE_HuntIR_M203", 10]]] execVM "scripts\cratesAndCargo\addCargoGlobal.sqf";
	
	[rack_2,"BAF_L85A2_UGL_ACOG",4] execVM "scripts\cratesAndCargo\armamentoRack0.sqf";
	[caja_6,true,[["ACE_30Rnd_556x45_T_Stanag", 39],["1Rnd_HE_M203", 21],["ACE_HuntIR_M203", 10]]] execVM "scripts\cratesAndCargo\addCargoGlobal.sqf";
	
	[rack_3,"BAF_L86A2_ACOG",2] execVM "scripts\cratesAndCargo\armamentoRack180.sqf";
	[caja_7,true,[["ACE_30Rnd_556x45_T_Stanag", 17]]] execVM "scripts\cratesAndCargo\addCargoGlobal.sqf";
	
	[rack_4,"BAF_LRR_scoped",2] execVM "scripts\cratesAndCargo\armamentoRack180.sqf";
	[caja_5,true,[["5Rnd_86x70_L115A1", 24],["ACE_5Rnd_86x70_T_L115A1", 38]]] execVM "scripts\cratesAndCargo\addCargoGlobal.sqf";
	
	//Recuento trigger camp royal
	[] spawn {
		_contar_unidades = compile preprocessFileLineNumbers "scripts\zonas\contar_unidades.sqf";
		while{true}do{
			bluforCampRoyal = [trgCampRoyal,"SoldierWB"] call _contar_unidades;
			opforCampRoyal = [trgCampRoyal,"SoldierEB"] call _contar_unidades;
			sleep 20;
		};
	};
	
	//Cuando talibanes toman base->final
	[] spawn {
		waitUntil{not (isNil "bluforCampRoyal") and not (isNil "opforCampRoyal")};
		waitUntil{sleep 20;bluforCampRoyal == 0  and opforCampRoyal > 0};
		JO_finalTalibanesTomanBase = true;
	};
	
	//Suministros
	//[heliSuministros,position heliPadBastion,position heliPadRoyal,1200,caja_suministros] execVM "scriptsMision\suministros.sqf";
	//[heliSuministros,position heliPadBastion,position heliPadRoyal,5,caja_suministros] execVM "scriptsMision\suministros.sqf";
	
	//Target puerta
	[] spawn {
		_puerta = getPos doorTargetEast nearestObject 19994;
		waitUntil{sleep 2;not alive _puerta};
		deleteVehicle doorTargetEast;
	};
};



