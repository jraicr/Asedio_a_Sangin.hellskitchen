#include "\x\ace\addons\main\script_mod.hpp"
#include "\x\ace\addons\main\script_macros.hpp"
#include "\ca\editor\Data\Scripts\dikCodes.h"

private ["_menuDef", "_target", "_params", "_menuName", "_menuRsc", "_menus"];


PARAMS_2(_target,_params);

_menuName = "";
_menuRsc = "buttonList";

if (typeName _params == typeName []) then {
	if (count _params < 1) exitWith {diag_log format["Error: Invalid params: %1, %2", _this]};
	_menuName = _params select 0;
	_menuRsc = if (count _params > 1) then {_params select 1} else {_menuRsc};
} else {
	_menuName = _params;
};

_puedeLLamar= call compile Colum_revive_Accion_condicion;

_menus =
[
	[
		["main", localize "STR_ACE_MENU_EQUIPPLAYER", _menuRsc],
		[
			["MedEvac >", "", "", "",
				["revive\Data\menu\fnc_menuDef_Self.sqf", "Revive_medevac", 1],
				-1, -1, ACE_SELFINTERACTION_RESTRICTED]
		]
	]
];


if (_menuName == "Revive_medevac") then {
	_menus set [count _menus,
		[
			["Revive_medevac", "MedEvac", _menuRsc, "\ca\air\Data\map_ico\"],
			[
				[7 call Colum_revive_HeliMSG,
				{ [0,{[_this] spawn Colum_revive_HeliEvac}, getpos player ] call CBA_fnc_globalExecute },
				"icomap_mh60mg_ca.paa","","", -1, _puedeLLamar && ACE_SELFINTERACTION_RESTRICTED]
			]
		]
	];
};


_menuDef = [];
{
	if (_x select 0 select 0 == _menuName) exitWith {_menuDef = _x};
} forEach _menus;

if (count _menuDef == 0) then {
	hintC format ["Error: Menu not found: %1\n%2\n%3", str _menuName, if (_menuName == "") then {_this} else {""}, __FILE__];
	diag_log format ["Error: Menu not found: %1, %2, %3", str _menuName, _this, __FILE__];
};

_menuDef