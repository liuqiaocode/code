package pixel.ui.control
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	import pixel.ui.control.vo.ComboboxItem;
	import pixel.ui.core.PixelUINS;
	
	use namespace PixelUINS;
	
	public class UIComboboxItem  extends UIContainer implements IUIComboboxItem
	{
		private var _Icon:Bitmap = null;
		//private var _Line:TextLine;
		private var _text:UILabel = null;
		private var _Item:ComboboxItem = null;
		public function UIComboboxItem()
		{
			super();
			this.Layout = UILayoutConstant.HORIZONTAL;
			this.BorderThinkness = 0;
			this.BackgroundAlpha = 0;
			
			_text = new UILabel();
			addChild(_text);
			
			this.mouseChildren = false;
		}
		
		public function set itemData(value:Object):void
		{
			_Item = value as ComboboxItem;
			if(_Item)
			{
				_text.text = _Item.Label;
				_text.FontColor = _Item.fontColor;
				_text.textBold = _Item.fontBold;
				_text.FontSize = _Item.fontSize;
			}
		}
		
		override public function get height():Number
		{
			return 15;
		}
		
		public function set FontSize(Size:int):void
		{
			//this.Style.FontTextStyle.FontSize = Size;	
			_text.FontSize = Size;
			addChild(_text);
		}
		
		public function get Item():ComboboxItem
		{
			return _Item;
		}
		
		override protected function SpecialEncode(data:ByteArray):void
		{
			var itemData:ByteArray = _Item.encode();
			data.writeBytes(itemData,0,itemData.length);
		}
		
		override protected function SpecialDecode(Data:ByteArray):void
		{
			_Item = new ComboboxItem();
			_Item.decode(Data);
			_text.text = _Item.Label;
			_text.FontColor = _Item.fontColor;
			_text.textBold = _Item.fontBold;
			_text.FontSize = _Item.fontSize;
		}
	}
}