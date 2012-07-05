private["_IED", "_caller", "_ID","_Params"];
_IED = _this select 0;
_caller = _this select 1;
_ID = _this select 2;
_Params = _this select 3;

[0, { [_this] call IED_Detonar}, _IED ] call CBA_fnc_globalExecute;