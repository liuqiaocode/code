package pixel.skeleton
{
	/**
	 * 骨骼动作对应单个关键帧的播放数据剪辑
	 * 
	 * 
	 **/
	public class PixelActionFrameClip
	{
		private var _frameIndex:int = 0;
		public function get frameIndex():int
		{
			return _frameIndex;
		}
		private var _params:Vector.<String> = null;
		public function set params(value:Vector.<String>):void
		{
			_params = value;
		}
		public function get params():Vector.<String>
		{
			return _params;
		}
		
		public function PixelActionFrameClip(index:int)
		{
			_frameIndex = index;
			_params = new Vector.<String>();
		}
	}
}