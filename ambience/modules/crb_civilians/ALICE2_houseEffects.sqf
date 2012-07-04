#include <crbprofiler.hpp>

///////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: BIS
// Customised for OA by (AEF)Wolffy.au
// Created: 20110315
// Contact: http://dev-heaven.net/projects/mip
// Purpose: Enable house effects for ALICE2 module
// Modified: 20110925
///////////////////////////////////////////////////////////////////

private ["_allTopics","_endSentences","_tempArray","_element","_type","_topic","_path","_category","_screams","_scream","_categoryId","_oldScreams","_allScreams","_Remarks","_oldRemarks","_allRemarks","_civilianConversations","_civilianScreams","_civilianRemarks","_source","_logic","_allConversations","_kbCategories"];

if(isDedicated) exitWith{};

waitUntil {!isNil "BIS_fnc_init"};
waitUntil {!isNil "BIS_Alice_mainscope"};
_logic = BIS_Alice_mainscope;

///////////////////////////////////////////////////////////////////////////////////
///// Civilian Actions
///////////////////////////////////////////////////////////////////////////////////
/*
_allActionsx = _logic getvariable ["ALICE_actionsx", []];
_allActions = _logic getvariable ["ALICE_actions", []];
_actionCategories = _logic getvariable "civilianActions";

for "_i" from 0 to 2 do {
        _source = [configfile,missionconfigfile,campaignconfigfile] select _i;
        _tempArrayx = [];
        {
                _civilianActions = _source >> "CfgCivilianActions" >> _x;
                if (str _civilianActions != "") then {
                        _tempArrayx = _tempArrayx + [_civilianActions];
                        for "_i" from 0 to (count _civilianActions - 1) do {
                                _action = _civilianActions select _i;
                                if (isclass _action) then {
                                        _condition = gettext(_action >> "condition");
                                        _fsm = gettext(_action >> "fsm");
                                        _rarity = getnumber(_action >> "rarity");
                                        _locked = getnumber(_action >> "locked");
                                        _canrepeat = getnumber(_action >> "canRepeat");
                                        _initVariables = getarray(_action >> "initVariables");
                                        _init = gettext(_action >> "init");
                                        _allActions = _allActions + [
                                                [
                                                        _action, // 0
                                                        configname _action, // 1
                                                        _condition, // 2
                                                        _fsm, // 3
                                                        _rarity, // 4
                                                        _locked, // 5
                                                        _canrepeat, // 6
                                                        _initVariables, // 7
                                                        _init // 8
                                                ]
                                        ];
                                };
                        };
                };
        } foreach _actionCategories;
        _allActionsx = _allActionsx + [_tempArrayx];
};
_logic setvariable ["ALICE_actionsx",_allActionsx];
_logic setvariable ["ALICE_actions",_allActions];
*/

///////////////////////////////////////////////////////////////////////////////////
///// Civilian Conversations
///////////////////////////////////////////////////////////////////////////////////

_allConversations = _logic getVariable ["ALICE_conversations", [[],[],[],[]]];
_allTopics = _logic getVariable ["ALICE_topics", []];
_allScreams = _logic getVariable ["ALICE_screams", []];
_allRemarks = _logic getVariable ["ALICE_remarks", []];
_kbCategories = _logic getVariable ["civilianConversations",[]];

