respawn = "BASE";
respawnDelay = 4;

disabledAI = true;
aiKills = 0;
briefing = 0;
debriefing = 1;

ShowGPS = 1;
showCompass = 1;
showMap = 1;
showNotePad = 1;
showPad = 1;
showWatch = 1;

class Header
{
	gameType = COOP;            //DM, Team, Coop, ...
	minPlayers = 1;             //min # of players the mission supports
	maxPlayers = 100;            //Max # of players the mission supports
	playerCountMultipleOf = 1;  //OFP:Elite option.
};

class CfgSounds
{

 sounds[] = {};
 #include <Scripts\IED\Bomba_Sonidos.hpp>
};

class CfgIdentities
{
#include "scripts\recon_facial\listaPersonajes.hpp"
};


