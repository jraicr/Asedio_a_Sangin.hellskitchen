//Funciones de la evacuacion en heli
Colum_revive_AcVueltaHeli= {
	private ["_Heli","_Accion"];
	_Heli= _this;
	_Accion=_Heli addAction [format["<t color='#f001DF01'>%1</t>",8 call Colum_revive_HeliMSG], "revive\Data\accion.sqf", 1,0, false, true,'', '_this in (crew _target)'];
	_Heli setvariable ["revive_accion_Casa",_Accion];
};

Colum_revive_RMAcVueltaHeli= {
	private ["_Heli","_Accion"];
	_Heli= _this;
	_Accion=_Heli getVariable "revive_accion_Casa";
	_Heli removeaction _Accion;
	4 spawn Colum_revive_HeliMSG; //vuelve a casa( ahorramos broadcast 1 msg)
	_Heli setvariable ["revive_accion_Casa",nil];
};

Colum_revive_HeliAutoExtracc= {
	private ["_Heli","_Accion"];
	_Heli= _this;
	if (player in _heli) then
	{
		if (player call ace_sys_wounds_fnc_isUncon) then
		{
			{
				if (_x distance player < 200) then {
					_tmppos=_x modelToWorld [(-5 + (random 10)),(-5 + (random 10)),0];
					player action ["eject", vehicle player];
					waituntil {(vehicle player == player)};
					sleep 5;
					player setpos _tmppos;
				};
			} foreach Colum_Revive_MedicoList;
		};
	};
};

if (!isServer) exitwith {}; 
/************************************************************************************************************/
/*******************************************Funciones server***************************************************/
/************************************************************************************************************/

Colum_revive_HeliEvac= {
	private ["_Heli","_HeliCount","_posicion","_piloto","_GrupoEvac"];
	_posicion= _this select 0;
	colum_revive_tmpInvH=objnull;
	
	{ 
		if (( _x getVariable 'Colum_Revive_HeliOcupado') == 0 )exitwith {
			_Heli = _x;
			_HeliCount= _x getVariable 'Colum_Revive_HeliNum';
		} 
	} foreach Colum_Revive_HeliList;
	
	if (isnil "_Heli") exitwith { [-1,{ 0 spawn Colum_revive_HeliMSG}, []] call CBA_fnc_globalExecute}; // No hay helis
	if ((_Heli distance _posicion)< 400)exitwith {[-1,{ 6 spawn Colum_revive_HeliMSG}, []] call CBA_fnc_globalExecute}; // esta demasiado cerca de la base
	[-1,{ 3 spawn Colum_revive_HeliMSG}, []] call CBA_fnc_globalExecute; // heli en camino
	_Heli setVariable ["Colum_Revive_HeliOcupado",1];
	
	_piloto= driver _Heli;
	_GrupoEvac= group _piloto;
	_Heli engineOn true;
	_Heli flyInHeight 35;
	_GrupoEvac setBehaviour "CARELESS";

	_way_count = waypoints _GrupoEvac;
	{ deleteWaypoint _x } forEach _way_count;

	if(alive _Heli && isEngineOn _Heli) then{
		_wpreinsert = _GrupoEvac addWaypoint [_posicion, 0];
		_wpreinsert setWaypointType "MOVE";
		_wpreinsert setWaypointSpeed "FULL";
		_GrupoEvac setCurrentWaypoint _wpreinsert;
	};
	
	_timeout = time + 120; // _timeout < time
	_lastpos= getpos _heli;
	
	while {((alive _piloto) && ((_heli distance _posicion) > 2000)) || ((getPosATL _Heli) select 2 < 1)} do
	{
		if (((getpos _heli distance _lastpos) < 20) &&( _timeout < time)) exitwith {}; //quieto??? ummm algo fallo
		_lastpos= getpos _heli;
		sleep 10;
	};
	
	
	[-1,{ 5 spawn Colum_revive_HeliMSG}, []] call CBA_fnc_globalExecute;//esperando humo
	 _timeout = time + 120;
	 _EncontradoHumo=false;
	 while {_timeout > time && !(_EncontradoHumo) && ((_heli distance _posicion) > 200)} do {
		//_list= nearestObjects [_posicion, ["G_40mm_SmokeGreen","SMOKESHELLGREEN"], 200];
		_list=_posicion nearObjects ["SMOKESHELLGREEN",150];
		if (count _list > 0) exitwith{_posicion=getpos (_list select 0); _EncontradoHumo=true};
		sleep 1;
		_list=_posicion nearObjects ["G_40mm_SmokeGreen",150];
		if (count _list > 0) exitwith{_posicion=getpos (_list select 0); _EncontradoHumo=true};
		sleep 10;
	 };

	 if ( _EncontradoHumo) then
	 {
		colum_revive_tmpInvH= "HeliH" createvehiclelocal _posicion;
		colum_revive_tmpInvH setpos _posicion;
		[-1,{ 1 spawn Colum_revive_HeliMSG}, []] call CBA_fnc_globalExecute;//Humo avistado
		[_Heli,_posicion] call Colum_revive_HeliEvac_Aterri;
		[-1,{ _this spawn Colum_revive_AcVueltaHeli}, _Heli] call CBA_fnc_globalExecute;
	 } else {
		[_Heli,_posicion] call Colum_revive_HeliEvac_Aterri2;
	 };
};

