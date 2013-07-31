package pixel.utility.anim.starling
{
	import flash.display.BitmapData;

	public class StarlingTexture
	{
		private var _textureCfg:StarlingTextureVO = null;
		private var _texture:BitmapData = null;
		public function StarlingTexture(data:BitmapData,cfg:StarlingTextureVO = null)
		{
			_texture = data;
			_textureCfg = cfg;
		}
		public function get texture():BitmapData
		{
			return _texture;
		}
		
		public function get name():String
		{
			return _textureCfg.name;
		}
	}
}