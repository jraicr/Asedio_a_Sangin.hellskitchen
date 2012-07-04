#define CT_STATIC			0
#define ST_PICTURE			48
#define ST_LEFT				0
#define CT_EDIT				2
#define CT_SLIDER			3
#define SL_HORZ           0x400
#define ST_CENTER         0x02
#define SL_DIR            0x400

class Colum_Soporte_Aer_Diag {
	idd = -1;
	movingEnable = "True";
	
	class RscText
	{
		type = CT_STATIC;
		idc = -1;
		style = ST_LEFT;
		colorBackground[] = {0, 0, 0, 0};
		colorText[] = {1, 1, 1, 1};
		font = "TahomaB";
		sizeEx = 0.05;
	};
	
	class FondoCuadro {
		idc = -1;
		type = CT_STATIC;  // defined constant
		style = ST_CENTER;  // defined constant
		colorText[] = { 0, 0, 0, 1 };
		colorBackground[] = { 0.1, 0.1, 0.1, 0.6 };
		font = "TahomaB";
		sizeEx = 0.023;
		x = 0.3; y = 0.1;
		w = 0.4;  h = 0.03;
		text = "";
	};

	
	class RscButton 
	{
		type = 1;
		idc = -1;
		style = 2;
		x = 0.1;
		y = 0.1;
		w = 0.1;
		h = 0.1;
		sizeEx = 0.03;
		borderSize = 0.001;
		colorText[] = {0.82, 1.0, 0.82, 1.0};
		colorDisabled[] = {0.82, 1.0, 0.82, 1.0};
		colorBackground[] = {0.24, 0.5, 0.24, 1.0};
		colorBackgroundActive[] = {0.2, 0.5, 0.2, 1.0};
		colorBackgroundDisabled[] = {0.82, 1.0, 0.82, 1.0};
		colorFocused[] = {0.2, 0.5, 0.2, 1.0};
		colorShadow[] = {0.1, 0.1, 0.1, 1};
		colorBorder[] = {0, 0, 0, 0};
		offsetX = 0.003;
		offsetY = 0.003;
		offsetPressedX = 0.002;
		offsetPressedY = 0.002;
		font = "TahomaB";
		soundEnter[] = {"\ca\ui\data\sound\mouse2", 0.09, 1};
		soundPush[] = {"\ca\ui\data\sound\new1", 0.09, 1};
		soundClick[] = {"\ca\ui\data\sound\mouse3", 0.07, 1};
		soundEscape[] = {"\ca\ui\data\sound\mouse1", 0.09, 1};
		default = "false";
		text = "";
		action = "";
	};
	
	class MySlider {
		idc = -1;
		type = CT_SLIDER;
		style = SL_HORZ;
		x = 0.4; 
		y = 0.2; 
		w = 0.3; 
		h = 0.025; 
		color[] = { 1, 1, 1, 1 }; 
		coloractive[] = { 1, 0, 0, 0.5 };
		onSliderPosChanged = "";
	};
	
	
	class TextBoxEdit
	{
		idc = -1;
		type =2;
		style =0;
		x = 0.1;
		y = 0.1;
		w = 0.2;
		h = 0.4;
		sizeEx = 0.05;
		font = "TahomaB";
		text = "";
		colorText[] = {1,1,1,1};
		
		autocomplete = false;
		colorSelection[] = {0,0,0,1};
	};

	objects[] = {};
	controls[] = { "Fondo","BotonPedir","BotonCancelar", "TextoDistancia",  "TextoVDistancia", "TextoDirec" , "SliderDistancia", "TextoVDirec","SliderDirec"};
	

	class Fondo: FondoCuadro
		{
			sizeEx = 0.02;
			text="";
			x=0.17;
			y=0.35;
			w=0.6;
			h=0.5;
		};	
	class BotonPedir: RscButton
		{
			
			sizeEx = 0.02;
			text="Pedir Soporte";
			x=0.21;
			y=0.65;
			w=0.13;
			h=0.07;
			action = "[( ctrlText 367),(ctrlText 365),0,1] ExecVM 'Scripts\apoyo\SoporteAereo\Accion.sqf';closedialog 0;";
			//action = "hint lbValue [364, index]";
		};
		
	class BotonCancelar: RscButton
		{
			sizeEx = 0.02;
			text="Cancelar";
			x=0.58;
			y=0.65;
			w=0.13;
			h=0.07;
			action = "closedialog 0;";
		};
		
	class TextoDistancia: RscText
		{
			sizeEx = 0.02;
			text="Distancia";
			x=0.17;
			y=0.45;
			w=0.3;
			h=0.07;
		};
		
	class SliderDistancia: MySlider
		{
			idc = 364;
			sizeEx = 0.02;
			x=0.28;
			y=0.45;
			w=0.4;
			h=0.07;
			onSliderPosChanged = "ctrlSetText [365, str( (_this select 1) *100)]";
		};
		
	class TextoVDistancia: TextBoxEdit
		{
			idc = 365;
			sizeEx = 0.02;
			text="0";
			x=0.69;
			y=0.45;
			w=0.07;
			h=0.05;
		};
		
		//Direccion
	class TextoDirec: RscText
		{
			sizeEx = 0.02;
			text="Direccion";
			x=0.17;
			y=0.55;
			w=0.3;
			h=0.07;
		};
		
	class SliderDirec: MySlider
		{
			idc = 366;
			sizeEx = 0.02;
			x=0.28;
			y=0.55;
			w=0.4;
			h=0.07;
			onSliderPosChanged = "ctrlSetText [367, str( (_this select 1) *36)]";
		};
		
	class TextoVDirec: TextBoxEdit
		{
			idc = 367;
			sizeEx = 0.02;
			text="0";
			x=0.69;
			y=0.55;
			w=0.07;
			h=0.05;
		};
		
};	
	


