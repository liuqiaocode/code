package pixel.ui.control
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import pixel.ui.control.style.IVisualStyle;
	import pixel.ui.control.style.UIScaleButtonStyle;
	import pixel.ui.control.utility.ButtonState;

	/**
	 * 
	 * 单图缩放按钮
	 * 
	 **/
	public class UIScaleButton extends UIControl
	{
		
		//鼠标进入缩放X系数
		private var _scaleXOver:Number = 0;
		//鼠标进入缩放Y系数
		private var _scaleYOver:Number = 0;
		public function setScaleOver(xv:Number,yv:Number):void
		{
			_scaleXOver = xv;
			_scaleYOver = yv;
			_overMtx.a = 1 + _scaleXOver;
			_overMtx.d = 1 + _scaleYOver;
//			if(_Style && _Style.BackgroundImage)
//			{
//				_overMtx.tx = _Style.BackgroundImage.width * -xv >> 1;
//				_overMtx.ty = _Style.BackgroundImage.height * -yv >> 1;
//			}
			
		}
		
		//按下X缩放系数
		private var _scaleXPressed:Number = 0;
		private var _scaleYPressed:Number = 0;

		public function setScalePressed(xv:Number,yv:Number):void
		{
			_scaleXPressed = xv;
			_scaleYPressed = yv;
			_pressMtx.a = 1 + _scaleXPressed;
			_pressMtx.d = 1 + _scaleYPressed;

//			if(_Style && _Style.BackgroundImage)
//			{
//				_pressMtx.tx = _Style.BackgroundImage.width * -xv >> 1;
//				_pressMtx.ty = _Style.BackgroundImage.height * -yv >> 1;
//			}
		}
		
		public function setScale(xv:Number,yv:Number):void
		{
			switch(_state)
			{
				case ButtonState.DOWN:
					setScalePressed(xv,yv);
					break;
				case ButtonState.OVER:
					setScaleOver(xv,yv);
					break;
				default:
					break;
			}
		}
		
		public function getScaleSize():Point
		{
			switch(_state)
			{
				case ButtonState.DOWN:
					return new Point(_scaleXPressed,_scaleYPressed);
					break;
				case ButtonState.OVER:
					return new Point(_scaleXOver,_scaleYOver);
					break;
				default:
					break;
			}
			return null;
		}
		
		private var _scaleSmooth:Boolean = true;
		public function set scaleSmooth(value:Boolean):void
		{
			_scaleSmooth = value;
		}
		public function get scaleSmooth():Boolean
		{
			return _scaleSmooth;
		}
		
		public function UIScaleButton(skin:Class = null)
		{
			super(skin ? skin : UIScaleButtonStyle);
			buttonMode = true;
			mouseChildren = false;
			width = 100;
			height = 40;
		}
		
		override public function EnableEditMode():void
		{
			super.EnableEditMode();
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMousePressed);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			buttonMode = false;
		}
		
		/**
		 * 进入显示舞台
		 * 
		 **/
		override protected function OnAdded(event:Event):void
		{
			super.OnAdded(event);
			if(!this._EditMode)
			{
				addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				addEventListener(MouseEvent.MOUSE_DOWN,onMousePressed);
				addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			}
		}
		/**
		 * 从显示舞台移除
		 * 
		 **/
		override protected function onRemoveFromStage(event:Event):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMousePressed);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		private var _state:uint = 0;
		private function onMouseOver(event:MouseEvent):void
		{
			state = ButtonState.OVER;
		}
		private function onMouseOut(event:MouseEvent):void
		{
			state = ButtonState.NORMAL;
		}
		
		private function onMousePressed(event:MouseEvent):void
		{
			state = ButtonState.DOWN;
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			state = ButtonState.OVER;
		}
		/**
		 * 设置按钮状态
		 * 
		 * 
		 **/
		public function set state(Value:uint):void
		{
			_state = Value;
			this.StyleUpdate();
		}
		
		
		private var _overMtx:Matrix = new Matrix();
		private var _pressMtx:Matrix = new Matrix();
		private var _renderMtx:Matrix = null;
		/**
		 * 覆写重绘
		 * 
		 * 
		 **/
		override protected function styleRender(style:IVisualStyle):void
		{
			if(style.BackgroundImage && !_EditMode)
			{
				var scaleXvalue:Number = 1;
				var scaleYvalue:Number = 1;
				
				/**
				 * 根据按钮状态获取缩放系数
				 * 
				 **/
				switch(_state)
				{
					case ButtonState.DOWN:
						scaleXvalue = _scaleXPressed;
						scaleYvalue = _scaleYPressed;
						_pressMtx.tx = _Style.BackgroundImage.width * -_scaleXPressed >> 1;
						_pressMtx.ty = _Style.BackgroundImage.height * -_scaleYPressed >> 1;
						_renderMtx = _pressMtx;
						break;
					case ButtonState.OVER:
						scaleXvalue = _scaleXOver;
						scaleYvalue = _scaleYOver;
						_overMtx.tx = _Style.BackgroundImage.width * -_scaleXOver >> 1;
						_overMtx.ty = _Style.BackgroundImage.height * -_scaleYOver >> 1;
						_renderMtx = _overMtx;
						break;
					default:
						_renderMtx = null;
						break;
				}
				
				var w:Number = style.BackgroundImage.width;
				var h:Number = style.BackgroundImage.height;
				graphics.clear();
				graphics.beginBitmapFill(style.BackgroundImage,_renderMtx,false,_renderMtx ? _scaleSmooth:false);
				if(!_renderMtx)
				{
					graphics.drawRect(0,0,w,h);
				}
				else
				{
					graphics.drawRect(
						(w * (-(_renderMtx.a - 1))) >> 1,
						(h * (-(_renderMtx.d - 1))) >> 1,
						w + w * (_renderMtx.a - 1),
						h + h * (_renderMtx.d - 1));
				}
				
				graphics.endFill();
			}
			else
			{
				super.styleRender(style);
			}
		}
		
		override protected function SpecialEncode(data:ByteArray):void
		{
			data.writeFloat(_scaleXOver);
			data.writeFloat(_scaleYOver);
			data.writeFloat(_scaleXPressed);
			data.writeFloat(_scaleYPressed);
		}
		
		override protected function SpecialDecode(data:ByteArray):void
		{
			setScaleOver(data.readFloat(),data.readFloat());
			setScalePressed(data.readFloat(),data.readFloat());
		}
	}
}