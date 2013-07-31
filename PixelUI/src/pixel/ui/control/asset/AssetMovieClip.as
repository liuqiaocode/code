package pixel.ui.control.asset
{
	import flash.display.MovieClip;

	public class AssetMovieClip extends Asset implements IAsset
	{
		private var _source:MovieClip = null;
		public function get resource():MovieClip
		{
			return _source;
		}
		
		public function AssetMovieClip(value:MovieClip)
		{
			_source = value;
		}
	}
}