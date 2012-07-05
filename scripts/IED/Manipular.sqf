private["_IED", "_caller", "_ID","_Params"];
_IED = _this select 0;
_caller = _this select 1;
_ID = _this select 2;
_Params = _this select 3;

if (count _Params == 2) then {
	[_IED,_Params] call IED_Accion_Manipular;
}else {
	_Params call Colum_IEDdetector_toggle;
};