private ["_message"];
_message = _this select 0;

(if (count _this > 1) then {_this select 1} else {3}) spawn {
	private ["_wait"];
	_wait = diag_ticktime + _this;
	waitUntil {diag_ticktime > _wait};
	endLoadingScreen;
};
startLoadingScreen [_message, "RscDisplayLoadMission"];