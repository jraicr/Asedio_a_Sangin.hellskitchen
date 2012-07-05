// Script para IED
// Ejemplo de uso en el init del objeto IED : x= [this,70,50,30,2,false,1,3] execVM "scripts\IED\InitIED.sqf";
// Parametros 
// 1- IED
// 2- probabilidad de ser IED . 100 siempre IED, 0 ¿¿nunca?? xDD
// 3- probabilidad de desactivacion. 100 se desactiva siempre, 0 imposible de desactivar
// 4- Radio de activacion. Si 2 soldados o un vehiculo se hacercan mas de este radio, el IED explotara
// 5 - Potencia de la explosion , de 1 a 5
// 6 - Mostrar o no mostrar el mensaje en IEDs inactivos. Si se pone True, los IEDs siempre tendran la opcion de desactivar esten activos o no, si esta a false solo los IEDs activos tendran la opcion.
// 7 - Nº minimo que se pueden acercar al IED. Por ejemplo si se pone 1, solo 1 soldado se podra acercar al IED sin detonarlo.
// 8 - Tiempo aleatorio maximo antes de detonar el IED. Una vez dentro del radio de activacion y cumplidas una de las condiciones( o hay un vehiculo o mas soldados de los que deberia). Por ejemplo si se pone 4, tardara entre 0 y 4 segundos en explotar despues de acercarse un vehiculo.
// 9 - Bando. Por defecto west. Puede ser: 'west', 'east', 'resistance', 'civilian' (IMPORTATE, comillas INCLUIDAS)
//otro ejemplo x= [this,50,30,50,2,false,1,5] execVM "scripts\IED\InitIED.sqf";
//50% de ser IED, 30% de posibilidades de desactivarla, radio de activacion de 50m, si no es IED no mostrara la accion, si se acerca mas de 1 soldado detonara y tardara entre 0 y 5 segundos en detonar si 2 o mas soldados o un vehiculo se acercan.
//otro mas x= [this,70,50,30,1,true,2,3] execVM "scripts\IED\InitIED.sqf";
//70% de ser IED, 50% de posibilidades de desactivacion, radio de 30m, potencia minima(1), siempre mostrara la accion aunque no sea IED, se podran acercar 2 soldados sin detonarla y tardara 3 segundos en explotar si se acerca un vehiculo o 3 soldados o mas.

private["_IED","_IED_ID", "_radius","_probaIED","_probaDes","_vehicle","_TypoExplosivo","_TypeExplosivo","_MostrarInactivos","_Tiempo","_bando","_Soldados","_Terrorista"];
_IED = _this select 0;
_probaIED = _this select 1;
_probaDes = _this select 2;
_radius = if ((count _this) > 3) then {_this select 3} else {20};
_TypoExplosivo=if ((count _this) > 4) then {_this select 4} else {-1};
_MostrarInactivos=if ((count _this) > 5) then {_this select 5} else {true};
_Soldados=if ((count _this) > 6) then {_this select 6} else {1};
_Tiempo=if ((count _this) > 7) then {_this select 7} else {4};
_bando=if ((count _this) > 8) then {_this select 8} else {'west'};
_Terrorista=if ((count _this) > 9) then {_this select 9} else {objnull};

_TypeExplosivo=switch (_TypoExplosivo) do {
	case 1 : {'R_57mm_HE'};
	case 2 : {'Bomb'};
	case 3 : {'ARTY_Sh_81_HE'};
	case 4 : {'ARTY_Sh_105_HE'};
	case 5 : {'ARTY_R_227mm_HE'}; 
	case 6 : {'BO_GBU12_LGB'};
	case 7 : {'Especial_De_La_Casa'};
	default {'R_57mm_HE'};
};



if (isnil 'IED_fn_IsVehicle') then {call compile preprocessFileLineNumbers "Scripts\IED\FuncionesIED.sqf"};

if (isnil "ListaIEDs") then {ListaIEDs = []};
_IED_ID= count ListaIEDs;
ListaIEDs= ListaIEDs +[_IED];

if (!isDedicated) then { [_IED,_probaDes,_MostrarInactivos] call IED_Anadir_Acciones};
if (!isServer) exitWith {};

if (_probaIED <(random 100)) exitWith {}; //toca o no toca IED? ^^


// vehicles
if ([_IED] call IED_fn_IsVehicle) then
{
  _vehicle = _IED;
  
  if (!alive _vehicle) exitWith {};
  
  // detonate if engine is started
 call compile format['_vehicle addEventHandler ["engine", {if (side (driver (_this select 0)) == %1) then { [_this select 0] spawn IED_Detonar}}];',_bando];
};

//-----------------------------------------------------------------------------
// detonate if destroyed
_IED addEventHandler ["killed", { [_this select 0] spawn IED_Detonar }];

  // 35% de poss de explotar al golpear
_IED addEventHandler ["Hit", { if ((random 1) < 0.35) then {[_this select 0] spawn IED_Detonar}}];

//-----------------------------------------------------------------------------
// add trigger
_trig = createTrigger ["EmptyDetector", getPos _IED];


_condition = format["( ({([_x] call IED_fn_IsVehicle)&&(_x != (ListaIEDs select %1))&&(side _x == %3)&& (((getpos _x) select 2) < 3)} count thisList > 0)"+ // 1 west vehicle (which is not the VBIED)
    " || ({(side _x == %3)&& (((getpos _x) select 2) < 3)} count thisList > %2) )", _IED_ID,_Soldados,_bando]; //3 west infantry/units

_trig setTriggerArea [_radius, _radius, 0, false];

_trig setTriggerStatements [
  _condition,
  format["nul=[ListaIEDs select %1] spawn IED_Detonar_Trigg", _IED_ID],
  ""];
_trig setTriggerActivation ["ANY", "PRESENT", true]; // makes no difference...still activates for east
_trig setTriggerType "SWITCH";
_trig setTriggerTimeout [0, _Tiempo/2, _Tiempo, false];

_trig attachTo [_IED,[0,0,0]]; //pegamos el triger al vehiculo :D

_IED setvariable ["IED_Activo", true,true];
_IED setvariable ["IED_Typo", _TypeExplosivo];
_IED setvariable ["IED_Trigger", _trig];
if (!isnull _Terrorista) then {
	_IED setvariable ["IED_Terrorista", _Terrorista];
	call compile format["_Terrorista addEventHandler ['killed', { 
	_trig = (ListaIEDs select %1) getvariable 'IED_Trigger';
	deletevehicle _trig }]", _IED_ID];
	
};

/*
//-----------------------------------------------------------------------------
// PARA creaciones JIP
[-1, {
  _this execVM "Mission\IED\InitClientActionsForOneIED.sqf"
  }, [_IED, true]] call CBA_fnc_globalExecute;
*/