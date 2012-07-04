//Script que controla al medico del medevac
private['_Helicoptero','_HelipuertoBase','_Helinum','_condicion'];

Colum_Revive_Heli_TypeOF={
	private["_radioId", "_radioType", "_ret", "_parent"];
	_radioId = _this select 0;
	_radioType = _this select 1;
	_ret = false;

	_parent = configName (inheritsFrom ( configFile >> "CfgAcreRadios" >> _radioId));
	if(_parent == "") then {
		_parent = configName (inheritsFrom ( configFile >> "CfgWeapons" >> _radioId));
	};
	while { _parent != "" } do {
		if(_parent == _radioType) exitWith {
			_ret = true;
		};
		_parent = configName (inheritsFrom ( configFile >> "CfgAcreRadios" >> _parent));
	};

	_ret
};

Colum_Revive_Heli_TieneRadio={
	private["_unit", "_ret", "_weapon"];
	_weaponArray = weapons player;
	_ret = false;

	{
		_weapon = _x;
		_ret = ([_weapon,"ACRE_PRC117F"] call Colum_Revive_Heli_TypeOF ) || ([_weapon,"ACRE_PRC119"] call Colum_Revive_Heli_TypeOF);
		if(_ret) exitWith { };
	} foreach _weaponArray;

	_ret
};

if (!isDedicated) then
{
	waituntil {!isnull player};
	_condicion ="";
	if (!isnil "acre_api_fnc_hasRadio") then {
		_condicion ='[] call Colum_Revive_Heli_TieneRadio';
	} else {
		_condicion ='[player] call ACE_fnc_HasRadio';
	};
	Colum_revive_Accion_condicion=if (count _this > 1) then {_this select 1} else {_condicion};
	if (isnil { player getvariable 'Colum_revive_Accion_evacSan'}) then {
		_accion=true;
		["player", [ace_sys_interaction_key_self], 4, ['revive\Data\menu\fnc_menuDef_Self.sqf', "main"]] call CBA_ui_fnc_add;
		//_accion=player addAction ["<t color='#f0FE9A2E'>Pedir evacuacion medica</t>", "revive\Data\accion.sqf", 0, 0, false, true,'', _condicion];
		player setvariable ['Colum_revive_Accion_evacSan',_accion];
	};
};

execVM 'revive\Data\Fun_Heli.sqf';
_Helicoptero=_this select 0;

_Helicoptero lockDriver true;
_Helicoptero setVariable ["ace_w_heal", true];//vehiculo medico

if (!isserver) exitwith{}; //Solo el servidor a partir de aqui


if (isnil "Colum_Revive_HeliList") then {Colum_Revive_HeliList=[]};
_Helinum= count Colum_Revive_HeliList;
Colum_Revive_HeliList=Colum_Revive_HeliList+[_Helicoptero];


_list= nearestObjects [_Helicoptero, ["HeliH"], 15];
if ((count _list) > 0) then {
	_HelipuertoBase=_list select 0;
} else {
	if ((getposATL _Helicoptero select 2) < 5) then {
		_HelipuertoBase = createVehicle ["HeliHRescue", getpos _Helicoptero, [], 0, "CAN_COLLIDE"];
	};
};



_Helicoptero setVariable ["Colum_Revive_HeliBase",getpos _Helicoptero];
_Helicoptero setVariable ["Colum_Revive_HeliNum",_Helinum];
_Helicoptero setVariable ["Colum_Revive_HeliOcupado",0];

(driver _Helicoptero) addEventHandler["killed", {_this spawn Colum_revive_HeliPilotoMuerto}];