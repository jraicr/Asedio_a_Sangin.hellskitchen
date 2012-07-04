#include <crbprofiler.hpp>

private ["_side","_position","_radius","_switch","_debug","_name","_currentFaction","_currentFactionCount","_factions","_afactions","_units","_facs","_factionsCount","_sidex"];

CRBPROFILERSTART("mso_core_fnc_getFactions")

_side = _this select 0;
if(count _this > 1) then {
        _position = _this select 1;
        _radius = _this select 2;
        _switch = _this select 3;
        _debug = _this select 4;
        _name = _this select 5;
};
_currentFactionCount = 0;
_factions = [];
_factionsCount = [];
_facs = [];

// get all factions
if(isNil "CRB_ALLFACS") then {
	CRB_ALLFACS = [] call BIS_fnc_getFactions;
	//hint str CRB_ALLFACS;
};

// Set factions to count
_sidex = 0;
switch (_side) do 
{
        case east: {
                _sidex = 0;
        };
        case west: {
                _sidex = 1;
        };
        case resistance: {
                _sidex = 2;
        };
        case civilian: {
                _sidex = 3;
        };
};
_afactions = [];
{
        private["_fx"];
        _fx = getNumber(configFile >> "CfgFactionClasses" >> _x >> "side");
        if (_fx == _sidex) then {
                _afactions set [count _afactions, _x];
        };
} forEach CRB_ALLFACS;
_facs = _afactions;

if(count _this > 1) then {
        _units = [_position, _radius] call mso_core_fnc_getUnitsInArea;
        // Count factions at location for side
        {
                _currentFaction = _x;	
                _currentFactionCount = {faction _x == _currentFaction} count _units;
                
                // Use the faction count as the bias - count factions
                If (_currentFactionCount > 0) then {
                        _factions set [count _factions, _currentFaction];
                        _factionsCount set [count _factionsCount, _currentFactionCount];
                };
        } foreach _afactions;
        
        // If there are no factions then set factions to civilian (default side)
        if (count _factions == 0) then {
                _factions = _afactions;
                {
                        _factionsCount = _factionsCount + [1];
                } forEach _afactions;
        };
        
        if (_debug) then {
                diag_log format ["MSO-%1 Factions: %2 will have this split: %3 , %4", time, _name, _factions, _factionsCount];
        };
        
        switch (_switch) do 
        {
                case "count": {_facs = _factionsCount};
                case "factions": {_facs = _factions};
        };
};

CRBPROFILERSTOP

_facs;