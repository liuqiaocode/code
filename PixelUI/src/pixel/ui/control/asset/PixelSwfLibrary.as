package pixel.ui.control.asset
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class PixelSwfLibrary extends AssetLibrary 
	{
		private var _source:DisplayObject = null;
		public function PixelSwfLibrary(source:DisplayObject)
		{
			_source = source;
		}
		
		override public function hasDefinition(name:String):Boolean
		{
			if(name in _assetsMap)
			{
				return true;
			}
			
			return _source.loaderInfo.applicationDomain.hasDefinition(name);
		}
		
		override public function findAssetByName(name:String):IAsset
		{
			var _asset:IAsset = super.findAssetByName(name);
			if(_asset)
			{
				return _asset;
			}
			if(_source.loaderInfo.applicationDomain.hasDefinition(name))
			{
				var clas:Object = _source.loaderInfo.applicationDomain.getDefinition(name);
				var value:Object = new clas();
				
				if(value is Bitmap || value is BitmapData)
				{
					var img:BitmapData = value is Bitmap ? (value as Bitmap).bitmapData:value as BitmapData;
					var image:AssetImage = new AssetImage(name,img);
					addAsset(image);
					return image;
				}
				else if(value is MovieClip)
				{
					var clip:AssetMovieClip = new AssetMovieClip(value as MovieClip);
					addAsset(clip);
					return clip;
				}
			}
			return null;
		}
	}
}