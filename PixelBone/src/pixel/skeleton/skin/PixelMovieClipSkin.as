package pixel.skeleton.skin
{
	import flash.display.MovieClip;

	public class PixelMovieClipSkin
	{
		private var _source:MovieClip = null;
		public function get source():MovieClip
		{
			return _source;
		}
		public function PixelMovieClipSkin(source:MovieClip)
		{
			_source = source;
		}
	}
}