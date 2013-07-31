package pixel.utility.anim.starling {
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author LiuQ
	 */
	public interface IStarlingTextureAtlasManager
	{
		function build(cfg:StarlingTextureAtlasVO, source:BitmapData,isCache:Boolean = true):StarlingTextureAtlas;
	}
	
}