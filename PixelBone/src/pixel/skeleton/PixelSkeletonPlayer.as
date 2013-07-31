package pixel.skeleton
{
	import pixel.skeleton.inf.IPixelSkeletonPlayer;

	public class PixelSkeletonPlayer
	{
		private static var _instance:IPixelSkeletonPlayer = null;
		public function PixelSkeletonPlayer()
		{
		}
		
		public static function get instance():IPixelSkeletonPlayer
		{
			if(!_instance)
			{
				_instance = new PixelSkeletonPlayerImpl();
			}
			return _instance;
		}
	}
}

import flash.events.TimerEvent;
import flash.utils.Timer;

import pixel.skeleton.inf.IPixelSkeleton;
import pixel.skeleton.inf.IPixelSkeletonPlayer;

/**
 * 
 * 
 **/
class PixelSkeletonPlayerImpl implements IPixelSkeletonPlayer
{
	private var _queue:Vector.<IPixelSkeleton> = null;
	private var _timer:Timer = null;
	public function PixelSkeletonPlayerImpl()
	{
		_queue = new Vector.<IPixelSkeleton>();
		_timer = new Timer(33);
		_timer.addEventListener(TimerEvent.TIMER,onTime);
	}
	
	private function onTime(event:TimerEvent):void
	{
		for each(var skeleton:IPixelSkeleton in _queue)
		{
			skeleton.update();
		}
	}
	
	public function register(skeleton:IPixelSkeleton):void
	{
		if(_queue.indexOf(skeleton) < 0)
		{
			_queue.push(skeleton);
		}
		if(!_timer.running)
		{
			_timer.start();
		}
	}
	
	public function remove(skeleton:IPixelSkeleton):void
	{
		if(_queue.indexOf(skeleton) >= 0)
		{
			_queue.splice(_queue.indexOf(skeleton),1);
		}
		if(_queue.length == 0)
		{
			_timer.stop();
		}
	}
	
	public function isRegister(skeleton:IPixelSkeleton):Boolean
	{
		return (_queue.indexOf(skeleton) >= 0);
	}
}