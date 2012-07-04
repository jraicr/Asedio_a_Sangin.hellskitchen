private["_name","_exp"];
_name = _this select 0;
_exp = _this select 1;

if(isNil "BIS_MENU_GroupCommunication") then {
	//Create the comms menu on all machines.
	[] call BIS_fnc_commsMenuCreate;
};

BIS_MENU_GroupCommunication = BIS_MENU_GroupCommunication + [
        [_name,[count BIS_MENU_GroupCommunication + 1],"",-5,[["expression",_exp]],"1","1"]
];
