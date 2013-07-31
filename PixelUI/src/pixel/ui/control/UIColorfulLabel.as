package pixel.ui.control
{
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import pixel.ui.control.vo.ColorFormat;
	import pixel.ui.core.PixelUINS;

	use namespace PixelUINS;
	/**
	 * 多彩文本组件
	 * 
	 * 基于TextFieldFormat特性允许设定一段文本中显示多种不同的色彩
	 * 
	 **/
	public class UIColorfulLabel extends UITextBase
	{
		private var _formats:Vector.<ColorFormat> = null;
		public function UIColorfulLabel()
		{
			super();
			_formats = new Vector.<ColorFormat>();
			text = "Label";
			width = 100;
			height = 30;
		}
		
		/**
		 * 添加文字格式
		 * 
		 * @param		format		文本样式
		 **/
		public function addColorFormat(format:ColorFormat):void
		{
			_formats.push(format);
			textFormatUpdate();
		}
		
		/**
		 * 返回当前应用的所有颜色样式
		 * 
		 **/
		public function get colorFormat():Vector.<ColorFormat>
		{
			return _formats;
		}
		
		/**
		 * 
		 * 清除当前所有文本样式
		 * 
		 **/
		public function clearFormat():void
		{
			_formats.length = 0;
			textFormatUpdate();
		}
		override public function EnableEditMode():void
		{
			super.EnableEditMode();
			this._TextField.selectable = true;
		}
		
		/**
		 * 设置当前文本
		 * 
		 * @param		value		文字
		 * 
		 **/
		override public function set text(value:String):void
		{
			super.text = value;
			textFormatUpdate();
		}
		
		/**
		 * 文本格式更新
		 * 
		 **/
		protected function textFormatUpdate():void
		{
			_TextField.setTextFormat(_TextField.defaultTextFormat);
			var format:ColorFormat = null;
			var txtFormat:TextFormat = null;
			var textLen:int = _TextField.text.length;
			for each(format in _formats)
			{
				if(format.startIndex >= textLen)
				{
					continue;
				}
				txtFormat = new TextFormat();
				txtFormat.color = format.color;
				txtFormat.size = format.size;
				if(format.isLink)
				{
					txtFormat.url = "event:" + format.linkId;
					txtFormat.underline = true;
				}
				
				_TextField.setTextFormat(txtFormat,format.startIndex,format.endIndex <= textLen ? format.endIndex:-1);
			}
		}
		
		override protected function SpecialEncode(data:ByteArray):void
		{
			super.SpecialEncode(data);
			data.writeByte(_formats.length);
			var format:ColorFormat = null;
			for each(format in _formats)
			{
				data.writeBytes(format.encode());
			}
		}
		
		override protected function SpecialDecode(data:ByteArray):void
		{
			super.SpecialDecode(data);
			var count:int = data.readByte();
			var format:ColorFormat = null;
			for(var idx:int = 0; idx<count; idx++)
			{
				format = new ColorFormat();
				format.decode(data);
				_formats.push(format);
			}
			textFormatUpdate();
		}
		
		override protected function updateFormat():void
		{
			super.updateFormat();
			textFormatUpdate();
		}
	}
}
