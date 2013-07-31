package pixel.ui.control
{
	public class UITipDefault extends UIContainer implements IUITip
	{
		private var _Label:UILabel = null;
		public function UITipDefault()
		{
			super();
			_Label = new UILabel();
			_Label.align = TextAlign.LEFT;
			_Label.mutiline = true;
			addChild(_Label);
			this.Style.BackgroundColor = 0xFFCC33;
		}
		
		public function set tipData(value:Object):void
		{
			_Label.text = String(value);
			//width = _Label.TextWidth + 5;
			//height = _Label.TextHeight + 5;
			width = 200;
			height = 200;
		}
	}
}