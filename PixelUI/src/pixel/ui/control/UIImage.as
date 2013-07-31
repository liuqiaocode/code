package pixel.ui.control
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import pixel.ui.control.style.UIImageStyle;
	import pixel.ui.core.PixelUINS;
	import pixel.utility.bitmap.gif.GIFDecoder;
	import pixel.utility.bitmap.gif.GIFFrame;
	
	use namespace PixelUINS;
	public class UIImage extends UIControl
	{
		private var _gifFrames:Vector.<GIFFrame> = null;
		private var _timer:Timer = null;
		private var _currentIndex:int = 0;
		private var _count:int = 0;
		public function UIImage(Skin:Class = null)
		{
			super(Skin?Skin:UIImageStyle);
			width = 48;
			height = 48;
			mouseEnabled = false;
		}
		
		override public function EnableEditMode():void
		{
			super.EnableEditMode();
			mouseEnabled = true;
		}
		
		/**
		 * 设置GIF数据
		 * 
		 * 
		 **/
		public function set gif(value:ByteArray):void
		{
			UIImageStyle(Style).gif = value;
			if(value)
			{
				
				var decoder:GIFDecoder = new GIFDecoder();
				var result:int = decoder.read(value);
				if(result == 0)
				{
					_count = decoder.getFrameCount();
					_gifFrames = new Vector.<GIFFrame>();
					for(var idx:int = 0; idx<_count; idx++)
					{
						_gifFrames.push(decoder.getFrame(idx));	
					}
				}
				
				if(_timer)
				{
					if(_timer.running)
					{
						_currentIndex = 0;
					}
				}
				else
				{
					_timer = new Timer(decoder.getDelay(0));
					_timer.addEventListener(TimerEvent.TIMER,playFrame);
					_timer.start();
				}
				//img = decoder.getImage().bitmapData;
				//_image.bitmapData = img;
				this.BackgroundImage = decoder.getImage().bitmapData;
			}
		}
		
		//private var _image:Bitmap = new Bitmap();
		//private var img:BitmapData = null;
		protected function playFrame(event:TimerEvent):void
		{
			//this.BackgroundImage = new Bitmap(_gifFrames[_currentIndex].bitmapData);
			//_image.bitmapData = _gifFrames[_currentIndex].bitmapData;
			this.BackgroundImage = _gifFrames[_currentIndex].bitmapData;
			//trace(_currentIndex);
			StyleUpdate();
			_currentIndex++;
			if(_currentIndex >= _count)
			{
				_currentIndex = 0;
			}
			
		}
		
		public function stopGifPlay():void
		{
			if(_timer && _timer.running)
			{
				_timer.stop();
			}
		}
		
		public function playGif():void
		{
			if(_timer && !_timer.running)
			{
				_timer.start();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			//img = null;
			//_image = null;
			if(_timer)
			{
				if(_timer.running)
				{
					_timer.stop();
					
				}
				_timer.removeEventListener(TimerEvent.TIMER,playFrame);
				_timer = null;
			}
		}
		
		public function set image(value:Bitmap):void
		{
			super.BackgroundImage = value.bitmapData;
			width = value.width;
			height = value.height;
		}
		
		override protected function SpecialDecode(Data:ByteArray):void
		{
			super.SpecialDecode(Data);
			if(UIImageStyle(Style).isGif)
			{
				gif = UIImageStyle(Style).gif;
			}
		}
		
		
	}
}