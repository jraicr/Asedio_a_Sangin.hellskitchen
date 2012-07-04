//Script que controla al medico del medevac
private['_Medico','_RadioAccion'];

_Medico=_this select 0;
_RadioAccion=_this select 1;

if (isnil "Colum_Revive_MedicoList") then {Colum_Revive_MedicoList=[]};
Colum_Revive_MedicoList=Colum_Revive_MedicoList+[_Medico];

if (!isServer || (isServer && !(isDedicated))) then {
	[_Medico,_RadioAccion] spawn
	{
		private ["_Medico","_RadioAccion","_ORGpos"];
		_Medico= _this select 0;
		_RadioAccion= _this select 1;
		_ORGpos= getPos _medico;
		while {true} do {
			if (((player distance _ORGpos)< _RadioAccion)&& (vehicle player == player)) then { _Medico call Colum_revive_LLamar_Medico};
			sleep 15;
		};
	};
};

if (isServer) then {
	_Medico setVariable ["Colum_Revive_RadioAccion",_RadioAccion];
	_Medico setvariable ["Posicion_originall",getpos _Medico];
	Colum_revive_AtencionMedica= {
		private ["_Medico","_PacienteActual","_RadioAccion","_timeout","_intentos"];
		_Medico= _this select 0;
		_PacienteActual= _this select 1;
		if (alive _medico) then {
			_RadioAccion= _Medico getVariable "Colum_Revive_RadioAccion";
		
			if ((_PacienteActual distance _Medico) <= (_RadioAccion *2)) then // Esta cerca?
			{
				_intentos=0;
				while {_intentos < 5} do {
					(group _Medico) setSpeedMode "FULL";
					_Medico domove (getPos _PacienteActual);
					(group _Medico) setSpeedMode "FULL";
					_timeout = time + 10;
					waitUntil {moveToCompleted _Medico || moveToFailed _Medico || !alive _Medico || !canmove _Medico || _timeout < time};
					if ((_PacienteActual distance _Medico) < 5) then
					{
						_Medico playMove "AinvPknlMstpSlayWrflDnon_medic";
						[-1,{ if (player==_this) then {sleep 5; -1 spawn Colum_Revive_Acciones}}, _PacienteActual] call CBA_fnc_globalExecute;
						_intentos=5;
					};
					_intentos=_intentos+1;
					sleep 0.1;
				};
			};
			_Medico setVariable ["Colum_Revive_Paciente",nil];
			(group _Medico) setSpeedMode "LIMITED";
			_Medico domove (_Medico getVariable "Posicion_originall");
			(group _Medico) setSpeedMode "LIMITED";
		};
	};
};