Colum_revive_HeliEvac_Aterri= {
	private ["_Heli","_HeliCount","_posicion","_piloto","_GrupoEvac"];
	_Heli= _this select 0;
	_posicion= _this select 1;
	
	_piloto= driver _Heli;
	_GrupoEvac= group _piloto;
	_HeliCount= _Heli getVariable 'Colum_Revive_HeliNum';
	
	_Heli setVariable ["Colum_Revive_HeliOcupado",2]; // estado heli 2, aterrizando


	_wpreinsert = _GrupoEvac addWaypoint [_posicion, 0];
	_wpreinsert setWaypointType "MOVE";
	_wpreinsert setWaypointSpeed "FULL";
	_wpreinsert setWaypointStatements ["true", format["(Colum_Revive_HeliList select %1) land 'LAND';(Colum_Revive_HeliList select %1) flyInHeight 4; (Colum_Revive_HeliList select %1) setVariable ['Colum_Revive_HeliOcupado',3];",_HeliCount]];
	_GrupoEvac setCurrentWaypoint _wpreinsert;
	
	_timeout = time + 80;
	 while {(_timeout > time) && ((getPosATL _Heli) select 2 > 0.5)&& ((_Heli getVariable "Colum_Revive_HeliOcupado")==2)} do {
		sleep 10;
	 };
	 
	 _timeout = time + 180;
	 while {(_timeout > time) && ((getPosATL _Heli) select 2 > 0.5)} do {
		_Heli land "LAND";
		sleep 10;
	 };

	if ((getPosATL _Heli) select 2 > 0.5) exitwith{ _heli spawn Colum_revive_HeliEvac_VueltaBase };//Si no aterriza que intente volver a base
	
	_Heli engineOn false;
	_way_count = waypoints _GrupoEvac;
	{ deleteWaypoint _x } forEach _way_count;

};

Colum_revive_HeliEvac_Aterri2= {
	private ["_Heli","_HeliCount","_posicion","_piloto","_GrupoEvac"];
	_Heli= _this select 0;
	_posicion= _this select 1;
	
	_piloto= driver _Heli;
	_GrupoEvac= group _piloto;
	_HeliCount= _Heli getVariable 'Colum_Revive_HeliNum';
	
	_Heli setVariable ["Colum_Revive_HeliOcupado",2]; // estado heli 2, aterrizando


	_wpreinsert = _GrupoEvac addWaypoint [_posicion, 0];
	_wpreinsert setWaypointType "MOVE";
	_wpreinsert setWaypointSpeed "FULL";
	_wpreinsert setWaypointStatements ["true", format["(Colum_Revive_HeliList select %1) land 'GET IN';(Colum_Revive_HeliList select %1) flyInHeight 4; (Colum_Revive_HeliList select %1) setVariable ['Colum_Revive_HeliOcupado',3];",_HeliCount]];
	_GrupoEvac setCurrentWaypoint _wpreinsert;
	
	_timeout = time + 80;
	 while {(_timeout > time) && ((getPosATL _Heli) select 2 > 3)&& ((_Heli getVariable "Colum_Revive_HeliOcupado")==2)} do {
		sleep 10;
	 };
	 
	 _timeout = time + 180;
	 while {(_timeout > time) && ((getPosATL _Heli) select 2 > 3)} do {
		_Heli land 'GET IN';
		sleep 10;
	 };

	if ((getPosATL _Heli) select 2 > 3) exitwith{ _heli spawn Colum_revive_HeliEvac_VueltaBase };//Si no aterriza que intente volver a base
	
	_Heli engineOn false;
	_way_count = waypoints _GrupoEvac;
	{ deleteWaypoint _x } forEach _way_count;

};

