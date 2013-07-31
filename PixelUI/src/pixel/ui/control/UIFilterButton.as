package pixel.ui.control
{
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import pixel.ui.control.event.UIControlEvent;
	import pixel.ui.control.style.UIFilterButtonStyle;
	import pixel.ui.control.utility.ButtonState;
	import pixel.ui.control.utility.Utils;
	import pixel.ui.core.PixelUINS;

	use namespace PixelUINS;
	/**
	 * 
	 * 支持滤镜效果按钮
	 * 
	 **/
	public class UIFilterButton extends UIControl
	{
		//按钮状态
		protected var _state:uint = ButtonState.NORMAL;
		protected var _label:UILabel = null;
		public function get labelControl():UILabel
		{
			return _label;
		}
		protected var _labelText:String = "";
		public function UIFilterButton(skin:Class = null)
		{
			super(skin?skin:UIFilterButtonStyle);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			_labelText = "FButton";
			_label = new UILabel(_labelText);
			buttonMode = true;
			_label.mouseEnabled = false;
			addChild(_label);
			mouseChildren =false;
			width = 100;
			height = 40;
		}
		
		override public function EnableEditMode():void
		{
			this.buttonMode = false;
			super.EnableEditMode();
			this.mouseChildren = true;
			_label.mouseChildren = false;
			_label.mouseEnabled = false;
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		override public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			if(_label)
			{
				_label.width = value;
			}
		}
		override public function set height(value:Number):void
		{
			super.height = value;
			if(_label)
			{
				_label.height = value;
			}
		}
		
		/**
		 * 为当前状态设置滤镜名称
		 * 
		 * @param		value		滤镜名称
		 * @param		targetState	目标状态
		 **/
		public function addFilter(value:String,targetState:int = -1):void
		{
			targetState = targetState >= 0 ? targetState:_state;
			switch(targetState)
			{
				case ButtonState.DOWN:
					UIFilterButtonStyle(Style).pressed = value;
					break;
				case ButtonState.OVER:
					UIFilterButtonStyle(Style).over = value;
					break;
				default:
					UIFilterButtonStyle(Style).normal = value;
			}
			
			Utils.applyFilterByName(this,value);
		}
		
		/**
		 * 获取当前滤镜名称
		 * 
		 **/
		public function getFilter(targetState:int = -1):String
		{
			targetState = targetState >= 0 ? targetState:_state;
			switch(targetState)
			{
				case ButtonState.DOWN:
					return UIFilterButtonStyle(Style).pressed;
					break;
				case ButtonState.OVER:
					return UIFilterButtonStyle(Style).over;
					break;
				default:
					return UIFilterButtonStyle(Style).normal;
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			state = ButtonState.DOWN;
			var notify:UIControlEvent = new UIControlEvent(UIControlEvent.BUTTON_DOWN,true);
			dispatchEvent(notify);
		}
		protected function onMouseUp(event:MouseEvent):void
		{
			state = ButtonState.OVER;
		}
		protected function onMouseOver(event:MouseEvent):void
		{
			state = ButtonState.OVER;
		}
		protected function onMouseOut(event:MouseEvent):void
		{
			state = ButtonState.NORMAL;
		}
		public function get state():uint
		{
			return _state;
		}
		public function set state(value:uint):void
		{
			_state = value;
			switch(_state)
			{
				case ButtonState.DOWN:
					Utils.applyFilterByName(this,UIFilterButtonStyle(Style).pressed);
					break;
				case ButtonState.OVER:
					Utils.applyFilterByName(this,UIFilterButtonStyle(Style).over);
					break;
				default:
					Utils.applyFilterByName(this,UIFilterButtonStyle(Style).normal);
			}
			
			//StyleUpdate();
		}
		
		/**
		 * 设置显示文本
		 * 
		 **/
		public function set label(value:String):void
		{
			if(_label)
			{
				_label.text = value;
			}
		}
		
		override protected function SpecialDecode(data:ByteArray):void
		{
			var Len:int = data.readShort();
			var labelData:ByteArray = new ByteArray();
			data.readBytes(labelData,0,Len);
			labelData.position = 1;//跳过UILabel类型数据域
			_label.decode(labelData);
		}
		override protected function SpecialEncode(Data:ByteArray):void
		{
			var labelData:ByteArray = _label.encode();
			Data.writeShort(labelData.length);
			Data.writeBytes(labelData,0,labelData.length);
		}
	}
}