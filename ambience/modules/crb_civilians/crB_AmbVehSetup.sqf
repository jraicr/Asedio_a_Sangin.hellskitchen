//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: (AEF)Wolffy.au
// Created: 20110315
// Modified: 20110925
// Contact: http://dev-heaven.net/projects/mip
// Purpose: Setup amibent civilian vehicles module
///////////////////////////////////////////////////////////////////

waitUntil{!isNil "BIS_fnc_init"};
waitUntil{!isNil "BIS_silvie_mainscope"};

// http://community.bistudio.com/wiki/Ambient_Civilian_Vehicles
BIS_silvie_mainscope setVariable ["debug", true, true];

// list of places where vehicles will be spawned. Can be location logic (created by BIS_fnc_locations), array in format [center,distance] or trigger. 
// BIS_silvie_mainscope setVariable ["townlist", [bis_loc_acityc_mogilevka,[position this,3000],trigger1]]; 

// object classes which will be excluded from list of building around which cars are generated. 
// BIS_silvie_mainscope setVariable ["blackList", ["house1","house2"]]; 

// Changing vehicle rarity numbers (e.g. to have village cars spawned in cities, or to disable spawning of given class completely with unusual number like 10). Default rarity numbers are set in config under rarityUrban value (in range from 0/village to 1/city) 
// BIS_silvie_mainscope setVariable ["vehicleRarity",["skodaRed",10,"skodaBlue",0.8]]; 
// add motorbikes and bicycles to Ambient Vehicles
BIS_silvie_mainscope setVariable ["vehicleRarity",[
        "MMT_Civ ", 0,
        "TT650_Civ", 0,
        "TT650_TK_CIV_EP1", 0,
        "Old_bike_TK_CIV_EP1", 0,
        "Old_moto_TK_Civ_EP1", 0
]]; 

// formula on which basis system calculates number of vehicles for location. %1 is number of buildings (blacklisted objects are excluded) in 500 metres from location. 
// BIS_silvie_mainscope setVariable ["vehicleCount","round ((sqrt %1) * 1.5)"]; 
// Reduce vehicle count formula to try to reduce number of civilian vehicles
switch toLower(worldName) do {		
        case "chernarus": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 1.0)"];
        };
        case "eden": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 0.75)"];
        };
        case "fallujah": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 0.5)"];
        };
        case "mcn_hazarkot": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 1.5)"];
        };
        case "isladuala": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 2.0)"];
        };
        case "lingor": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 0.5)"];
        };
        case "takistan": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 0.5)"];
        };
        case "torabora": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 1.0)"];
        };
        case "utes": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 0.5)"];
        };
        case "zargabad": {
                BIS_silvie_mainscope setvariable ["vehicleCount","round ((sqrt %1) * 0.5)"];
        };
};

// custom init which is executed on every car. Vehicle can be accessed using _this variable. Init is executed as separate script, so sleep or waituntil commands can be used without limitations. 
// BIS_silvie_mainscope setVariable ["vehicleInit",{}]; 
// randomly lock and vary fuel

BIS_silvie_mainscope setVariable ["vehicleInit",{
_IED = _this;

_probabilidadIED = 75 + floor (random 25); // probabilidad de ser IED
_dificultadDesactivacion = 15 + floor (random 30); // Facilidad de desactivacion. 0 es practicamente imposible de desactivar, 100 bastante facil
_radioActivacion = 10 + floor (random 40); //Radio de activacion. Si X(parametro 7) soldados o un vehiculo se acercan mas de este radio, el IED explotara
_potenciaExplosion = 1 + floor (random 6); // Potencia de la explosion , de 1 a 7
_mostrarIED = false; // Mostrar o no mostrar el mensaje en IEDs inactivos. Si se pone True, los IEDs siempre tendran la opcion de desactivar esten activos o no, si esta a false solo los IEDs activos tendran la opcion.
_maxSoldadosCerca = 1 + floor (random 3); // Numero maximo de soldados que se pueden acercar al IED. Por ejemplo si se pone 1, solo 1 soldado se podra acercar al IED sin detonarlo.
_tiempoDetonacion = 5 + floor (random 7); //Tiempo aleatorio maximo antes de detonar el IED. Una vez dentro del radio de activacion y cumplidas una de las condiciones
	if(random 1 > 0.6) then {
		clearMagazineCargo _this;
		clearWeaponCargo _this;
	};
        if (random 1>0.6) then {
                _this lock true;
        } else {
		// zGuba: enabled random damage and fuel
		_this setFuel 0.5 + ((random 1)^3 - (random 1)^3)/2;
		_this setDamage (random 0.5)^2;	// Up to 25% worn out
        };
		// 10% (set in params) chance its a VB-IED (radio controlled if EOD) - never a bike
		if (isNil "nivelAmenaza_IED")then{nivelAmenaza_IED = 25;};
		If ((random 100 < nivelAmenaza_IED) && (nivelAmenaza_IED > 0) && !(_this iskindOf "Motorcycle")) then {
			_this lock true;
			//http://www.ust101.com/phpBB3/viewtopic.php?f=18&t=311
			[_IED,_probabilidadIED,_dificultadDesactivacion,_radioActivacion,_potenciaExplosion,_mostrarIED,_maxSoldadosCerca,_tiempoDetonacion] execVM "scripts\IED\InitIED.sqf";
		};
        _this addEventHandler ["Engine", {
                if(_this select 1) then {
                        driver (_this select 0) addRating -400;
                };
        }];

	// zGuba: HitParts members for class Car, usually common
	_zgb_hitparts_car = ["HitEngine","HitRGlass","HitLGlass","HitBody","HitFuel","HitLFWheel","HitRFWheel","HitLF2Wheel","HitRF2Wheel","HitLMWheel","HitRMWheel","HitLBWheel","HitRBWheel","HitGlass1","HitGlass2","HitGlass3","HitGlass4"];
        {
                _this setHit [_x,(random 0.75)^3];
        } forEach _zgb_hitparts_car;	// Up to 42,1875% worn out
}];

// when creating car around building, if there is some road closer than this value, vehicle will be attached to this road instead of to building. 
// BIS_silvie_mainscope setVariable ["roadDistance",25]; 

// number of attempts to create vehicle (failed attempt is for instance when some road is detected near building, but it's crossroad). 
// BIS_silvie_mainscope setVariable ["attempts",10]; 
