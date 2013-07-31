package pixel.skeleton.skin
{
	import flash.display.BitmapData;

	public class PixelBitmapSkin extends PixelSkin
	{
		private var _source:BitmapData = null;
		public function get bitmap():BitmapData
		{
			return _source;	
		}
		
		public function PixelBitmapSkin(source:BitmapData)
		{
			_source = source;
		}
	}
}