Colum_revive_HeliEvac_VueltaBase= {
	private ["_Heli","_HeliCount","_posicion","_piloto","_GrupoEvac","_iswater"];
	_Heli= _this;
	_posicion=_Heli getVariable "Colum_Revive_HeliBase";
	_iswater= surfaceiswater _posicion;
	
	
	_piloto= driver _Heli;
	_GrupoEvac= group _piloto;
	_Heli engineOn true;
	_Heli flyInHeight 35;
	_HeliCount= _Heli getVariable 'Colum_Revive_HeliNum';
	_GrupoEvac setBehaviour "CARELESS";

	
	[-1,{ _this call Colum_revive_RMAcVueltaHeli}, _Heli] call CBA_fnc_globalExecute;
	_Heli setVariable ["Colum_Revive_HeliOcupado",4]; // estado heli 4, vuelve a casa vueeelve
	
	_way_count = waypoints _GrupoEvac;
	{ deleteWaypoint _x } forEach _way_count;

	if (_iswater) then {
		_Heli setVariable ["mando_heliroute", "init"];
		[_Heli,[_posicion],35, true] spawn Colum_revive_Mando_heli_Route;
	}else{
		_wpreinsert = _GrupoEvac addWaypoint [_posicion, 0];
		_wpreinsert setWaypointType "MOVE";
		_wpreinsert setWaypointSpeed "FULL";
		_wpreinsert setWaypointStatements ["true", format["(Colum_Revive_HeliList select %1) land 'LAND';(Colum_Revive_HeliList select %1) flyInHeight 4; (Colum_Revive_HeliList select %1) setVariable ['Colum_Revive_HeliOcupado',5];",_HeliCount]];
		_GrupoEvac setCurrentWaypoint _wpreinsert;
	};
	 
	_timeout = time + 120;
	_lastpos= getpos _heli;
	//Esperamos a que llegue
	while {(alive _piloto) && ((_heli distance _posicion) > 300)} do
	{
		if (((getpos _heli distance _lastpos) < 20) &&( _timeout < time)) exitwith {}; //quieto??? ummm algo fallo
		_lastpos= getpos _heli;
		sleep 10;
	};
	
	_GrupoEvac setSpeedMode "LIMITED";// Esta cerca, vamos frenando
	_Heli limitSpeed 60;
	
	_timeout = time + 120;
	 while {(_timeout > time) && ((getPosATL _Heli) select 2 > 0.5)&& ((_Heli getVariable "Colum_Revive_HeliOcupado")==4)&& ((_Heli getVariable "mando_heliroute")!='waiting')} do {
		sleep 10;
	 };
	 
	if (!_iswater) then {
		//if not is water, manual landing, softer than mando heli route :P
		_timeout = time + 50;
		 while {(_timeout > time) && ((getPosATL _Heli) select 2 > 0.5)} do {
			_Heli land "LAND";
			sleep 10;
		};
	};
	 
	if (alive _Heli && (Alive (driver _Heli))) then {
		_Heli setVariable ["Colum_Revive_HeliOcupado",0];
		_Heli engineOn false;
		if (!_iswater) then {_Heli setpos _posicion};
		_Heli setdamage 0;
		_Heli setfuel 1;
		[-1,{ _this spawn Colum_revive_HeliAutoExtracc}, _Heli] call CBA_fnc_globalExecute;//autoextraemos los incoscientes
		
	};
	if (!isnull colum_revive_tmpInvH) then {deletevehicle colum_revive_tmpInvH};
};

Colum_revive_HeliPilotoMuerto= {
	private ["_Heli"];
	_Heli= vehicle (_this select 0);
	_Heli setfuel 0;//quitamos gasofa si matan al piloto, para evitar cabroncetes xD
};

