package pixel.ui.control
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.engine.TextElement;
	
	import pixel.ui.control.style.UITextInputStyle;
	import pixel.ui.core.PixelUINS;
	
	use namespace PixelUINS;
	
	public class UITextInput extends UITextBase
	{
		public function UITextInput(text:String = "",Skin:Class = null)
		{
			super(text,Skin?Skin:UITextInputStyle);
			width = 100;
			height = 20;
			this.Input = true;
			this.BorderThinkness = 1;
		}
		public function set maxSize(value:int):void
		{
			_TextField.maxChars = value;
		}
	
	}
}