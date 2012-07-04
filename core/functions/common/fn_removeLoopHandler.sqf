// Thanks to Nou for this code
private ["_id"];
if(MSO_useCBA) then {
        _this call cba_fnc_removePerFrameHandler;
} else {
        _id = _this select 0;
        MSO_Loop_Funcs set[_id, []];
};
