package pixel.ui.control.asset
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * CPL资源库
	 * 
	 **/
	public class PixelAssetLibrary extends AssetLibrary
	{
		public function PixelAssetLibrary(name:String = "")
		{	
			super.id = name;
		}
		
		public function findBitmapByName(name:String):AssetBitmap
		{
			if(this.hasDefinition(name))
			{
				return this.findAssetByName(name) as AssetBitmap;
			}
			return null;
		}
	}
}