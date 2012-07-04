//Easier translations, all messages here

Colum_Revive_Funcion_Message = {
	private ["_MessageID","_Params"];
	_MessageID= _this select 0;
	_Params= _this select 1;

	switch (_MessageID) do
	{
	  case 1: {hint format["Vidas: %1 de %2",Colum_revive_VidasLocal-1,Colum_revive_VidasMax-1];};
	  case 2: {titlecut ["Estas muerto","PLAIN",2]};
	  case 3: {10 cutText [format["Estas gravemente herido: %1 te ha herido. FUEGO AMIGO",name _Params],"PLAIN",1];};
	  case 4: {10 cutText ["Estas gravemente herido.","PLAIN",1];};
	  case 5: {10 cutText ["Estas gravemente herido: Te has suicidado","PLAIN",1];};
	  case 6: {10005 cutText ["Has entrado en una zona medica. Espera a ser atendido...","PLAIN",2];};
	  case 7: {10 cutText ["Por favor, SOLO usar el boton respawn en el caso de que sea necesario","PLAIN DOWN"];};
	  case 8: {10 cutText ["Reapareciendo...","PLAIN DOWN"];};
	  case 9: {10 cutText ["Presiona F12 durante los proximos 5 minutos para ir con tu escuadra/aliados","PLAIN",2];};
	  case 10: {[playerSide, "HQ"] sideChat format["%1 Fuego amigo!!, has herido a %2",name (_Params select 0),name (_Params select 1)];};
	  case 11: {format["%1 se encuentra gravemente herido", name _Params] call CBA_fnc_systemChat;};
	  case 12: {Hint 'Error JIP, por favor reporta este error';};
	  case 13: {titlecut ["La corriente te lleva hacia la costa...","BLACK FADED",5]};
	  case 14: {format["%1 herido",(name _Params)];};
	  case 15: {format["(%1)Mas...",Colum_revive_RespawnButton_Pos+1];};
	  default {};
	};
};

Colum_revive_HeliMSG= {
	switch(_this) do
	{
	  case 0: {[playerside,"HQ"] sidechat "No hay ningún helicóptero disponible para la extracción, mantengase a la espera"};
	  case 1: {[playerside,"HQ"] sidechat "Humo avistado"};
	  case 2: {[playerside,"HQ"] sidechat "No hemos avistado el humo, regresamos a base"};
	  case 3: {[playerside,"HQ"] sidechat "Centro de mando recibido, enviando helicóptero de ecuación medica. Preparen humo verde"};
	  case 4: {[playerside,"HQ"] sidechat "Roger, Helicóptero medico regresando a base"};
	  case 5: {[playerside,"HQ"] sidechat "Pájaro aproximandose a zona de extracción, buscando humo verde"};
	  case 6: {[playerside,"HQ"] sidechat "Negativo, demasiado cerca."};
	  case 7: {"Llamar evacuacion"};
	  case 8: {"Todos dentro, nos vamos."};
	};
};