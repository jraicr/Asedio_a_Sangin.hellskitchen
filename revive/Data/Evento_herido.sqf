private ["_Asesino","_parametros","_idJugador"];


if (Colum_revive_VidasLocal !=1000) then {
	//One live less
	Colum_revive_VidasLocal=Colum_revive_VidasLocal-1;
	_idJugador = getPlayerUID player;
	['colum_revive_UPL', [_idJugador,Colum_revive_VidasLocal]] call CBA_fnc_globalEvent;
};

if (Colum_revive_VidasLocal <= 0) exitwith {};
Colum_revive_Count_Start_Time=time;

sleep 0.5;// Wait for hit event ( sometimes this event was faster than hit event so no propper attacker was detected)
//Count down while uncons
ace_sys_spectator_can_exit_spectator=false;
//[] spawn { sleep ace_sys_spectator_RevShowButtonTime; BotonesRevive=true; call Colum_Revive_CambiarBotones };

_parametros=[player,playerside];
_Asesino = [] call Colum_revive_JugadorComprobarTK;

if (!isnil "_Asesino") then { _parametros=_parametros +[_Asesino]};


//Turn off the vehicle engine if this player was the driver, this will avoid "ghost choppers"( death pilot and auto-hover ON)^^.
if ((vehicle player!=player)&&((driver(vehicle player))== player)) then {[] spawn {sleep 10;player action ["engineOff",(vehicle player)]}}; 


['colum_revive_DeadP', _parametros] call CBA_fnc_globalEvent;


While { ((player getVariable "ace_w_revive") > 0) && (alive player)} do {call Revive_NuevoLider; call Revive_CheckRespawn;[] spawn Colum_Revive_Funcion_WaterAction; sleep 9;};

//Restore mapclick event(spectator removes it)
if (!isnil"EventoMapClick") then {
	[] spawn 
	{
		if (ace_sys_spectator_SPECTATINGON) then 
		{ waitUntil {!ace_sys_spectator_SPECTATINGON}};
		sleep 2; waitUntil {!isNull player}; onMapSingleClick EventoMapClick;
	};
};
if (!alive player) then {waitUntil {alive player}};
call Revive_RenombraLider;
if (Colum_revive_Levanta_Heal) then {-1 spawn Colum_Revive_Acciones};
[1,0] call Colum_Revive_Funcion_Message;

if (Colum_revive_VidasLocal <= 1) then{
		ace_wounds_prevtime = 0;	
}; // ToDo: check if this new method for last life can cause conflicts with ACE wounds.

if (isnil 'ace_sys_wounds_withSpect') then {
	if(dialog) then{closedialog 0};
};