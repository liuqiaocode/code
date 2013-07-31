package pixel.utility.anim.core
{
	public class AnimationStage
	{
		private static var _instance:IAnimationStage = null;
		public function AnimationStage()
		{
		}
		
		public static function get instance():IAnimationStage
		{
			if(!_instance)
			{
				_instance = new AnimationStageImpl();
			}
			return _instance;
		}
	}
}
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import pixel.utility.anim.core.IAnimationSprite;
import pixel.utility.anim.core.IAnimationStage;
import pixel.utility.anim.starling.StarlingSprite;
import pixel.utility.anim.starling.StarlingTextureAtlas;
import pixel.utility.anim.starling.StarlingTextureAtlasManager;
import pixel.utility.anim.starling.StarlingTextureAtlasVO;

class AnimationStageImpl extends EventDispatcher implements IAnimationStage
{
	private var _timer:Timer = null;
	private var _isRunning:Boolean = false;
	private var _spriteQueue:Vector.<IAnimationSprite> = null;
	public function AnimationStageImpl()
	{
		_spriteQueue = new Vector.<IAnimationSprite>();
	}
	
	public function createSprite(cfg:Object,source:BitmapData = null):IAnimationSprite
	{
		var sprite:IAnimationSprite = null;
		if(cfg is StarlingTextureAtlasVO)
		{
			
			var atlas:StarlingTextureAtlas = StarlingTextureAtlasManager.instance.build(cfg as StarlingTextureAtlasVO,source);
			sprite = new StarlingSprite(atlas);
		}
		
		if(sprite)
		{
			_spriteQueue.push(sprite);
		}
		return sprite
	}
	/**
	 * 动画精灵管理启动函数(临时)
	 * 
	 **/
	public function starup():Boolean
	{
		if(!_isRunning && !_timer)
		{
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER,onUpdate);
			_isRunning = true;
			_timer.start();
		}
		return _isRunning;
	}
	
	
	/**
	 * 帧更新
	 * 
	 **/
	private function onUpdate(event:TimerEvent):void
	{
		var sprite:IAnimationSprite = null;
		for each(sprite in _spriteQueue)
		{
			sprite.update();
		}
	}
	
	public function get running():Boolean
	{
		return _isRunning;
	}
}