#ifndef execNow
#define execNow call compile preprocessfilelinenumbers
#endif
	
waitUntil{!isNil "BIS_fnc_init"};

titleText ["Cargando...", "BLACK"];
execNow "core\init.sqf";
execNow "ambience\init.sqf";

"Completado" call mso_core_fnc_initStat;
diag_log format["Asedio Sangin-%1 Inicio completado", time];
titleText ["Carga completada", "BLACK IN"];

// JIP fix - why does ArmA execute init.sqf for JIP players, if 'player' is not sync'd yet
if ((!isServer) && (player != player)) then
{
  waitUntil {player == player};
};
/*
//Process statements stored using setVehicleInit
processInitCommands;

//Finish world initialization before mission is launched. 
finishMissionInit;

if(true) exitWith {}; 
*/