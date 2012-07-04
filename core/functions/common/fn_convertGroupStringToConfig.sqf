scriptName "ambient_combat\data\scripts\functions\convertGroupStringToConfig.sqf";
/*
	File: convertGroupStringToConfig.sqf
	Author: Joris-Jan van 't Land

	Description:
	Using this function it's possible to convert a CfgGroups name (String) to the 
	corresponding CfgGroups Config entry.

	Parameter(s):
	_this: CfgGroups class name (String)
	
	Returns:
	Config corresponding entry
*/

private ["_name", "_return"];
_name = _this;

if ((typeName _name) != (typeName "")) exitWith {debugLog "Log: [convertGroupStringToConfig] Name (0) must be a String!"; nil};

scopeName "root";

private ["_cfgGroups"];
_cfgGroups = configFile >> "CfgGroups";
for "_i" from 0 to ((count _cfgGroups) - 1) do {
	private ["_cfgSide"];
	_cfgSide = _cfgGroups select _i;
	for "_y" from 0 to ((count (_cfgGroups select _i)) - 1) do {
		private ["_cfgFaction"];
		_cfgFaction = _cfgSide select _y;
		
		if (isClass _cfgFaction) then {
			{
				private ["_cfgType"];
				_cfgType = _cfgFaction >> _x;
				for "_i" from 0 to ((count _cfgType) - 1) do 
				{
					private ["_class"];
					_class = _cfgType select _i;
					
					if (isClass (_class)) then 
					{
						if ((configName _class) == _name) then 
						{
							_return = _class;
							breakTo "root";
						};
					};
				};
			}	
			forEach ["Infantry", "Motorized", "Mechanized", "Armored", "Air"];
		};
	};
};
_return