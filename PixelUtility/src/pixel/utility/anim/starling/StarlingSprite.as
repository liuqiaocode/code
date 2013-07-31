package pixel.utility.anim.starling
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import pixel.utility.anim.core.IAnimationSprite;

	public class StarlingSprite extends Sprite implements IAnimationSprite
	{
		private var _canvas:Bitmap = null;
		private var _delay:int = 0;
		private var _atlas:StarlingTextureAtlas = null;
		private var _currentIndex:int = 0;
		private var _repeatCount:int = 0;
		private var _currentRepeat:int = 0;
		private var _isPlay:Boolean = false;
		private var _isStop:Boolean = false;
		
		private var _onChangeFunc:Function = null;
		private var _lastUpdate:int = 0;
		private var _time:int = 0;
		public function StarlingSprite(atlas:StarlingTextureAtlas)
		{
			super();
			_canvas = new Bitmap();
			addChild(_canvas);
			
			_atlas = atlas;
			//第一帧
			_canvas.bitmapData = _atlas.getFrameByIndex(0).texture;
			
		}
		
		/**
		 * 开始运行
		 * 
		 **/
		public function play(delay:Number,repeat:int = 0,onChangeCallback:Function = null):void
		{
			if(!_isStop)
			{
				_time = flash.utils.getTimer();
				_delay = delay;
				_isPlay = true;
				_repeatCount = repeat;
				_currentRepeat = 0;
				_onChangeFunc = onChangeCallback;
			}
		}
		
		public function pause():void
		{
			_isPlay = false;
		}
		
		/**
		 * 复位
		 *
		 **/
		public function reset():void
		{
			_isPlay = false;
			_currentIndex = 0;
		}
		
		public function stop():void
		{
			_isPlay = false;
			reset();
		}
		
		public function update():void
		{
			if(_isPlay)
			{
				_time = flash.utils.getTimer();
				if(_time - _lastUpdate >= _delay)
				{
					_lastUpdate = _time;
					_canvas.bitmapData = _atlas.getFrameByIndex(_currentIndex).texture;
					if(_currentIndex + 1 == _atlas.totalCount)
					{
						_currentRepeat++;
						if(_currentRepeat == _repeatCount)
						{
							//到达播放次数，停止更新
							stop();	
						}
					}
				}
			}
		}
		
		public function dispose():void
		{
			_canvas.bitmapData = null;
		}
	}
}