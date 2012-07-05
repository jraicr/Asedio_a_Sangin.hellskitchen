///////////////////////////////////////////////////////////////////////////
/// Styles
///////////////////////////////////////////////////////////////////////////

// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4


class colum_class_bomba_dialog 
{
	idd = 48620;
///////////////////////////////////////////////////////////////////////////
/// Base Classes
///////////////////////////////////////////////////////////////////////////
	class RscText
	{
		access = 0;
		type = 0;
		idc = -1;
		colorBackground[] = {0,0,0,0};
		colorText[] = {0.8784,0.8471,0.651,1};
		text = "";
		fixedWidth = 0;
		x = 0;
		y = 0;
		h = 0.037;
		w = 0.3;
		style = 0;
		shadow = 2;
		font = "Zeppelin32";
		SizeEx = 0.07;
	};
	class RscStructuredText
	{
		access = 0;
		type = 13;
		idc = -1;
		style = 0;
		colorText[] = {0.8784,0.8471,0.651,1};
		class Attributes
		{
			font = "Zeppelin32";
			color = "#e0d8a6";
			align = "center";
			shadow = 1;
		};
		x = 0;
		y = 0;
		h = 0.035;
		w = 0.1;
		text = "";
		size = 0.03921;
		shadow = 2;
	};
	class RscPicture
	{
		access = 0;
		type = 0;
		idc = -1;
		style = 48;
		colorBackground[] = {0,0,0,0};
		colorText[] = {1,1,1,1};
		font = "TahomaB";
		sizeEx = 0;
		lineSpacing = 0;
		text = "";
		fixedWidth = 0;
		shadow = 0;
		x = 0;
		y = 0;
		w = 0.2;
		h = 0.15;
	};
	class RscButton
	{
		access = 0;
		type = 1;
		text = "";
		colorText[] = {1,1,1,0};
		colorDisabled[] = {1,1,1,0};
		colorBackground[] = {1,1,1,0};
		colorBackgroundDisabled[] = {1,1,1,0};
		colorBackgroundActive[] = {1,1,1,0};
		colorFocused[] = {1,1,1,0};
		colorShadow[] = {1,1,1,0};
		colorBorder[] = {1,1,1,0};
		soundEnter[] = {"",0.09,1};
		soundPush[] = {"",0.09,1};
		soundClick[] = {"\ca\ui\data\sound\new1",0.07,1};
		soundEscape[] = {"",0.09,1};
		style = 2;
		x = 0;
		y = 0;
		w = 0.095589;
		h = 0.039216;
		shadow = 2;
		font = "Zeppelin32";
		sizeEx = 0.03921;
		offsetX = 0.003;
		offsetY = 0.003;
		offsetPressedX = 0.002;
		offsetPressedY = 0.002;
		borderSize = 0;
	};
	

///////////////////////////////////////////////////////////////////////////
/// Dialog
///////////////////////////////////////////////////////////////////////////
	objects[] = {};
	controls[] = { 
"colum_class_bomba_fondo","colum_class_bomba_Display",
"RscButton_1600","RscButton_1601","RscButton_1602","RscButton_1603",
"colum_class_bomba_Corte1","colum_class_bomba_Corte2","colum_class_bomba_Corte3","colum_class_bomba_Corte4",
"colum_class_bomba_Luz1", "colum_class_bomba_Luz2","colum_class_bomba_Luz3",
"colum_class_bomba_Luz4"};
	class colum_class_bomba_fondo: RscPicture
	{
		idc = 1200;
		text = "Scripts\IED\Images\bomba.paa";
		x = 0.271447 * safezoneW + safezoneX;
		y = 0.227011 * safezoneH + safezoneY;
		w = 0.458796 * safezoneW;
		h = 0.697167 * safezoneH;
	};

