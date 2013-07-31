package pixel.skeleton
{
	import pixel.skeleton.inf.IPixelActionFrameKey;

	/**
	 * 时间线关键帧
	 * 
	 **/
	public class PixelActionFrameKey implements IPixelActionFrameKey
	{
		//关键帧所处的帧下标
		private var _frameIndex:int = 0;
		public function get frameIndex():int
		{
			return _frameIndex;
		}
		
		private var _params:Vector.<String> = null;
		public function set frameArgs(value:Vector.<String>):void
		{
			_params = value;
		}
		public function get frameArgs():Vector.<String>
		{
			return _params;
		}
		
		public function PixelActionFrameKey(index:int)
		{
			_frameIndex = index;
			_params = new Vector.<String>();
		}
	}
}