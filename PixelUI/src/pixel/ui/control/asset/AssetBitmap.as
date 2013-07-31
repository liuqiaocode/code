package pixel.ui.control.asset
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * CPL资源库图形资源对象
	 * 
	 **/
	public class AssetBitmap extends Asset implements IAsset,IAssetImage
	{
		private var _type:int = 0;
		public function set type(value:int):void
		{
			_type = value;
		}
		public function get type():int
		{
			return _type;
		}
		private var _source:ByteArray = null;
		public function set source(value:ByteArray):void
		{
			_source = value;
		}
		public function get source():ByteArray
		{
			return _source;
		}
		
		private var _imgWidth:int = 0;
		public function set imgWidth(value:int):void
		{
			_imgWidth = value;
		}
		public function get imgWidth():int
		{
			return _imgWidth
		}
		private var _imgHeight:int = 0;
		public function set imgHeight(value:int):void
		{
			_imgHeight = value;
		}
		public function get imgHeight():int
		{
			return _imgHeight
		}
		
		public function AssetBitmap(source:ByteArray = null,type:int = 0)
		{
			_source = source;
			_type = type;
		}
		
		private var _image:BitmapData = null;
		public function get image():BitmapData
		{
			if(!_image)
			{
				_image = new BitmapData(_imgWidth,_imgHeight);
				switch(type)
				{
					case PixelAssetEmu.ASSET_PNG:
						_source.uncompress();
						_image.setPixels(_image.rect,_source);
						break;
					case PixelAssetEmu.ASSET_JPG:
						//异步加载图形
						_source.uncompress();
						_reader = new Loader();
						_reader.contentLoaderInfo.addEventListener(Event.COMPLETE,jpgLoadComplete);
						_reader.loadBytes(_source);
						break;
				}
			}

			return _image;
		}
		
		private function jpgLoadComplete(event:Event):void
		{
			_reader.contentLoaderInfo.removeEventListener(Event.COMPLETE,jpgLoadComplete);
			if(_image && _reader.content && _reader.content is Bitmap)
			{
				_image.setPixels(_image.rect,Bitmap(_reader.content).bitmapData.getPixels(Bitmap(_reader.content).bitmapData.rect));
			}
			_reader.unload();
			_reader = null;
		}
		
		private var _reader:Loader = null;
	}
}