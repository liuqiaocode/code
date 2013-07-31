package pixel.ui.control.vo
{
	import flash.utils.ByteArray;
	
	import pixel.ui.control.IUIControl;
	import pixel.ui.control.utility.Utils;

	public class UIControlMod
	{
		private var _control:IUIControl = null;
		private var _source:ByteArray = null;
		public function UIControlMod(control:IUIControl = null)
		{
			_control = control;
		}
		
		public function set source(value:ByteArray):void
		{
			_source = value;
		}
		
		public function getControl(reset:Boolean = true):IUIControl
		{
			if(_control)
			{
				return _control;
			}
			if(_source)
			{
				decode(_source);
				if(reset)
				{
					_control.x = _control.y = 0;
				}
				_source.clear();
				_source = null;
			}
			return _control;
		}
		
		private var _id:String = "";
		public function set id(value:String):void
		{
			_id = value;
		}
		
		public function get id():String
		{
			return _control ? _control.id:_id;
		}
		
		private var _linkStyle:UIStyleMod = null;
		public function set linkStyle(value:UIStyleMod):void
		{
			_linkStyle = value;
		}
		public function get linkStyle():UIStyleMod
		{
			return _linkStyle;
		}
		
		public function encode():ByteArray
		{
			return null;
		}
		
		public function decode(data:ByteArray):void
		{
			var type:int = data.readByte();
			var prototype:Class = Utils.GetPrototypeByType(type);
			_control = new prototype() as IUIControl;
			_control.decode(data);
			if(_control && _linkStyle)
			{
				_control.Style = _linkStyle.style;
			}
			//_control.x = _control.y = 0;
		}
	}
}