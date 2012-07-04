#include <modules\modules.hpp>

#ifndef execNow
#define execNow call compile preprocessfilelinenumbers
#endif

civilian setFriend [west, 1];
civilian setFriend [east, 1];
civilian setFriend [resistance, 1];

#ifdef CRB_CIVILIANS
"Ambiente civil" call mso_core_fnc_initStat;
execNow "ambience\modules\crb_civilians\main.sqf";
#endif