for "_i" from 0 to 2 do {
        _source = [configFile,missionConfigFile,campaignConfigFile] select _i;
        _tempArray = [];
        {
                _civilianConversations = _source >> "CfgCivilianConversations" >> _x;
                for "_i" from 0 to (count _civilianConversations - 1) do {
                        
                        _topic = "ALICE_" + (configName _civilianConversations);
                        _path = getText (_civilianConversations >> "path");
                        if !(_topic in _allTopics) then {_allTopics = _allTopics + [_topic,_path]};
                        
                        _category = _civilianConversations select _i;
                        if (isClass _category) then {
                                _type = getNumber (_category >> "type");
                                _tempArray = _allConversations select _type;
                                
                                for "_c" from 0 to (count _category - 1) do {
                                        _element = _category select _c;
                                        if (isClass _element) then {
                                                _endSentences = getArray (_element >> "endSentences");
                                                _tempArray = _tempArray + [[(configName _civilianConversations),configName _element,_endSentences]];
                                        };
                                };
                                _allConversations set [_type,_tempArray];
                        };
                        
                        
                };
                
                //--- Screams
                _civilianScreams = _source >> "CfgCivilianScreams" >> _x;
                _screams = [];
                for "_i" from 0 to (count _civilianScreams - 1) do {
                        _scream = _civilianScreams select _i;
                        if (isClass _scream) then {
                                _screams = _screams + [configName _scream];
                        };
                };
                if (_x in _allScreams) then {
                        _categoryId = (_allScreams find _x) + 1;
                        _oldScreams = _allScreams select _categoryId;
                        _allScreams set [_categoryId,_oldScreams + _screams];
                } else {
                        _allScreams = _allScreams + [_x,_screams];
                };
                
                //--- Remarks
                _civilianRemarks = _source >> "CfgCivilianRemarks" >> _x;
                _Remarks = [];
                for "_i" from 0 to (count _civilianRemarks - 1) do {
                        _scream = _civilianRemarks select _i;
                        if (isClass _scream) then {
                                _Remarks = _Remarks + [configName _scream];
                        };
                };
                if (_x in _allRemarks) then {
                        _categoryId = (_allRemarks find _x) + 1;
                        _oldRemarks = _allRemarks select _categoryId;
                        _allRemarks set [_categoryId,_oldRemarks + _Remarks];
                } else {
                        _allRemarks = _allRemarks + [_x,_Remarks];
                };
        } forEach _kbCategories;
};
_logic setVariable ["ALICE_conversations",_allConversations,true];
_logic setVariable ["ALICE_screams",_allScreams,true];
_logic setVariable ["ALICE_remarks",_allRemarks,true];
_logic setVariable ["ALICE_topics",_allTopics,true];

[_logic] spawn {
        private ["_twnEffects","_twn","_logic","_houses"];
        _logic = _this select 0;
        _twnEffects = [];
        while{!isNil "BIS_ALICE_fnc_houseEffects"} do {
                CRBPROFILERSTART("ALICE2_houseEffects")
                
                {
                        _twn = _x;
                        
                        if(!(_twn getVariable "ALICE_active") && (_twn in _twnEffects)) then {
                                _twnEffects = _twnEffects - [_twn];
                        };
                        
                        if((_twn getVariable "ALICE_active") && !(_twn in _twnEffects)) then {
                                _twnEffects set [count _twnEffects, _twn];
                                _houses = _twn getVariable ["ALICE_houselist", []];
                                
                                {
                                        [_x, _twn] spawn {
                                                private ["_house","_timeStop","_randomValue","_daytimeStart","_daytimeEnd","_rain","_overcast","_fog","_twn"];
                                                _house = _this select 0;
                                                _twn = _this select 1;
                                                //diag_log format["MSO-%1 houseEffect: started %2 %3", time, _door, position _door];
                                                [1,_house] spawn BIS_ALICE_fnc_houseEffects;
                                                _timeStop = time + ((random 30) * 60);
                                                _randomValue = random 1;
                                                _daytimeStart = 5 + 4*_randomValue;
                                                _daytimeEnd = 18 + 2*_randomValue;
                                                _rain = 0.2*_randomValue;
                                                _overcast = 0.8 + 0.2*_randomValue;
                                                _fog = 0.8 + 0.2*_randomValue;
                                                
                                                waitUntil{sleep 15;!alive _house || time > _timeStop || 
                                                ((dayTime >=_daytimeStart && dayTime <= _daytimeEnd) &&
                                                rain <= _rain &&
                                                overcast <= _overcast &&
                                                fog <= _fog) ||
                                                !(_twn getVariable "ALICE_active") };
                                                [0,_house] spawn BIS_ALICE_fnc_houseEffects;
                                                //diag_log format["MSO-%1 houseEffect: stopped %2", time, _door];
                                        };
                                } forEach _houses;
                        };
                } forEach (_logic getvariable "ALICE_alltowns");
                CRBPROFILERSTOP
                
                sleep 15;
        };
};