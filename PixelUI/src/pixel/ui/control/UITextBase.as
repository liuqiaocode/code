package pixel.ui.control
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	import pixel.ui.control.style.FontStyle;
	import pixel.ui.control.style.IVisualStyle;
	import pixel.ui.control.utility.Utils;
	import pixel.ui.core.PixelUINS;
	import pixel.utility.Tools;
	
	use namespace PixelUINS;
	public class UITextBase extends UIControl
	{
		protected var _TextValue:String = "";
		protected var _TextField:TextField = null;
		protected var _letterSpacing:int = 1;
		public function get textfield():TextField
		{
			return _TextField;
		}
		protected var _Format:TextFormat = null;
		public function UITextBase(Text:String = "",Skin:Class = null)
		{
			super(Skin);
			_TextField = new TextField();
			_TextValue = Text;
			_TextField.selectable = false;
			_Format = new TextFormat();
			_Format.letterSpacing = _letterSpacing;
			_Format.size = _Style.FontTextStyle.FontSize;
			_Format.color = _Style.FontTextStyle.FontColor;
			_Format.font = _Style.FontTextStyle.FontFamily;
			_Format.bold = _Style.FontTextStyle.FontBold;
			//var a:TextFormatAlign
			_Format.align = TextFormatAlign.CENTER;
			//_TextField.autoSize = TextFieldAutoSize.CENTER;
			_TextField.defaultTextFormat = _Format;
			_TextField.text = _TextValue;
//			_TextField.borderColor = 0xff0000;
//			_TextField.border = true;
			///Align = TextAlign.LEFT;
			addChild(_TextField);
			this.BorderThinkness = 0;
			this.BackgroundAlpha = 0;
		}
		
		public function set htmlText(value:String):void
		{
			_TextField.htmlText = value;
			updateSize();
		}
		
		public function get defaultFormat():TextFormat
		{
			return _TextField.defaultTextFormat;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeChild(_TextField);
			_TextField = null;
			_Format = null;
		}
		
		protected function updateSize():void
		{
			if(!mutiline)
			{
				if(_TextField.textWidth > width)
				{
					width = _TextField.textWidth + 2;
				}
				if(_TextField.textHeight > height)
				{
					height = _TextField.textHeight + 2;
				}
			}
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_TextField.width = value;
		}
		override public function set height(value:Number):void
		{
			super.height = value;
			_TextField.height = value;
		}
		
		public function isPassword(value:Boolean):void
		{
			_TextField.displayAsPassword = value;
		}
		
		public function get password():Boolean
		{
			return _TextField.displayAsPassword;
		}
		
		public function set text(value:String):void
		{
			_TextField.text = _TextValue = value;	
			updateSize();
		}
		public function get text():String
		{
			return _TextField.text;
		}
		
		/**
		 * 文本依靠方向
		 * 
		 **/
		public function set align(value:int):void
		{
			_Style.FontTextStyle.FontAlign = value;
			//var fmt:TextFormat = _TextField.defaultTextFormat;
			switch(value)
			{
				case TextAlign.CENTER:
					_Format.align = TextFormatAlign.CENTER;
					//_TextField.autoSize = TextFieldAutoSize.CENTER;
					break;
				case TextAlign.LEFT:
					_Format.align = TextFormatAlign.LEFT;
					//_TextField.autoSize = TextFieldAutoSize.LEFT;
					break;
				case TextAlign.RIGHT:
					_Format.align = TextFormatAlign.RIGHT;
					//_TextField.autoSize = TextFieldAutoSize.RIGHT;
					break;
				default:
			}
			this.updateFormat();
		}
		
		public function get align():int
		{
			return _Style.FontTextStyle.FontAlign;
		}
		
		public function set FontFamily(value:String):void
		{
			_Style.FontTextStyle.FontFamily = _Format.font = Utils.getFontFamily(value);
			updateFormat();
		}
		public function get FontFamily():String
		{
			return _Style.FontTextStyle.FontFamily;
		}
		
		public function get TextWidth():int
		{
			return _TextField.textWidth;
		}
		public function get TextHeight():int
		{
			return _TextField.textHeight;
		}
		
//		public function set FontBold(value:Boolean):void
//		{
//			_Format.bold = _Style.FontTextStyle.FontBold = value;
//			updateFormat();
//		}
		
		public function set FontSize(Value:int):void
		{
			_Format.size = _Style.FontTextStyle.FontSize = Value;
			updateFormat();
			
		}
		public function get FontSize():int
		{
			return int(_Format.size);
		}
		public function set FontColor(Value:uint):void
		{
			_Format.color = _Style.FontTextStyle.FontColor = Value;
			updateFormat();
		}
		
		protected function updateFormat():void
		{
			_TextField.defaultTextFormat = _Format;
			_TextField.setTextFormat(_Format);
		}
		public function get FontColor():uint
		{
			return uint(_Format.color);
		}
		
		/**
		 * 是否允许输入
		 * 
		 **/
		public function set Input(Value:Boolean):void
		{
			_TextField.type = Value ? TextFieldType.INPUT:TextFieldType.DYNAMIC;
			
			if(Value)
			{
				_TextField.autoSize = TextFieldAutoSize.NONE;
				_TextField.selectable = Value;
				_TextField.width = width;
				_TextField.height = height;
			}
		}
		
		public function set mutiline(value:Boolean):void
		{
			_TextField.multiline = value;
			_TextField.wordWrap = value;
		}
		public function get mutiline():Boolean
		{
			return _TextField.multiline;
		}
	
		override public function EnableEditMode():void
		{
			super.EnableEditMode();
			Input = false;
			//addEventListener(MouseEvent.MOUSE_DOWN,DownProxy,true);
			_TextField.mouseEnabled = false;
		}
		
		override public function set Style(value:IVisualStyle):void
		{
			super.Style = value;
			this.applyFontStyle(value.FontTextStyle);
		}
		
		override protected function SpecialDecode(Data:ByteArray):void
		{
			_TextField.displayAsPassword = Boolean(Data.readByte());
			var Len:int = Data.readShort();
			var txt:String = "";
			if(Len > 0)
			{
				txt = Data.readMultiByte(Len,"cn-gb");
			}
			_Format.size = _Style.FontTextStyle.FontSize;
			_Format.color = _Style.FontTextStyle.FontColor;
			_Format.font = _Style.FontTextStyle.FontFamily;
			_Format.bold = _Style.FontTextStyle.FontBold;
			switch(_Style.FontTextStyle.FontAlign)
			{
				case TextAlign.CENTER:
					_Format.align = TextFormatAlign.CENTER;
					break;
				case TextAlign.LEFT:
					_Format.align = TextFormatAlign.LEFT;
					break;
				case TextAlign.RIGHT:
					_Format.align = TextFormatAlign.RIGHT;
					break;
				default:
			}
			_TextField.width = width;
			_TextField.height = height;
			
			text = txt;
			this.updateFormat();
		}
		
		/**
		 * 粗体显示
		 * 
		 **/
		public function set textBold(value:Boolean):void
		{
			_Format.bold = _Style.FontTextStyle.FontBold = value;
			this.updateFormat();
		}
		public function get textBold():Boolean
		{
			return _Style.FontTextStyle.FontBold;
		}
		
		public function applyFontStyle(style:FontStyle):void
		{
			_Format.bold = _Style.FontTextStyle.FontBold = style.FontBold;
			_Format.color = _Style.FontTextStyle.FontColor = style.FontColor;
			_Format.font = _Style.FontTextStyle.FontFamily = style.FontFamily;
			_Format.size = _Style.FontTextStyle.FontSize = style.FontSize;
			updateFormat();
		}
		
		override protected function SpecialEncode(Data:ByteArray):void
		{
			Data.writeByte(int(_TextField.displayAsPassword));
			var Len:int = Tools.StringActualLength(_TextValue);
			Data.writeShort(Len);
			Data.writeMultiByte(_TextValue,"cn-gb");
		}
	}
}