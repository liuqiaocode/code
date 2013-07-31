package pixel.ui.control.style
{
	import flash.utils.ByteArray;

	public class UIFilterButtonStyle extends UIStyle
	{
		private var _over:String = "";
		public function set over(value:String):void
		{
			_over = value;
		}
		public function get over():String
		{
			return _over;
		}
		private var _normal:String = "";
		public function set normal(value:String):void
		{
			_normal = value;
		}
		public function get normal():String
		{
			return _normal;
		}
		private var _pressed:String = "";
		public function set pressed(value:String):void
		{
			_pressed = value;
		}
		public function get pressed():String
		{
			return _pressed;
		}
		
		public function UIFilterButtonStyle()
		{
			super();
		}
		
		/**
		 * 样式编码
		 **/
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			data.writeUTF(_normal);
			data.writeUTF(_over);
			data.writeUTF(_pressed);
			
			return data;
		}
		
		/**
		 * 样式解码
		 **/
		override public function decode(data:ByteArray):void
		{
			super.decode(data);
			_normal = data.readUTF();
			_over = data.readUTF();
			_pressed = data.readUTF();
		}
	}
}