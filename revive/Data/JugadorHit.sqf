Colum_revive_JugadorHit=
{
	Private['_jugador','_causante','_dano'];
	_jugador=_this select 0;
	_causante=_this select 1;
	_dano=_this select 2;
	if ((!isplayer _causante)||(!local _jugador)) exitwith{}; 
	_jugador setvariable ['UltAtack', [time,_causante]];
};


Colum_revive_JugadorComprobarTK=
{
	Private['_datos','_causante','_tiempo'];
	_datos= player getVariable 'UltAtack';

	if (!isnil "_datos") then {
		_tiempo=_datos select 0;
		_causante=_datos select 1;
		if ((time -_tiempo ) < 20) then
		{
			//Fue hace poco asique se supone que el lo mato , cabronazo xD.
			if (_causante != player) then
			{
				if ((side _causante ) == playerSide) then {
					[3,_causante] call Colum_Revive_Funcion_Message;
				} else {
					[4,0] call Colum_Revive_Funcion_Message;
				};
				_causante
			} else {
				[5,0] call Colum_Revive_Funcion_Message;
			};
		};
	};
};

Player addEventHandler ['Hit', {_this spawn Colum_revive_JugadorHit}];