package pixel.ui.control
{
	import pixel.ui.control.style.UILabelStyle;
	public class UILabel extends UITextBase //extends UIControl
	{
		public function UILabel(TextValue:String = "Label",Skin:Class = null)
		{
			var SkinClass:Class = Skin ? Skin:UILabelStyle;
			super(TextValue,SkinClass);
			
			width = 100;
			height = 40;
			
			this.mouseChildren = false;
		}
	}
}