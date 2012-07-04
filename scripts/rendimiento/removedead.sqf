//////////////////////////////////////////////////////////////////
// Function file for Armed Assault
// Created by: TODO: Author Name
// *******************************************************************************
// **        Script: RemoveDead.sqf
// **   Descripcion: Remoción de unidades eliminadas según su clase
// *******************************************************************************
// **         Autor: RAVEN
// **          Site: www.ArmedAssault.com.ar/Foros
// *******************************************************************************
// **    Invocación: En campo de inicio de unidad
// **         this addeventhandler ["Killed", {_this execVM "RemoveDead.sqf"}]
// *******************************************************************************

_unit = _this select 0;

private["_esMan","_demora","_pos","_px","_py","_pz"];

_esMan = false;
_demora = 100;
if ("MAN"  counttype [_unit] > 0) then {_demora = 300; _esMan = true};
if ("CAR"  counttype [_unit] > 0) then {_demora = 300};
if ("TANK" counttype [_unit] > 0) then {_demora = 300};
if ("AIR"  counttype [_unit] > 0) then {_demora = 300};

waitUntil {(velocity _unit select 0) + (velocity _unit select 1) + (velocity _unit select 2) == 0};

_pos = GetPosAsl _unit;
_px = _pos select 0; _py = _pos select 1; _pz = _pos select 2;

sleep _demora;
if (_esMan) then
{
   _unit SetPosASL [_px, _py, 0];
   hidebody _unit;
   
};
deletevehicle _unit;