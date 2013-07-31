package pixel.skeleton.skin
{
	import pixel.skeleton.Node;
	import pixel.skeleton.inf.IPixelBoneSkin;

	public class PixelSkin extends Node implements IPixelBoneSkin
	{
		
		private var _rotation:Number = 0;
		public function set rotation(value:Number):void
		{
			_rotation = value;
		}
		public function get rotation():Number
		{
			return _rotation;
		}
		public function PixelSkin()
		{
		}
	}
}