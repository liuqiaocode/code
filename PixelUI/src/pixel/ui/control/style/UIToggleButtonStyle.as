package pixel.ui.control.style
{
	import flash.utils.ByteArray;
	
	public class UIToggleButtonStyle extends UIContainerStyle
	{
		private var _overStyle:UIContainerStyle = null;
		public function get overStyle():UIStyle
		{
			return _overStyle;
		}
		private var _pressedStyle:UIContainerStyle = null;
		public function get pressedStyle():UIStyle
		{
			return _pressedStyle;
		}
		public function UIToggleButtonStyle()
		{
			super();
			_pressedStyle = new UIContainerStyle();
			_pressedStyle.BackgroundColor = 0x5d5d5d;
			_pressedStyle.BackgroundAlpha = 0.5;
			
			_overStyle = new UIContainerStyle();
			_overStyle.BackgroundColor = 0x5d5d5d;
			_overStyle.BackgroundAlpha = 0.5;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			var pressed:ByteArray = _pressedStyle.encode();
			data.writeBytes(pressed);
			
			var over:ByteArray = _overStyle.encode();
			data.writeBytes(over);
			return data;
		}
		override public function decode(data:ByteArray):void
		{
			super.decode(data);
			_pressedStyle.decode(data);
			_overStyle.decode(data);
		}
	}
}