Colum_revive_Mando_heli_Route=
{
	//Based on Mando heli route. http://www.armaholic.com/page.php?id=6959
	//All credits to Mandoble for this function. It has some modifications from the base one to adapt it to my medevac script, but most of the script is still intact
	//Used only for the base return, to get the IA land on the carrier ^^
	private["_heli", "_route", "_endpos", "_height", "_landing ", "_pilot", "_i", "_j", "_pos", "_dist", "_distold", "_angh", "_dir", "_accel", "_speed", "_steps", "_inipos", "_offset"];

	_heli          = _this select 0;
	_route         = _this select 1;
	_height        = _this select 2;
	_landing       = _this select 3;

	// First of all chopper gets its indicated flying height for the route
	_pilot = driver _heli;

	_heli setVariable ["mando_heliroute", "busy"];

	_heli flyinHeight _height;
	_pilot doMove [getPos _heli select 0, getPos _heli select 1, _height];
	Sleep 2;
	while {(!unitReady _pilot)&&(alive _pilot)&&(damage _heli < 0.5)} do
	{
	   Sleep 2;
	};
	if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith {_heli setVariable ["mando_heliroute", "damaged"];};


	// The chopper moves through the route positions
	for [{_j = 0},{_j < count _route},{_j = _j + 1}] do
	{ 
	   _endpos = _route select _j;
	   _inipos = getPos _heli;
	   _dist = sqrt(((_endpos select 0) - (_inipos select 0))^2 + ((_endpos select 1) - (_inipos select 1))^2);
	   _steps = _dist / 3000;
	   _steps = _steps - (_steps % 1);
	   _ang = ((_endpos select 0) - (_inipos select 0)) atan2 ((_endpos select 1) - (_inipos select 1));

	   // Each route position is reached in steps no larger than 3Km
	   for [{_i = 0},{_i < _steps},{_i = _i + 1}] do
	   { 
		  _pos = [(_inipos select 0) + sin(_ang)*3000*_i,(_inipos select 1) + cos(_ang)*3000*_i];
		  _pilot doMove _pos;
		  Sleep 2;

		  if (_i < (_steps - 1)) then
		  {
			 _offset = 5;
		  }
		  else
		  {
			 _offset = 1;
		  };

		  while {((sqrt(((_pos select 0) - (getPos _heli select 0))^2 + ((_pos select 1) - (getPos _heli select 1))^2))>500)&&(alive _pilot)&&(damage _heli < 0.5)} do
		  {
			 Sleep 2;
		  };
		  if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith {};
	   };
	   if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith {};

	   _pilot doMove _endpos;
	   Sleep 2;
	   while {((!unitReady _pilot) || (abs(speed _heli) > 1))&&(alive _pilot)&&(damage _heli < 0.5)} do 
	   {
		  Sleep 0.2;
	   };
	   if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith {};
	};

	while {(abs(vectorUp _heli select 2) < 0.996)&&(alive _pilot)&&(damage _heli < 0.5)} do 
	{
	   Sleep 0.2;
	};

	if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith 
	{
	   _heli setVariable ["mando_heliroute", "damaged"];
	};
	_pilot doMove [getPos _heli select 0, getPos _heli select 1];



	// If chopper is not closer than 2m to final route point, it aligns with it and moves towards it
	_dist = sqrt(((_endpos select 0) - (getPos _heli select 0))^2 + ((_endpos select 1) - (getPos _heli select 1))^2);
	_dir = getDir _heli;

	if (_dist > 2) then
	{
	   _pos = _heli worldToModel _endpos;
	   _angh = (_pos select 0) atan2 (_pos select 1);
	   _dist = sqrt((_pos select 0)^2+(_pos select 1)^2);

	   for [{_i = 0},{_i < abs(_angh)},{_i = _i + 1}] do
	   {
		  if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith {};
		  _heli setDir ((getDir _heli)+abs(_angh)/_angh);
		  _heli setVelocity [0,0,0];
		  Sleep 0.05;
	   };  
	};
	_heli setDir (_dir + _angh);
	_dir = getDir _heli;



	_distold = 99999;
	_dist = 99998;
	_speed = 0;
	while {(_distold >= _dist) && (alive _pilot) && (damage _heli < 0.5)} do
	{
	   if (_speed < 7) then
	   {
		  _speed = _speed + 0.1;
	   };
	   _distold = _dist;
	   _dist = sqrt(((_endpos select 0) - (getPos _heli select 0))^2 + ((_endpos select 1) - (getPos _heli select 1))^2);
	   _heli setVelocity [sin(_dir)*_speed, cos(_dir)*_speed, 0];
	   _heli setDir _dir;
	   Sleep 0.005;
	};

	if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith 
	{
	   _heli setVariable ["mando_heliroute", "damaged"];
	};

	// Do we need to land?
	if (_landing) then
	{
	   while {(isEngineOn _heli) && (alive _pilot) && (damage _heli < 0.5)} do
	   {
		  if ((getPos _heli select 2) > ((_endpos select 2) + 1)) then
		  {
			 _heli setDir _dir;
			 if ((getPos _heli select 2) > ((_endpos select 2) + 5)) then
			 {
				_heli setVelocity [0,0,-7];
			 } 
			 else
			 {
				_heli setVelocity [0,0,7*((getPos _heli select 2)-(_endpos select 2))/-5 min -1];
			 };
		  } 
		  else
		  {
			 _pilot action ["ENGINEOFF", _heli];
			 _heli setVelocity [0,0,0];
		  };
		  Sleep 0.01;
	   };

	   for [{_i = 0},{_i < 100},{_i = _i + 1}] do
	   {
		  _heli setVelocity [0,0,-0.1];
		  Sleep 0.05;
	   };

	   if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith {};

	   _heli setVariable ["mando_heliroute", "waiting"];
	   while {(alive _pilot) && (damage _heli < 0.5) && ((_heli getVariable "mando_heliroute") == "waiting")} do
	   {
		  _pilot action ["ENGINEOFF", _heli];
		  Sleep 0.01;
	   };
	}
	else
	{
	   _heli setVariable ["mando_heliroute", "waiting"];
	};

	if (!(alive _pilot) || (damage _heli >= 0.5)) exitWith 
	{
	   _heli setVariable ["mando_heliroute", "damaged"];
	};
};