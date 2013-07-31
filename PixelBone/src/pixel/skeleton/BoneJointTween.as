package pixel.skeleton
{
	import pixel.skeleton.inf.IBoneJointTween;

	/**
	 * 骨骼运动动画管理
	 * 
	 **/
	public class BoneJointTween
	{
		
		private static var _instance:IBoneJointTween = null;
		public function BoneJointTween()
		{
		}
		
		public static function get instance():IBoneJointTween
		{
			if(!_instance)
			{
				_instance = new BoneJointTweenImpl();
			}
			return _instance;
		}
	}
}
import flash.display.BitmapData;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

import pixel.skeleton.inf.IBoneJointTween;

/**
 * 
 * 
 **/
class BoneJointTweenImpl implements IBoneJointTween
{
	
	private var _timer:Timer = null;
	private var _tasks:Vector.<TweenTask> = null;
	public function BoneJointTweenImpl()
	{
		_tasks = new Vector.<TweenTask>();
		_timer = new Timer(33);
		_timer.addEventListener(TimerEvent.TIMER,onUpdate);
		_timer.start();
	}
	
	private function onUpdate(event:TimerEvent):void
	{
//		var len:int = _tasks.length;
//		var idx:int = 0;
//		var task:TweenTask = null;
//		while(idx < len)
//		{
//			task = _tasks.shift();
//			task.update();
//			if(task.isComplete())
//			{
//				if(task.completeCall != null)
//				{
//					task.completeCall();
//				}
//				
//			}
//			else
//			{
//				_tasks.push(task);
//			}
//			
//			idx++;
//		}
	}
	
//	public function run(target:IJoint,params:Array,
//						duration:Number,
//						param:Object):void
//	{
//		var task:TweenTask = new TweenTask(target,params,duration,param);
//		_tasks.push(task);
//	}
}

class TweenTask
{
//	public static const FUNC_COMPLETE:String = "onComplete";
//	public static const FUNC_PROGRESS:String = "onProgress";
//	public static const PARAM_LAZY:String = "lazy";
//	public static const PARAM_YOYO:String = "yoyo";
//	
//	private static const DEFAULT_PARAMNAMES:Array = [
//		PARAM_YOYO,FUNC_COMPLETE,FUNC_PROGRESS,PARAM_LAZY
//		
//	];
//	
//	
//	private var _target:IJoint = null;
//	private var _params:Array = [];
//	private var _duration:Number = 0;
//	private var _completeCall:Function = null;
//	private var _lazy:int = 0;
//	private var _lazyTime:int = 0;
//	private var _lazyUpdate:int = 0;
//	public function get completeCall():Function
//	{
//		return _completeCall;
//	}
//	private var _progressCall:Function = null;
//	public function get progressCall():Function
//	{
//		return _progressCall;
//	}
//	private var _totalFrame:Number = 0;
//	private var _childNodes:Array = [];
//	private var _overNodes:Array = [];
//	private var _yoyo:Boolean = false;
//	public function TweenTask(target:IJoint,params:Array,duration:Number,param:Object):void
//	{
//		_target = target;
//		_duration = duration * 1000;
////		_completeCall = onComplete;
////		_progressCall = onProgress;
////		_yoyo = yoyo;
////		_lazy = lazy;
//		initTweenParam(param);
//		_lazyUpdate = flash.utils.getTimer();
//		_totalFrame = int(_duration / 33 + 0.5) + (_duration % 33 > 0 ? 1:0);
//		var origValue:Number = 0;
//		var from:Number = 0;
//		var to:Number = 0;
//		var name:String = "";
//		var value:Number = 0;
//		var frameValue:Number = 0;
//		var node:ParamNode = null;
//		for each(var param:Object in params)
//		{
//			name = param.name;
//			if(name in target)
//			{
//				from = param.from ? param.from:_target[name];
//				to = param.to;
//				target[name] = from;
//				value = Math.abs(to - from);
//				frameValue = Number((value / _totalFrame).toFixed(2));
//				if(to < from)
//				{
//					frameValue *= -1;
//				}
//				
//				node = new ParamNode();
//				node.param = name;
//				node.frameValue = frameValue;
//				node.updateFrames = node.frames = _totalFrame;
//				node.to = to;
//				node.from = from;
//				_childNodes.push(node);
//			}
//		}
//	}
//	
//	private function initTweenParam(param:Object):void
//	{
//		for(var name:String in param)
//		{
//			switch(name)
//			{
//				case FUNC_COMPLETE:
//					_completeCall = param[name];
//					break;
//				case FUNC_PROGRESS:
//					_progressCall = param[name];
//					break;
//				case PARAM_YOYO:
//					_yoyo = param[name];
//					break;
//				case PARAM_LAZY:
//					_lazy = param[name];
//					break;
//			}
//		}
//	}
//
//	public function update():void
//	{
//		var total:int = _childNodes.length;
//		var idx:int = 0;
//		var node:ParamNode = null;
//		if(_lazy > 0 && _lazyTime < _lazy)
//		{
//			var now:int = flash.utils.getTimer();
//			
//			_lazyTime += (now - _lazyUpdate);
//			_lazyUpdate = now;
//			if(_lazyTime < _lazy)
//			{
//				return;
//			}
//		}
//		
//		while(idx < total)
//		{
//			
//			node = _childNodes.shift();
//			
//			if(node.updateFrames > 0)
//			{
//				//_target[node.param] += node.frameValue;
//				_target.move(node.param,node.frameValue);
//				trace(node.param,"[",node.updateFrames,"]","[",_target[node.param],"]value][",node.frameValue,"]");
//				_childNodes.push(node);
//				node.updateFrames--;
//			}
//			else
//			{
//				_target[node.param] = node.to;
//				_overNodes.push(node);
//			}
//			
//			idx++;
//		}
//	}
//	private var _isYoyoMove:Boolean = false;
//	public function isComplete():Boolean
//	{
//		if(_yoyo && _childNodes.length == 0)
//		{
//			_isYoyoMove = !_isYoyoMove;
//			if(!_isYoyoMove)
//			{
//				this._lazyTime = 0;
//				this._lazyUpdate = flash.utils.getTimer();
//			}
//			for each(var node:ParamNode in _overNodes)
//			{
//				var target:int = node.from;
//				node.from = node.to;
//				node.to = target;
//				var value:int = Math.abs(node.to - node.from);
//				var frameValue:Number = Number((value / _totalFrame).toFixed(2));
//				if(node.to < node.from)
//				{
//					frameValue *= -1;
//				}
//				node.frameValue = frameValue;
//				node.updateFrames = node.frames;
//				_childNodes.push(node);
//			}
//			_overNodes.length = 0;
//		}
//		return (_childNodes.length == 0);
//	}
}

class ParamNode
{
	public var param:String = "";
	public var from:Number = 0;
	public var to:Number = 0;
	public var frameValue:Number = 0;
	public var frames:int = 0;
	public var updateFrames:int = 0;
}