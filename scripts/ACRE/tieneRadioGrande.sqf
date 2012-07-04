private["_unit", "_ret", "_weapon","_tieneRadio"];

_tieneRadio={
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


_weaponArray = weapons player;
_ret = false;

{
	_weapon = _x;
	_ret = ([_weapon,"ACRE_PRC117F"] call _tieneRadio ) || ([_weapon,"ACRE_PRC119"] call _tieneRadio);
	if(_ret) exitWith { };
} foreach _weaponArray;

_ret
