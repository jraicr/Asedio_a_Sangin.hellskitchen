//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////


/*
0.25          190
0.216525	  255
0.18305	  320
0.149575      385
0.1161        450
0.091525      515
0.06695       580
0.06080625    596.25
0.0546625     612.5
0.042375      645
0.0300875     677.5
0.02394375    693.75
0.0178        710
*/

_fnc_vision_ok = compile preprocessFile "scripts\recon_facial\vision_ok.sqf";

_alcance = 0;
_alcance_ok = false;

_mes = date select 1;
if ([_mes, _this select 1] call _fnc_vision_ok) then {
	_alcance = _alcance + 15;
	_primaryWeapon = currentWeapon player;
	_tipo_optica = getText(configfile>>"cfgweapons">>_primaryWeapon>>"modeloptics");
	if (_tipo_optica != "-") then {
		if (cameraView == "GUNNER") then {		
			_zoom_max = getNumber(configfile>>"cfgweapons">>_primaryweapon>>"opticszoommin");
			if (_zoom_max <= 0.25) then {
				_alcance = _alcance + 190;
				if (_zoom_max <= 0.2165) then {
					_alcance = _alcance + 65;
					if (_zoom_max <= 0.183) then {
						_alcance = _alcance + 65;
						if (_zoom_max <= 0.1495) then {
							_alcance = _alcance + 65;
							if (_zoom_max <= 0.1161) then {
								_alcance = _alcance + 65;
								if (_zoom_max <= 0.0915) then {
									_alcance = _alcance + 65;
									if (_zoom_max <= 0.0669) then {
										_alcance = _alcance + 65;
										if (_zoom_max <= 0.0608) then {
											_alcance = _alcance + 16.25;
											if (_zoom_max <= 0.0546) then {
												_alcance = _alcance + 16.25;
												if (_zoom_max <= 0.0423) then {
													_alcance = _alcance + 32.5;
													if (_zoom_max <= 0.03) then {
														_alcance = _alcance + 32.5;
														if (_zoom_max <= 0.0239) then {
															_alcance = _alcance + 16.25;
															if (_zoom_max <= 0.0178) then {
																_alcance = _alcance + 16.25;
															};
														};
													};
												};
											};
										};
									};
								};
							};
						};
					};
				};
			};	
		};		
	};
}; 

_target = _this select 0;
_metros = player distance _target;

if (_alcance >= _metros) then {
	_alcance_ok = true;
} else {
	_alcance_ok = false;
};

_alcance_ok