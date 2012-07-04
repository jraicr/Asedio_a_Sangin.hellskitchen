private ["_helicopter", "_duration", "_group", "_dt"];
_helicopter = _this select 0;
_duration = _this select 1;
_group = group driver _helicopter;

_group lockWP true;
_helicopter land "getout";
_dt = time + 300;
waituntil {sleep 1;landResult _helicopter == "Found" || landResult _helicopter == "NotFound" || not alive _helicopter || {alive _x} count (crew _helicopter) == 0 || _dt < time};

if (landResult _helicopter == "Found") then {
	waituntil {sleep 1;count ([_helicopter] unitsBelowHeight 2) > 0};
	sleep _duration;
};
_group lockWP false;