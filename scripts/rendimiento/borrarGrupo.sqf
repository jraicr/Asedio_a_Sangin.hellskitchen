//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
//////////////////////////////////////////////////////////////////

if (isServer) then {
	_unidad = _this select 0;
	_grupo = group _unidad;
	
	sleep 10; //importante no borrar para no dejar colgados otros scripts
	
	{
		_vehiculo = vehicle _x;
		if (not isNull _vehiculo) then {deleteVehicle _vehiculo;};
		if (not isNull _x) then {deleteVehicle _x};
	} forEach units _grupo;
	deleteGroup _grupo; 
};

