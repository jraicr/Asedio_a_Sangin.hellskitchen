Private ["_caller","_dir","_dist","_list","_objectivo","_posObjectivo","_pos","_objectivoFijado","_avion",
"_PosOrgAvion","_PosDestinoAvion","_TiempoRecarga"];
_caller=_this select 0;
_dir=_this select 1;
_dist=_this select 2;

_TiempoRecarga=120;//Tiempo en segundos entre peticiones de soporte para limitarlo en tiempo
_TotalSoportes=2;//total de numero de peticiones (no se cuentan las abortadas) disponibles



if (!isServer) exitwith{};
if (isnil "Colum_soporte_En_camino") then {Colum_soporte_En_camino=false};
if (isnil "Colum_Last_Soporte") then {Colum_Last_Soporte=0};
if (isnil "Colum_Total_Soporte") then {Colum_Total_Soporte=_TotalSoportes};
if (Colum_soporte_En_camino) exitwith{[-1,{[playerSide, "HQ"] sideChat "Negativo, no hay soporte aereo disponible."},[]] call CBA_fnc_globalExecute;};
if (Colum_Last_Soporte > time) exitwith{[-1,{[playerSide, "HQ"] sideChat "Negativo, no hay soporte aereo disponible. Estamos reamunicionando"},[]] call CBA_fnc_globalExecute;};
if (Colum_Total_Soporte <= 0) exitwith{[-1,{[playerSide, "HQ"] sideChat "Negativo, no tenemos mas municion disponible"},[]] call CBA_fnc_globalExecute;};
Colum_Last_Soporte=time +_TiempoRecarga;
Colum_soporte_En_camino=true;

colum_Fnc_CalcPos={
	Private ["_orgPos","_direccion","_distancia","_return"];
	_orgPos=_this select 0;_direccion=_this select 1;_distancia=_this select 2;
	_return = [(_orgPos select 0) + _distancia*sin _direccion, (_orgPos select 1) + _distancia*cos _direccion, _orgPos select 2];
	_return;
};
colum_Fnc_Bombas_fuera={
	Private ["_posBomba","_dirBomba","_TmpLogica","_TmpPos"];
	_posBomba=_this select 0;
	_dirBomba=_this select 1;
	_dirBomba=_dirBomba+90;
	//_TmpLogica="logic" createvehicle _posObjectivo;
	sleep 5;
	//_TmpLogica say3d "Sonido Caer Bombas";//faltaria un sonido aqui
	sleep 5;
	
	_explosive = "ARTY_R_227mm_HE" createVehicle _posBomba;
	_explosive setDamage 1;
	_posBomba set [2,20];
	"BO_GBU12_LGB" createVehicle _posBomba;
	_TmpPos=([_posBomba,_dirBomba+90,30] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 10];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,_dirBomba,-30] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 10];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,(_dirBomba +90),15] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 10];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,(_dirBomba -90),15] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 10];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	
	_TmpPos=([_posBomba,_dirBomba ,50] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,_dirBomba ,-50] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,_dirBomba ,75] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,_dirBomba ,-75] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	
	_TmpPos=([_posBomba,(_dirBomba+15) ,50] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,(_dirBomba-15) ,50] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,(_dirBomba+15) ,-50] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	_TmpPos=([_posBomba,(_dirBomba-15) ,-50] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	
	_TmpPos=([_posBomba,_dirBomba ,80] call colum_Fnc_CalcPos);
	_TmpPos set [2,random 15];
	"BO_GBU12_LGB" createVehicle _TmpPos;
	Colum_Total_Soporte=Colum_Total_Soporte-1;

	deletevehicle _TmpLogica;		
};


_list= [];
_list1=(getpos _caller) nearObjects ['SMOKESHELLRED',600];
sleep 0.5;
_list2=(getpos _caller) nearObjects ['G_40mm_Smokered',600];
_list=_list1+_list2;

