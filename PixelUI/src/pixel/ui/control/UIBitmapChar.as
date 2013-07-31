package pixel.ui.control
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import pixel.ui.control.style.IVisualStyle;
	import pixel.utility.BitmapTools;

	/**
	 * 图片数字控件
	 * 
	 **/
	public class UIBitmapChar extends UIControl
	{
		private static var _globalCache:Dictionary = new Dictionary();
		
		//每个数字图片的宽度
		private var _charWidth:Array = [];
		public function set charWidth(value:String):void
		{
			_charWidth = value.split(",");
		}
		public function get charWidth():String
		{
			return _charWidth.join(",");
		}
		
		//图片对应的数据字典
		private var _dict:Array = [];
		public function set charDict(value:String):void
		{
			_dict = value.split(",");
		}
		public function get charDict():String
		{
			return _dict.join(",");
		}
		//当前要渲染的值
		private var _value:String = "";
		public function set value(data:String):void
		{
			if(data != _value)
			{
				_value = data;
				this.StyleUpdate();
			}
		}
		public function get value():String
		{
			return _value;
		}
		private var init:Boolean = false;
		private var chars:Array = [];
		private var char:String = "";
		private var _charCache:Dictionary = null;
		public function UIBitmapChar()
		{
			_charCache = new Dictionary();
			width = 60;
			height = 60;
		}
		
		private function initCharImage():void
		{
			if(this.BackgroundImageId in _globalCache)
			{
				_charCache = _globalCache[BackgroundImageId];
			}
			else
			{
				var img:BitmapData = null;
				var imgW:int = 0;
				var imgH:int = backgroundImage.height;
				var rect:Rectangle = new Rectangle(0,0,imgW,imgH);
				var dest:Point = new Point();
				for (var idx:int = 0; idx<_charWidth.length; idx++)
				{
					rect.width = imgW = int(_charWidth[idx]);
					img = new BitmapData(imgW,imgH);
					img.copyPixels(backgroundImage,rect,dest);
					rect.x += imgW;
					_charCache[_dict[idx]] = img;
				}
				_globalCache[BackgroundImageId] = _charCache;
			}
			init = true;
		}
		
		private var _img:BitmapData = null;
		/**
		 * 重写渲染
		 * 
		 **/
		override protected function styleRender(style:IVisualStyle):void
		{
			this.graphics.clear();
			if(_img)
			{
				_img.dispose();
			}
			chars.length = 0;
			if(_value.length > 0 && backgroundImage)
			{
				if(!init)
				{
					initCharImage();
				}
				var imgs:Array = [];
				var totalW:int = 0;
				for (var idx:int = 0; idx<_value.length; idx++)
				{
					char = _value.charAt(idx);
					if(_dict.indexOf(char) >= 0)
					{
						//chars.push(_value.charAt(idx));
						imgs.push(_charCache[char]);
						totalW += _charCache[char].width;
					}
				}
				
				var charImg:BitmapData = null;
				_img = new BitmapData(totalW,backgroundImage.height);
				var rect:Rectangle = new Rectangle(0,0,0,0);
				var dest:Point = new Point();
				while(imgs.length > 0)
				{
					charImg = imgs.shift();
					rect.width = charImg.width;
					rect.height = charImg.height;
					_img.copyPixels(charImg,rect,dest);
					dest.x += rect.width;
				}
				this.graphics.beginBitmapFill(_img);
				this.graphics.drawRect(0,0,_img.width,_img.height);
				this.graphics.endFill();
				_ActualWidth = _img.width;
				_ActualHeight = _img.height;
			}
			else
			{
				super.styleRender(style);
			}
		}
		
		override public function set data(value:String):void
		{
			super.data = value;
			this.value = value;
		}
		
		override protected function SpecialEncode(data:ByteArray):void
		{
			var wStr:String = _charWidth.join(",");
			//data.writeShort(_charWidth);
			//data.writeShort(_charHeight);
			data.writeUTF(wStr);
			var dictStr:String = _dict.join(",");
			data.writeUTF(dictStr);
		}
		
		override protected function SpecialDecode(data:ByteArray):void
		{
			var wStr:String = data.readUTF();
			_charWidth = wStr.split(",");
			//_charWidth = data.readShort();
			//_charHeight = data.readShort();
			var dictStr:String = data.readUTF();
			_dict = dictStr.split(",");
			_value = _data;
		}
	}
}