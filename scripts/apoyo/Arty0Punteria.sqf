//Este escript realiza fuego de artilleria en una zona sin golpear ningun objetivo del bando indicado.
/****************************************************************************************************/
// PARAMETROS:
/*
	1-) Tipo de proyectil, es un numero de 0 a 4 dependiendo de la potencia deseada. Cualquier otro numero, como -1 lanzara humo. -2, ... , -5 vengalas de colores
	2-) Vector de posicion central donde caera la artilleria. Debe ser de al menos 2 elementos. Si se marca con objetos/logicas usar el getpos, y getmarkerpos para marcadores
	3-) Area alrededor de la posicion central a bombardear, en metros..
	4-) OPCIONAL: descanso entre cada disparo en segundos.
	5-) OPCIONAL: bando de los jugadores a los que evitara la artilleria.  Si no se pone, evitara a todos los bandos menos civiles.

*/
private["_tempTipoProyectil", "_objetivoX", "_objetivoY", "_areaObjetivo", "_numeroProyectiles", "_tempCenter", "_tipoProyectil", "_AreaPeligro", "_locObjetivo", "_tempObjetivo"];
private["_tlist", "_trg", "_ciclos", "_objetivoFijado", "_PausaDisparo", "_FORZAR_DISPARO", "_MAX_CICLOS","_SoloAnimales","_bandoJug"];



_MAX_CICLOS= 3; 
_FORZAR_DISPARO = false;
_trg=objnull;

If (!isServer) exitwith {}; 

//******************************************* Parametros ***********************************************/
// tipo de proyectil,  0 para mortero pequeño , 1 mortero, 2 cañonazo, 3 artilleria, 4 artileria pesada. Cualquier otro humo o ilum
_tempTipoProyectil =_this select 0;

_objetivoX= (_this select 1) select 0;
_objetivoY=	(_this select 1) select 1;

_areaObjetivo =_this select 2;

_numeroProyectiles =_this select 3;

if (count _this > 4) then{ _PausaDisparo =_this select 4} else {_PausaDisparo=.1};

if (count _this > 5) then{ _bandoJug =_this select 5} else {_bandoJug = "ANY"};



//*******************************************Calculos previos **********************************************/
_tempCenter=_areaObjetivo / 2;


switch (_tempTipoProyectil) do
{

	case 0: {_tipoProyectil = "R_57mm_HE";_AreaPeligro = 35;};
	case 1: {_tipoProyectil = "M_Stinger_AA";_AreaPeligro = 35;};
	case 2: {_tipoProyectil = "M_Maverick_AT";_AreaPeligro = 35;};
	case 3: {_tipoProyectil = "Sh_85_HE";_AreaPeligro = 53;};
	case 4: {_tipoProyectil = "Sh_100_HE";_AreaPeligro = 35;};
	case 5: {_tipoProyectil = "Sh_105_HE";_AreaPeligro = 85;};
	case 6: {_tipoProyectil = "ARTY_Sh_105_HE";	_AreaPeligro = 105;};	
	case 7: {_tipoProyectil = "ARTY_R_227mm_HE";_AreaPeligro = 170;};
	case -2: {_tipoProyectil = "F_40mm_white";_AreaPeligro = 0;};
	case -3: {_tipoProyectil = "F_40mm_yellow";_AreaPeligro = 0;};
	case -4: {_tipoProyectil = "F_40mm_green";_AreaPeligro = 0;};
	case -5: {_tipoProyectil = "F_40mm_red";_AreaPeligro = 0;};
	default	{_tipoProyectil = "SmokeShellPurple";_AreaPeligro = 0;};
};

switch (true) do
{
	case ((_tempTipoProyectil <= 2)&&(_tempTipoProyectil >= 0)): {_tempObjetivo =[0,0,0];};
	case ((_tempTipoProyectil <= 7)&&(_tempTipoProyectil > 2)||(_tempTipoProyectil ==-1)): {_tempObjetivo =[0,0,50];};
	case (_tempTipoProyectil < -1): {_tempObjetivo =[0,0,350];};
};


//****************************************** Empieza la fiesta *******************************************/
While { _numeroProyectiles > 0 } do {
	_ciclos= 0;	_objetivoFijado = false;
	while { (_ciclos < _MAX_CICLOS) && (not _objetivoFijado) } do {
		_tempObjetivo set [0,_objetivoX + (random _areaObjetivo) - _tempCenter];
		_tempObjetivo set [1,_objetivoY + (random _areaObjetivo) - _tempCenter];
		
		if (_AreaPeligro > 0) then {
			_trg=createTrigger["EmptyDetector", _tempObjetivo];
			_trg setTriggerArea[_AreaPeligro,_AreaPeligro,0,false];
			_trg setTriggerActivation[_bandoJug,"PRESENT",false];
			_trg setTriggerStatements ["this", "", ""];
			sleep (0.8);
			waituntil {!isnil {list _trg}};
			
			_tlist = list _trg;
		} else {_tlist=[]};
		
		if ((count _tlist) == 0) then {
			_locObjetivo = _tempObjetivo; _objetivoFijado= true;
		} else {
			if (_bandoJug == "ANY") then{
				_SoloAnimales=true;
				{if ((side _x) in [west, east, resistance,civilian]) exitwith {_SoloAnimales=false}; } foreach _tlist;
				if (_SoloAnimales) then {_locObjetivo = _tempObjetivo; _objetivoFijado= true};
			};
		};
		if (!isnull _trg) then {deletevehicle _trg;};
		_ciclos= _ciclos + 1;
	};
	
	
	if (_FORZAR_DISPARO) then {	_locObjetivo = _tempObjetivo; _objetivoFijado= true}; 
	
	if  (_objetivoFijado) then
	{
		_pepino= _tipoProyectil createVehicle _locObjetivo;
		if (_tempTipoProyectil >= -1) then { _pepino setVelocity [0,0,-500]};
		sleep _PausaDisparo;
	};

	_numeroProyectiles = _numeroProyectiles-1; 
};

