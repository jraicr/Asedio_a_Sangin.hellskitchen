
private ["_worldpos","_PS","_PSlist","_pos","_mode","_obj","_logic","_red","_green","_blue","_max","_min","_flperc","_flvar","_proclight","_destroyed","_candle","_incan","_tv","_ratio","_lightarray"];
scriptName "Alice\data\scripts\fnc_houseEffects.sqf";
/*
File: fnc_houseEffects.sqf
Author: Karel Moricky

Description:
Creates effects on house (lights in windows, chimney smoke)

Parameter(s):
_this: OBJECT - house
*/

_mode = _this select 0;
_obj = _this select 1;
_logic = bis_alice_mainscope;

/*
TPW HOUSELIGHTS v 1.03
This script causes flickering lights to automatically come on in enterable buildings.
Please feel free to modify and improve this script, on the proviso that you post your improvements for others to benefit from.
Thanks:
* Rydygier for the inspiration for the flickering code
* RogueTrooper for the improved code for determining enterable buildings

TPW 20120519
*/  

/*LIGHT-TYPE VALUES
Light-type will be picked at random.
Each individual light array consists of: [red,green,blue,maximum brightness,minimum brightness,%chance of flickering,%brightness to flicker]
Example: [255,127,24,60,30,80,10] = warm yellow, brightness between 20-60, 80% chance of flickering, 10% brightness variation when flickering
red, green and blue values are 0-255
brightness values are 0-255
flickering values are 0-100
Light sources don't really stress the engine, but flickering lightsources can. If you want no flickering, set all %chance of flickering values to 0. 
*/

_candle =[255,127,24,60,30,80,10]; //warm yellow/orange (candle or fire)
_incan = [255,200,100,60,30,20,5]; //yellow/white (incandesecent)
_tv = [100,200,255,60,30,100,30]; //blue/white (television or fluorescent)
_ratio = [4,2,1]; //ratio of candle:incan:tv

//////////////////////////////////////////
//PROCESS LIGHT ARRAYS INTO USEABLE VALUES
//////////////////////////////////////////
_lightarray = [];
for "_x" from 1 to (_ratio select 0) do {_lightarray set [count _lightarray, _candle]};
for "_x" from 1 to (_ratio select 1) do {_lightarray set [count _lightarray, _incan]};
for "_x" from 1 to (_ratio select 2 )do {_lightarray set [count _lightarray, _tv]};

if(isNil "tpw_proclightarray") then {
        tpw_proclightarray = [];
        {
                _red = _x select 0; _red = _red /255;
                _green = _x select 1; _green = _green/255;
                _blue = _x select 2; _blue = _blue/255;
                _max = _x select 3;
                _min = _x select 4;
                _flperc = _x select 5;
                _flvar = _x select 6; _flvar = _flvar/100;
                _proclight = [_red,_green,_blue,_max,_min,_flperc,_flvar];
                tpw_proclightarray set [count tpw_proclightarray, _proclight];
        } foreach _lightarray;
};

//////////////////
//FLICKER FUNCTION
//////////////////
tpw_flicker = {
        private ["_op","_brmax","_slp","_inc","_brmin","_br2","_lt0","_br","_fv","_rng"];
        _lt0 = _this select 0;
        _br = _this select 1;
        _fv = _this select 2;
        
        _rng = _br * _fv;
        _brmax = (_br + _rng);
        _brmin = (_br - _rng);
        _op = 1;
        _inc = _rng/(random 10); 
        _slp = random 5;
        _br2 = _br;
        while {not (isNull _lt0)} do
        {
                _br2 = _br2 + (_op * _inc);    
                _lt0 setLightBrightness _br2; 
                if (_br2 > _brmax) then {_op = -1;_brmax = _br + (random _rng);_slp = random 0.2;_inc = _rng/((random 10) + 1);}; 
                if (_br2 < _brmin) then {_op = 1;_brmin = _br - (random _rng);_slp = random 0.2;_inc = _rng/((random 10) + 1);};
                sleep 1 + _slp;
        };
};

