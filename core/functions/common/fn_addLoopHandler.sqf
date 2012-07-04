// Thanks to Nou for this code
private ["_id","_forEachIndex","_return"];
_return = -1;
if(MSO_useCBA) then {
        player sideChat format["cba"];
        _this call cba_fnc_addPerFrameHandler;
} else {
        _id = -1;
        {
                if((count _x) == 0) exitWith {
                        _id = _forEachIndex;
                };
        } forEach MSO_Loop_Funcs;
        if(_id == -1) then {
                _id = (count MSO_Loop_Funcs);
        };
        MSO_Loop_Funcs set[_id, [_this, 0]];
        _return = _id;
};        

_return;
