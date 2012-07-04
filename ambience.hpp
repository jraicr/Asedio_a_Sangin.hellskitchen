#include "ambience\modules\modules.hpp"

//http://community.bistudio.com/wiki/Arma_2:_Patch_v1.03.58899_Beta#How_to_add_multiple_parameters_to_your_MP_mission
class Params {

#ifdef CRB_CIVILIANS
	#include "ambience\modules\crb_civilians\params.hpp"
#endif
}; 

//http://community.bistudio.com/wiki/Functions_Library
class cfgFunctions {
	#include "core\functions\functions.hpp"
	#include "ambience\functions\functions.hpp"

};

class CfgAmmo
{
#ifdef CRB_CIVILIANS
 class Default;
 class BulletBase;
 class GrenadeHand;
 class GrenadeHand_stone: GrenadeHand
 {
  hit = 7;
  indirectHit = 0.2;
  indirectHitRange = 1;
  soundHit[] = {"Ca\sounds\Weapons\hits\rico_hit_wood_08",15.848933,1};
 };
#endif
};