switch (_mode) do {
        
        //--- START
        case 1: {
                //--- Partcile Sources
                _PSlist = [];
                for "_i" from 0 to 10 do {
                        _pos = _obj selectionposition format ["AIChimney_small_%1",_i];
                        if (_pos distance [0,0,0] == 0) exitwith {};
                        
                        if (random 1 > 0.5) then {
                                _worldpos = (_obj modeltoworld _pos);
                                
                                _PS = "#particlesource" createVehicleLocal _worldpos;
                                _PS setParticleCircle [0, [0, 0, 0]];
                                _PS setParticleRandom [1, [0, 0, 0], [0.1, 0.1, 0.1], 2, 0.2, [0.05, 0.05, 0.05, 0.05], 0, 0];
                                _PS setParticleParams [["\Ca\Data\ParticleEffects\Universal\universal.p3d", 16, 8, 16], "", "Billboard", 1, (4 + random 4), [0,0,0], [0, 0, 0.5 + random 0.5], 1, 1.275, 1, 0.066, [0.4, 1 + random 0.5, 2 + random 2], [[0.4, 0.4, 0.4*1.2, 0.1 + random 0.1], [0.5, 0.5, 0.5*1.2, 0.05 + random 0.05], [0.7, 0.7, 0.7*1.2, 0]], [0], 1, 0, "", "", ""];
                                _PS setDropInterval .3;
                                _PSlist set [count _PSlist, _PS];
                        };
                        
                };
                _obj setvariable ["BIS_ALICE_PS",_PSlist];
                
                //--- Global manager of house effects
                if (isnil {_logic getvariable "ALICE_houseffects"}) then {
                        _logic spawn {
                                
                                private ["_limit","_obj","_list","_logic","_pos","_light","_r","_g","_b","_col","_max","_min","_flperc","_flvar","_br","_lp"];
                                scriptname "Alice\data\scripts\fnc_houseEffects.sqf:Loop";
                                _logic = _this;
                                while {true} do {
                                        _list = _logic getvariable "ALICE_houseffects";
                                        _delay = 100 / (count _list + 1);
                                        {
                                                _obj = _x;
                                                if(!isNil {_obj getVariable "BIS_ALICE_PS"}) then {
                                                        _limit = 0.5;
                                                        if (daytime > 17 && daytime < 21) then {_limit = 0.2};
                                                        if (daytime > 0 && daytime < 4) then {_limit = 1};
                                                        
                                                        if ((_obj buildingPos 2) select 0 == 0)  then {
                                                                //--- Let there be the light!
                                                                for "_i" from 1 to 5 do {
                                                                        if (random 1 > _limit) then {
                                                                                _obj animate [format ["Lights_%1",_i],1];
                                                                        } else {
                                                                                _obj animate [format ["Lights_%1",_i],0];
                                                                        };
                                                                };
                                                        } else {
                                                                _pos = getpos _obj;
                                                                if (random 1 > _limit) then {
                                                                        _light = tpw_proclightarray call BIS_fnc_selectRandom; // Select light type
                                                                        _r = _light select 0;_g = _light select 1;_b = _light select 2;_col = [_r,_g,_b]; // Light colour values
                                                                        _max = _light select 3;_min = _light select 4;// Light brightness range
                                                                        _flperc = _light select 5;_flvar = _light select 6;// Light flickering parameters
                                                                        _br = 0.1 * ((_min + (random (_max - _min)))/255); // Random brightness between specified range    
                                                                        _lp = "#lightpoint" createVehicleLocal _pos; // Create light
                                                                        _lp setLightBrightness _br; // Set its brightness
                                                                        _lp setLightColor _col; // Set its colour
                                                                        _lp lightAttachObject [_x, [random 2,random 2,1]]; // Place it at a random position within house 
                                                                        if ((random 100) < _flperc) then {[_lp,_br,_flvar] spawn tpw_flicker}; // Set appropriate flicker for light type
                                                                        [_obj,"BIS_ALICE_PS",[_lp]] call bis_fnc_variablespaceadd;
                                                                };
                                                        };
                                                        sleep 1 + random _delay;
                                                };
                                        } foreach _list;
                                        sleep random 15;
                                        waituntil {sleep 15; daytime > 17 || daytime < 4};
                                };
                        };
                        _logic setvariable ["ALICE_houseffects",[]];
                };
                [_logic,"ALICE_houseffects",[_obj]] call bis_fnc_variablespaceadd;
        };
        
        //--- END
        case 0: {
                _destroyed = if (count _this > 2) then {_this select 2} else {false};
                
                [_logic,"ALICE_houseffects",[_obj]] call bis_fnc_variablespaceremove;
                
                _PSlist = _obj getvariable "BIS_ALICE_PS";
                if (!isnil "_PSlist") then {
                        {deletevehicle _x} foreach _PSlist;                        

                        for "_i" from 1 to 5 do {
                                _obj animate [format ["Lights_%1",_i],0];
                        };
                };
                _obj setvariable ["BIS_ALICE_PS",nil];
                
        };
        
        default {};
};