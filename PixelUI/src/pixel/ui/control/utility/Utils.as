package pixel.ui.control.utility
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.ByteArray;
	
	import pixel.ui.control.*;
	import pixel.ui.control.style.*;
	import pixel.utility.Tools;

	public class Utils
	{
		public static const BUTTON:uint = 0;		//按钮
		public static const PANEL:uint = 1;		//面板
		//public static const HORIZONTALPANEL:uint = 2;	//横向面板
		//public static const VERTICALPANEL:uint = 3;		//纵向面板
		//public static const GRIDPANEL:uint = 4;			//网格面板
		public static const PROGRESS:uint = 5;			//加载进度条
		//public static const TABPANEL:uint = 6;			//TAB面板
		public static const SLIDER:uint = 7;			//拖拉条
		//public static const TABBAR:uint = 9;			//标签栏
		//public static const TAB:uint = 10;
		//public static const TABCONTENT:uint = 11;
		public static const LABEL:int = 12;			//文本
		public static const IMAGE:int = 13;			//图形
		public static const TEXTINPUT:int = 14;		//文本输入
		//public static const WINDOW:int = 15;			//窗口
		public static const COMBOBOX:int = 16;		//下拉框
		public static const COMBOBOXPOP:int = 17;		//下拉框弹出面板
		public static const VPANEL:int = 18;
		public static const CHECKBOX:int = 19;
		public static const CHECKBOXBTN:int = 20;
		public static const TOGGLE_BUTTON:int = 21;		//状态切换按钮
		public static const RADIO:int = 22;				//radio按钮
		public static const TOGGLEGROUP:int = 23;		//radio group
		public static const COLORFULLABEL:int = 24;		//Colorful label
		public static const SCALEBUTTON:int = 25;		//单图缩放按钮
		public static const MOVIECLIP:int = 26;			//Flash影片剪辑代理组件
		public static const IMAGENUMBER:int = 27;		//数字图片控件
		public static const PAGE_PANEL:int = 28;
		public static const BUTTON_FILTER:int = 29		//滤镜按钮
		public static const CUSTOMER:uint = 99;			//自定义控件
		
		public static const COLOR_FILTERS:Array = 
		[
			{
				id : "Gloomy",
				label : "暗淡",
				filter : new ColorMatrixFilter([0.48145,0.45705,0.0615,0,-30,0.23145,0.70705,0.0615,0,-30,0.23145,0.45705,0.3115,0,-30,0,0,0,1,0])
			},
			{
				id : "Gray",
				label : "灰化",
				filter : new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])
			},
			{
				id : "Bright",
				label : "明亮",
				filter : new ColorMatrixFilter([0.68887, 0.27423, 0.0369, 0, 10, 0.13887, 0.82423, 0.0369, 0, 10, 0.13887, 0.27423, 0.5869, 0, 10, 0, 0, 0, 1, 0])
			}
		]
		
		//暗淡滤镜
		public static const COLOR_FILTER_GLOOMY:String = "Gloomy";
		public static const COLOR_FILTER_GRAY:String = "Gray";
		public static const COLOR_FILTER_BRIGHT:String = "Bright";
		
		/**
		 * 对显示对象应用指定名称的滤镜
		 * 
		 **/
		public static function applyFilterByName(obj:DisplayObject,name:String):void
		{
			for each(var filter:Object in COLOR_FILTERS)
			{
				if(filter.id == name)
				{
					obj.filters = [filter.filter];
					return;
				}
			}
			obj.filters = [];
		}
		
		private static const CONTROLS:Object = {
			0 : {
				prototype : UIButton,
				styleName : "Button",
				style : UIButtonStyle
			},
			
			1 : {
				prototype : UIPanel,
				styleName : "Panel",
				style : UIPanelStyle
			},
			
			18 : {
				prototype : UIVerticalPanel,
				styleName : "VScrollPanel",
				style : UIVerticalPanelStyle
			},
			5 : {
				prototype : UIProgress,
				styleName : "Progress",
				style : UIProgressStyle
			},
			7 : {
				prototype : UISlider,
				styleName : "Slider",
				style : UISliderStyle
			},
			12 : {
				prototype : UILabel,
				styleName : "Label",
				style : UILabelStyle
			},
			13 : {
				prototype : UIImage,
				styleName : "Image",
				style : UIImageStyle
			},
			14 : {
				prototype : UITextInput,
				styleName : "TextInput",
				style : UITextInputStyle
			},
			16 : {
				prototype : UICombobox,
				styleName : "Combobox",
				style : UICombStyle
			},
			17 : {
				prototype : UIComboboxPop,
				styleName : "",
				style : UIStyle
			},
			19 : {
				prototype : UICheckBox,
				styleName : "Checkbox",
				style : UICheckButtonStyle
			},
			20 : {
				prototype : UICheckButton,
				styleName : "",
				style : UICheckButtonStyle
			},
			21 : {
				prototype : UIToggleButton,
				styleName : "ToggleButton",
				style : UIToggleButtonStyle
			},
			22 : {
				prototype : UIRadio,
				styleName : "Radio",
				style : UIRadioStyle
			},
			23 : {
				prototype : UIToggleGroup,
				styleName : "ToggleGroup",
				style : UIContainerStyle
			},
			24 : {
				prototype : UIColorfulLabel,
				styleName : "ColorfulLabel",
				style : UIStyle
			},
			25 : {
				prototype : UIScaleButton,
				styleName : "ScaleButton",
				style : UIScaleButtonStyle
			},
			26 : {
				prototype : UIMovieClip,
				styleName : "MovieClip",
				style : UIStyle
			},
			27 : {
				prototype : UIBitmapChar,
				styleName : "BitmapNumber",
				style : UIStyle
			},
			28 :
			{
				prototype : UIPaginationPanel,
				styleName : "",
				style : UIStyle
			},
			29 :
			{
				prototype : UIFilterButton,
				styleName : "UIFilterButton",
				style : UIFilterButtonStyle
			}
		};
		
		public function Utils()
		{
			throw new Error(ErrorConstant.ONLYSINGLTON);
		}
		
		/**
		 * 获取控件原型代码
		 **/
		public static function GetControlPrototype(control:UIControl):uint
		{
			var source:Object = null;
			for(var id:String in CONTROLS)
			{
				source = CONTROLS[id];
				if(control is source.prototype)
				{
					return int(id);
				}
			}
			return 99;
		}
		
		public static function GetPrototype(control:UIControl):Class
		{
			for each(var source:Object in CONTROLS)
			{
				if(control is source.prototype)
				{
					return source.prototype;
				}
			}
			return null;
		}
		
		public static function GetPrototypeByType(type:uint):Class
		{
			if(String(type) in CONTROLS)
			{
				return CONTROLS[String(type)].prototype;
			}

			return null;
			
		}
		
		public static function getStylePrototypeByType(type:int):Class
		{
			if(String(type) in CONTROLS)
			{
				return CONTROLS[String(type)].style;
			}

			return null;
			
		}
		
		public static function getStyleTypeByPrototype(style:IVisualStyle):int
		{
			var source:Object = null;
			for(var id:String in CONTROLS)
			{
				source = CONTROLS[id];
				if(style is source.style)
				{
					return int(id);
				}
			}
			return 99;
		}
		
		public static function getStyleNameByType(type:int):String
		{
			if(String(type) in CONTROLS)
			{
				return CONTROLS[String(type)].styleName;
			}
			return null;
		}
		
		/**
		 * 克隆给定的组件原型
		 * 
		 **/
		public static function cloneControl(control:IUIControl,count:int = 1):Vector.<IUIControl>
		{
			var controls:Vector.<IUIControl> = new Vector.<IUIControl>();
			var prototype:Class = GetPrototype(control as UIControl);
			var source:ByteArray = control.encode();
			var clone:IUIControl = null;
			for (var idx:int = 0; idx<count; idx++)
			{
				clone = new prototype() as IUIControl;
				source.position = 1;
				clone.decode(source);
				clone.id = "";
				
				controls.push(clone);
			}
			return controls;
		}
		
		public static const FONTS:Object = [
			{"华文细黑" : "STXihei"},
			{"华文黑体" : "STHeiti"},
			{"华文楷体" : "STKaiti"},
			{"华文宋体" : "STSong"},
			{"新細明體" : "PMingLiU"},
			{"細明體" : "MingLiU"},
			{"標楷體" : "DFKai-SB"},
			{"黑体" : "SimHei"},
			{"宋体" : "SimSun"},
			{"新宋体" : "NSimSun"},
			{"仿宋" : "FangSong"},
			{"楷体" : "KaiTi"},
			{"微軟正黑體" : "Microsoft JhengHei"},
			{"微软雅黑体" : "Microsoft YaHei"}
		];
		/**
		 * 转换字体名称
		 * 
		 * 中文字体名称转换成英文
		 * 
			Windows的一些： 
			
			·新細明體：PMingLiU 
			·細明體：MingLiU 
			·標楷體：DFKai-SB 
			·黑体：SimHei 
			·宋体：SimSun 
			·新宋体：NSimSun 
			·仿宋：FangSong 
			·楷体：KaiTi 
			·仿宋_GB2312：FangSong_GB2312 
			·楷体_GB2312：KaiTi_GB2312 
			·微軟正黑體：Microsoft JhengHei 
			·微软雅黑体：Microsoft YaHei 
			
			装Office会生出来的一些： 
			
			·隶书：LiSu 
			·幼圆：YouYuan 
			·华文细黑：STXihei 
			·华文楷体：STKaiti 
			·华文宋体：STSong 
			·华文中宋：STZhongsong 
			·华文仿宋：STFangsong 
			·方正舒体：FZShuTi 
			·方正姚体：FZYaoti 
			·华文彩云：STCaiyun 
			·华文琥珀：STHupo 
			·华文隶书：STLiti 
			·华文行楷：STXingkai 
			·华文新魏：STXinwei 
		 **/
		public static function coverFontFamilyName(value:String):String
		{
			for each(var font:Object in FONTS)
			{
				for (var v:String in font)
				{
					if(font[v] == value)
					{
						return v;
					}
					//return font[value];
				}
				
			}
			return "SimSun";
		}
		
		public static function getFontFamily(value:String):String
		{
			for each(var obj:Object in FONTS)
			{
				if(value in obj)
				{
					return obj[value];
				}
			}
			return "SimSun";
		}
	}
}