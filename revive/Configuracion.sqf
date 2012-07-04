/***********************************************************************************************************************************/
/*************************************************Seccion de configuracion***********************************************************/
/***********************************************************************************************************************************/
//Nº de vidas. Minimo 1( aunque no tiene mucho sentido ya me moriras a la primera)
//NOTA: Este valor sera sobreescrito si se le pasan parametros al execVM del init de la mision. Asique usa: execVM "revive\ReviveAceWounds.sqf"; 
Colum_revive_Conf_Lifes= 2;

//Desactivamos el sistema de heridas para las I.A. , en principio se comportan mejor sin el.
ace_sys_wounds_noai= true;

//Tiempo por el que se permanece inconsciente(muerto) antes de morir definitivamente.
ace_wounds_prevtime = 1800;

//Ativamos el modo espectador del revive cuando estamos inconscientes. False para pantalla negra mientras estamos muertos.
ace_sys_wounds_withSpect  = true;

//Mostrar mensages de TK entre jugadores. True= mostrar mensajes. False= no mostrar
Colum_revive_TKcheck= true;

//Mostrar enemigos en el espectador una vez muerto. True = mostrar, False = no mostrar.
Colum_revive_VerEnemigos= false;

//PvP, los mensages de muerte, marcas en el mapa y demas seran por bando, para evitar dar informacion al bando contrario en PvP.
Colum_revive_PvP=true;

//Herir gravemente heridos +1 puntuacion, herir gravemente aliado -1 puntuacion. Pensado especialmente para PvP, simplemente para dar credito por herir a enemigos y no solo por matarlos cuando no tienen mas vidas.
Colum_revive_WoundScoring=true;

//Mochila para el medico, usar "" o comentar la linea para deshabilitar
Colum_revive_MochilaMedico="ACE_AssaultPack_BAF";

//Contenido de la mochila, solo valido si lo anterior esta habilitado con una mochila válida
// Los contenidos estan ordenados [nº comprres, nº morphina, nº ephinifrina, nº granadas humo verde, nº medkits]
Colum_revive_MochilaMedico_Contenido=[10,20,15,2,12];


//Colum_revive_MochilaMedico_WEST = "ACE_VTAC_RUSH72_TT_MEDIC";
//Colum_revive_MochilaMedico_EAST = "ACE_VTAC_RUSH72_TT_MEDIC";
//Colum_revive_MochilaMedico_GUER = "ACE_VTAC_RUSH72_TT_MEDIC";
//Colum_revive_MochilaMedico_CIV = "ACE_VTAC_RUSH72_TT_MEDIC";


//Colum_revive_MochilaMedico_Contenido_WEST =[10,20,15,2,10];
//Colum_revive_MochilaMedico_Contenido_EAST = [10,20,15,2,10];
//Colum_revive_MochilaMedico_Contenido_GUER = [10,20,15,2,10];
//Colum_revive_MochilaMedico_Contenido_CIV =[10,20,15,2,10];


//Los jugadores que entran tarde tendran la posivilidad de teletransportarse a la posicion de su escuadra. True = permitir, False = no permitir
Colum_revive_JIPTelep=true;

//Cuando un jugador se desconecta se guarda su posicion, inventario y estado(si estaba incosciente o no). Cuando reconecta, volvera a esa posicion. True para habilitar, false deshabilitar
//NOTA: Necesita pruebas con muchos jugadores.
Colum_revive_DisconectSave=true;

//Permitir respawn . false= si se acaba el tiempo mueres definitivamente aunque te queden vidas. true= si se acaba el tiempo o cuando se decida hay opcion de hacer respawn si quedan vidas
Colum_revive_Respawn=false;

//Respawn por bandos . false= todos el mismo respawn. true= cada bando tiene su respawn
Colum_revive_Respawn_Side=false;

//Vidas por bandos . false=Todos el mismo numero de vidas. true= vidas segun el bando, se definen mas abajo
Colum_revive_Vidas_Side= false;

//Marcadores en el mapa, false= Sin marcadore, true= Las unidades gravemente heridas apareceran marcadas en el mapa.
Colum_revive_Death_Markers= true;

//Mensages de muerte . false=No mostrara ningun mensage cuando alguien caiga herido. true= se mostrara un mensage cuando alguien cae gravemente herido
Colum_revive_Death_Messages= true;

//Muertos dejan grupo . false=Los muertos siguen en el grupo original, solo que incoscientes. true=Cuando alguien muere definitivamente es expulsado del grupo, deberia dar mejores resultados, tan solo esta como opcion por si da problemas con algun script mal hecho que tome como referencia la unidad del lider
Colum_revive_Death_LeaveGroup= true;

//Daño minimo que queda despues de curar el MEDICO, multiplicado por cada cura. Recomendable 0.01 a 0.08 o 0 para desactivar. Aun asi, en los hospitales y vehiculos medicos se curaria totalmente independientemente de este parametro.
ace_sys_wounds_leftdam=0.08;

//Al "revivir" a alguien curar automaticamente sin medkit. True activado, false desactivado. Menos realista, pero por si se quiere dejar parecido a como estaba antes
Colum_revive_Levanta_Heal=false;

