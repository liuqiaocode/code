package pixel.ui.control.asset
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class AssetImage extends Asset implements IAsset,IAssetImage
	{
		protected var _image:BitmapData = null;
		
		public function get image():BitmapData
		{
			return _image;
		}
		public function AssetImage(name:String,image:BitmapData = null)
		{
			super(name);
			_image = image;
		}
		
		public function get width():int
		{
			if(_image)
			{
				return _image.width;
			}
			return 0;
		}
		public function get height():int
		{
			if(_image)
			{
				return _image.height;
			}
			return 0;
		}
	}
}