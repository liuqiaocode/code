package
{
	import flash.utils.Dictionary;
	
	import pixel.skeleton.inf.IPixelAction;
	import pixel.skeleton.inf.IPixelActionFrameKey;

	public class SkeletonActionVO
	{
		private var _action:IPixelAction = null;
		public function get action():IPixelAction
		{
			return _action;
		}
		public function get skeletonName():String
		{
			return _action.name;
		}
		
		public function SkeletonActionVO(action:IPixelAction)
		{
			_action = action;
		}
		
		public function addActionFrameKey(value:IPixelActionFrameKey):void
		{
			_action.addFrame(value);
		}
		
		private var _keyArgs:Dictionary = null;
		public function addArgs(key:int,boneName:String,paramName:String,paramValue:Number):void
		{
			var args:Dictionary = null;
			if(!(key in _keyArgs))
			{
				_keyArgs[key] = new Dictionary();
			}
			
			args = _keyArgs[key];
			
			args[paramName] = paramValue;
		}
	}
}