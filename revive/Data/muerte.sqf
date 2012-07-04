//Script que se ejecuta cuando al jugador no le quedan mas vidas
private ["_Escuadra","_uncon","_idJugador"];


//Configuramos el spectador y si estaba en modo espectador salimos ( parece raro pero... puede pasar ...)
ace_sys_spectator_exit_spectator = true;
ace_sys_spectator_ShownSides=nil;ace_sys_spectator_maxDistance=nil;
ace_sys_spectator_CheckDist=nil; ace_sys_spectator_CheckUncon = true;
ace_sys_spectator_no_butterfly_mode = true;
ace_sys_spectator_can_exit_spectator=false;

ace_sys_spectator_playable_only = not Colum_revive_VerEnemigos;
if (!Colum_revive_VerEnemigos) then {ace_sys_spectator_ShownSides=[playerside]};


//vidas del jugador a 0 
Colum_revive_VidasLocal=0;
_idJugador = getPlayerUID player;

if ((_this select 0) ==0) then {
	['colum_revive_UPL', [_idJugador,0]] call CBA_fnc_globalEvent; // dont need to update if its a reconnect
};

//Esto pasa si pulsan respawn mientras tan con cuenta atras
if ((player getVariable "ace_w_revive") > 0) then {	player setVariable ["ace_w_revive",0]; sleep 1};

//esperamos q haga respawn si esta muerto
if (!(alive player)) then { waitUntil {alive player}};

player SetVariable ["ace_sys_wounds_uncon",true,true];
player SetVariable ["ace_sys_spectator_exclude",true];

//cambio de lider
if (Colum_revive_Death_LeaveGroup) then
{
	[player] joinsilent grpnull;
} else {
	call Revive_NuevoLider;
	if (isnil 'Revive_bucle_Control_Lider') then {
		Revive_bucle_Control_Lider=true;
		[] spawn { While {true} do { sleep 30; call Revive_NuevoLider}};
	};
};


[2,0] call Colum_Revive_Funcion_Mensage;

sleep 1.5;

//[player, player, ''] execVM 'spect\specta.sqf';
ace_sys_spectator_exit_spectator = nil;
ace_sys_spectator_RevButtons= nil;
ace_sys_spectator_RevShowButtonTime= nil;

if (!isnil "acre_api_fnc_setSpectator") then {[true] call acre_api_fnc_setSpectator};

sleep .1;

[player, player, ''] spawn ace_fnc_startSpectator;
sleep .1;
player setPos getMarkerPos "Boot_hill";
player setCaptive true;
sleep .1;
player playMoveNow "AdthPercMstpSrasWrflDb_16";
sleep .1;
player switchmove "AdthPercMstpSrasWrflDb_16";
[2,0] call Colum_Revive_Funcion_Mensage;