//Penalice Respawn button with Death. If true, if you press the respawn button you are out of the game, if false, you will only lose a life
Colum_revive_RespawnButtonPunish=false;

//Si se falla al recibir las vidas del servidor, se mata al jugador. True = muerte si fallo, false= si se falla al recibir, se usa el numero total de vidas :S
Colum_revive_KillOnConnectFail=true;

//Si el jugador se desconecta mientras esta incosciente o muerto, pierde una vida. Para evitar exploits(desconectarse para evitar la muerte y otras perrerias ¬¬). True habilitado , false deshabilitado.
Colum_revive_DisconectPunish=false;

//Accion a realizar si alguien muere en el agua. hay 3 posibles opciones:
//0 : no hacer nada, como hasta la version anterior. El muerto se undira en el fondo del mar,  por lo que si es agua profunda sera irrecuperable, pero podria serlo si la profundidad es poca
//1 : muerte directa si el agua es profunda. Lo mismo que el caso anterior solo que si la profundidad es mayor a 2m mueres directamente, no tiene sentido quedar en el fondo sin poder ser salvado
//2 : El jugador herido queda flotando en el agua. Cualquiera puede acercase y agarrarlo si va nadando. Si se accerca cualquier vehiculo aliado, subira automaticamente a bordo.(opcion por defecto)
//3 : El jugador es transportado a la costa mas cercana donde podria ser salvado.
Colum_revive_WaterAction=2;

//Persistencia de las vidas del los jugadores:
//-1 : infinito, las vidas persisten hasta que se cambie la mision(opcion por defecto)
//0 : No persistentes, las vidas se resetean al reconectar. 
//>1 : Las vidas se resetean pasado X tiempo (en segundos)
Colum_revive_LifesPersist=24*60*60;

if (Colum_revive_Respawn) then {
//Texto de los botones. Numero ilimitado de marcadores, se pueden agregar los necesarios
	Colum_revive_RespawnButton_text = ["respawn1", "respawn2", "respawn3", "respawn4", "respawn4"];
	//Otro ejemplo con solo 2 botones : Colum_revive_RespawnButton_text = ["respawn1", "respawn2"]; 
//Nombre de los marcadores de los respawns
	Colum_revive_RespawnMarkers= ["respawn1_marker", "respawn2_marker", "respawn3_marker", "respawn4_marker", "respawn5_marker"];
//Offset de altura para los respawn. Util por ejemplo para respawns en un edificio o portaaviones.
	Colum_revive_RespawnOffset= [0,0,0,0];
	
//Tiempo antes de la aparicion de los botones de respawn en segundos, obviamente menor que el ace_wounds_prevtime
	ace_sys_spectator_RevShowButtonTime = 10;
	
	if (Colum_revive_Respawn_Side) then {
		// Respawn Speciales por bando, si se definen no hacen falta los anteriores
		//Bluefor
		Colum_revive_RevButtons_WEST = ["respawn1_WEST", "respawn2_WEST", "respawn3_WEST", "respawn4_WEST"];
		Colum_revive_RespawnMarkers_WEST= ["respawn1_WEST", "respawn2_WEST", "respawn3_WEST", "respawn4_WEST"];
		Colum_revive_RespawnOffset_WEST=[0,0,0,0];
		
		//oppfor
		Colum_revive_RevButtons_EAST = ["respawn1_EAST", "respawn2_EAST", "respawn3_EAST", "respawn4_EAST"];
		Colum_revive_RespawnMarkers_EAST= ["respawn1_EAST", "respawn2_EAST", "respawn3_EAST", "respawn4_EAST"];
		Colum_revive_RespawnOffset_EAST=[0,0,0,0];
		
		//Independ
		Colum_revive_RevButtons_GUER = ["respawn1_GUER", "respawn2_GUER", "respawn3_GUER", "respawn4_GUER"];
		Colum_revive_RespawnMarkers_GUER= ["respawn1_GUER", "respawn2_GUER", "respawn3_GUER", "respawn4_GUER"];
		Colum_revive_RespawnOffset_GUER=[0,0,0,0];
			
		//Civil
		Colum_revive_RevButtons_CIV = ["respawn1_CIV", "respawn2_CIV", "respawn3_CIV", "respawn4_CIV"];
		Colum_revive_RespawnMarkers_CIV= ["respawn1_CIV", "respawn2_CIV", "respawn3_CIV", "respawn4_CIV"];
		Colum_revive_RespawnOffset_CIV=[0,0,0,0];
		
	};
};

if (Colum_revive_Vidas_Side) then {
	//Vidas para el bando bluefor
	Colum_revive_VidasMax_WEST=2;
	
	//Vidas para el bando Opfor
	Colum_revive_VidasMax_EAST=3;
	
	//Vidas para el bando indepen
	Colum_revive_VidasMax_GUER=4;
	
	//Vidas para el bando civil
	Colum_revive_VidasMax_CIV=10;
};



/***********************************************************************************************************************************/
/****************************************************FIN configuracion**************************************************************/
/***********************************************************************************************************************************/