	class colum_class_bomba_Display: RscText
	{
		idc = 1001;
		text = "BOMB ARMED";
		x = 0.51 * safezoneW + safezoneX;
		y = 0.358151 * safezoneH + safezoneY;
		w = 0.120238 * safezoneW;
		h = 0.0530745 * safezoneH;
	};
	class colum_class_bomba_Corte1: RscPicture
	{
		idc = 1201;
		text = "Scripts\IED\Images\cableamarillo.paa";
		x = 0.484523 * safezoneW + safezoneX;
		y = 0.564737 * safezoneH + safezoneY;
		w = 0.0113096 * safezoneW;
		h = 0.0311783 * safezoneH;
	};
	class colum_class_bomba_Corte2: RscPicture
	{
		idc = 1202;
		text = "Scripts\IED\Images\cableverde.paa";
		x = 0.539955 * safezoneW + safezoneX;
		y = 0.561226 * safezoneH + safezoneY;
		w = 0.0119046 * safezoneW;
		h = 0.0349863 * safezoneH;
	};
	class colum_class_bomba_Corte3: RscPicture
	{
		idc = 1203;
		text = "Scripts\IED\Images\cableazul.paa";
		x = 0.593454 * safezoneW + safezoneX;
		y = 0.560929 * safezoneH + safezoneY;
		w = 0.0119047 * safezoneW;
		h = 0.0368902 * safezoneH;
	};
	class colum_class_bomba_Corte4: RscPicture
	{
		idc = 1204;
		text = "Scripts\IED\Images\cablerojo.paa";
		x = 0.648809 * safezoneW + safezoneX;
		y = 0.562833 * safezoneH + safezoneY;
		w = 0.0119048 * safezoneW;
		h = 0.0340342 * safezoneH;
	};
	class colum_class_bomba_Luz1: RscPicture
	{
		idc = 1205;
		text = "Scripts\IED\Images\verde.paa";
		x = 0.48631 * safezoneW + safezoneX;
		y = 0.4524 * safezoneH + safezoneY;
		w = 0.010119 * safezoneW;
		h = 0.0168983 * safezoneH;
	};
	class colum_class_bomba_Luz2: RscPicture
	{
		idc = 1206;
		text = "Scripts\IED\Images\verde.paa";
		x = 0.540476 * safezoneW + safezoneX;
		y = 0.4524 * safezoneH + safezoneY;
		w = 0.010119 * safezoneW;
		h = 0.0168983 * safezoneH;
	};
	class colum_class_bomba_Luz3: RscPicture
	{
		idc = 1207;
		text = "Scripts\IED\Images\verde.paa";
		x = 0.594643 * safezoneW + safezoneX;
		y = 0.4524 * safezoneH + safezoneY;
		w = 0.010119 * safezoneW;
		h = 0.0168983 * safezoneH;
	};
	class colum_class_bomba_Luz4: RscPicture
	{
		idc = 1208;
		text = "Scripts\IED\Images\verde.paa";
		x = 0.65 * safezoneW + safezoneX;
		y = 0.4524 * safezoneH + safezoneY;
		w = 0.010119 * safezoneW;
		h = 0.0168983 * safezoneH;
	};
	class RscButton_1600: RscButton
	{
		idc = 1600;
		x = 0.485119 * safezoneW + safezoneX;
		y = 0.4762 * safezoneH + safezoneY;
		w = 0.0142857 * safezoneW;
		h = 0.175884 * safezoneH;
		action = "0 spawn IED_Colum_Corta_Cable;";
	};
	class RscButton_1601: RscButton
	{
			idc = 1601;
			x = 0.538095 * safezoneW + safezoneX;
			y = 0.477152 * safezoneH + safezoneY;
			w = 0.0142857 * safezoneW;
			h = 0.175884 * safezoneH;
		action = "1 spawn IED_Colum_Corta_Cable;";
	};
	class RscButton_1602: RscButton
	{
			idc = 1602;
			x = 0.592857 * safezoneW + safezoneX;
			y = 0.478104 * safezoneH + safezoneY;
			w = 0.0142857 * safezoneW;
			h = 0.175884 * safezoneH;
		action = "2 spawn IED_Colum_Corta_Cable;";
	};
	class RscButton_1603: RscButton
	{
		idc = 1603;
		x = 0.648214 * safezoneW + safezoneX;
		y = 0.4762 * safezoneH + safezoneY;
		w = 0.0142857 * safezoneW;
		h = 0.175884 * safezoneH;
		action = "3 spawn IED_Colum_Corta_Cable;";
	};

};
