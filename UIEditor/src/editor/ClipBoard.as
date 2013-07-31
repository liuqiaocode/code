package editor
{
	import flash.utils.ByteArray;
	
	import pixel.ui.control.IUIControl;
	import pixel.ui.control.UIControl;
	import pixel.ui.control.UIControlFactory;
	import pixel.ui.control.utility.Utils;

	public class ClipBoard
	{
		private static var _prototype:Class = null;
		private static var _control:ByteArray = null;
		public static function pushToClipboard(value:IUIControl):void
		{
			//value.encode();
			_prototype = Utils.GetPrototype(value as UIControl) as Class;
			_control = value.encode();
		}
		
		public static function getControlFromClipboard():IUIControl
		{
			if(_prototype)
			{
				var control:UIControl = new _prototype() as UIControl;
				_control.position = 0;
				//跳过第一个字节，类型
				_control.readByte();
				control.decode(_control);
				control.id = "";
				control.EnableEditMode();
				return control;
			}
			return null;
		}
		
		public function ClipBoard()
		{
		}
	}
}