[-1,{[playerSide, "HQ"] sideChat format["Soporte aereo en camino, objetivo humo rojo , rumbo: %1, distancia: %2",_this select 0,_this select 1 ]}, [_dir,_dist]] call CBA_fnc_globalExecute;

if ((count _list) > 0)then
{
	_objectivo=_list select 0;
	_pos=getpos _objectivo;
	_posObjectivo=[_pos,_dir,_dist] call colum_Fnc_CalcPos;
	_objectivoFijado=true;
} else {
	_objectivoFijado=false;
	_posObjectivo =getpos _caller;
};


_PosOrgAvion=[_posObjectivo,(_dir +90),8000] call colum_Fnc_CalcPos;
_PosOrgAvion set [2,600];
	
_PosDestinoAvion=[_posObjectivo,_dir-90,8000] call colum_Fnc_CalcPos;
_PosDestinoAvion set [2,600];


colum_LLegando_Soporte=false;
colum_Fin_Soporte=false;
_sv = [_PosOrgAvion, 0, "F35B", WEST] call BIS_fnc_spawnVehicle;
_avion = _sv select 0;
_avion flyInHeight 600;
_avion allowdamage false;
_avion setcaptive true;
_wp1 = (group _avion) addWaypoint [_posObjectivo, 10]; 
_wp1 setWaypointType "MOVE"; 
_wp1 setWaypointSpeed "NORMAL"; 
_wp1 setWaypointBehaviour "CARELESS";  // set to "CARELESS" if trouble with enemys distracting heli. 
_wp1 setWaypointCombatMode "BLUE";
_wp1 setWaypointStatements ["true", ""];
_wp1 setWaypointStatements ["true", "colum_LLegando_Soporte=true;"];

_wp2 = (group _avion) addWaypoint [_PosDestinoAvion, 10]; 
_wp2 setWaypointType "MOVE"; 
_wp2 setWaypointSpeed "NORMAL"; 
_wp2 setWaypointBehaviour "CARELESS";
_wp2 setWaypointCombatMode "BLUE";
_wp2 setWaypointStatements ["true", ""];
_wp2 setWaypointStatements ["true", "colum_Fin_Soporte=true;"];

(group _avion) setCurrentWaypoint _wp1;

_timeout=time +200;
waituntil{colum_LLegando_Soporte || (time > _timeout)};

if (_objectivoFijado)then
{
	[-1,{[playerSide, "HQ"] sideChat "Bombas fuera"}, []] call CBA_fnc_globalExecute;
	[_posObjectivo,_dir] call colum_Fnc_Bombas_fuera;
} else {
	//Si no vio el humo al salir, buscamos otra vez al llegar
	_list= [];
	_list1=(getpos _caller) nearObjects ['SMOKESHELLRED',600];
	sleep 0.5;
	_list2=(getpos _caller) nearObjects ['G_40mm_Smokered',600];
	_list=_list1+_list2;

	if ((count _list) > 0)then
	{
		_objectivo=_list select 0;
		_pos=getpos _objectivo;
		_posObjectivo = [_pos,_dir,_dist] call colum_Fnc_CalcPos;
		_objectivoFijado=true;
		[-1,{[playerSide, "HQ"] sideChat "Bombas fuera"}, []] call CBA_fnc_globalExecute;
		[_posObjectivo,_dir] call colum_Fnc_Bombas_fuera;
	} else {
		[-1,{[playerSide, "HQ"] sideChat "Mision abortada, no hemos avistado el objetivo"}, []] call CBA_fnc_globalExecute;
	};
	
};

_timeout=time +200;
waituntil{colum_Fin_Soporte || (time > _timeout)};

_grupo= group _avion;
_piloto= driver _avion;
_avion= vehicle _avion;
deletevehicle _avion;
deletevehicle _piloto;
sleep 2;
deletegroup _grupo;
Colum_soporte_En_camino=false;



