private ["_result","_param","_status","_start"];
_status = _this select 0;
_param = _this select 1;
_result = 0;

if(isNil "CRB_PROFILER") then {
        diag_log "CRB_PROFILER,NAME,TIME";
        CRB_PROFILER = [];
};

switch(toLower(_status)) do {
        case "start": {
                _start = diag_tickTime;
                _result = count CRB_PROFILER;
                CRB_PROFILER set [_result, [_param, _start]];
        };
        
        case "stop": {
                private ["_id","_functime"];
                _id = _param;
                _param = CRB_PROFILER select _id;
                _start = _param select 1;
                _functime = diag_tickTime - _start;
                _param set [1,  _functime];
                CRB_PROFILER set [_id, _param];
                diag_log format ["CRB_PROFILER,%1,%2", _param select 0, _param select 1];
        };
};

_result;
