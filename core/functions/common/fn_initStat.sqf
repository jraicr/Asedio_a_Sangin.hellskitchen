private["_stage"];
_stage = format["Iniciando: %1", _this];

player createDiaryRecord ["msoPage", ["Estado de carga de la mision", 
        _stage
]]; 
titleText [_stage, "BLACK FADED"];