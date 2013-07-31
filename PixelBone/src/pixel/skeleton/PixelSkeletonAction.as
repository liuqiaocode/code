package pixel.skeleton
{
	import pixel.skeleton.inf.IPixelAction;
	import pixel.skeleton.inf.IPixelActionFrameKey;

	public class PixelSkeletonAction extends Node implements IPixelAction
	{
		public function PixelSkeletonAction()
		{
			var key:IPixelActionFrameKey = new PixelActionFrameKey(0);
			addFrame(key);
		}
		
		private var _frames:Vector.<IPixelActionFrameKey> = null;
		public function get frames():Vector.<IPixelActionFrameKey>
		{
			return _frames;
		}
		
		public function set frames(value:Vector.<IPixelActionFrameKey>):void
		{
			_frames = value;
		}
		
		public function findFrameByIndex(index:int):IPixelActionFrameKey
		{
			return _frames[index];
		}
		
		public function addFrame(value:IPixelActionFrameKey):void
		{
			if(!_frames)
			{
				_frames = new Vector.<IPixelActionFrameKey>();	
			}
			_frames.push(value);
				
		}
		
		public function isKeyFrame(index:int):Boolean
		{
			for each(var key:IPixelActionFrameKey in _frames)
			{
				if(key.frameIndex == index)
				{
					return true;
				}
			}
			return false;
		}
	}
}