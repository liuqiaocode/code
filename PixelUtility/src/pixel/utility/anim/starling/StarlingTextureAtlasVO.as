package pixel.utility.anim.starling
{
	public class StarlingTextureAtlasVO
	{
		private var _image:String = "";
		private var _textures:Vector.<StarlingTextureVO> = null;
		public function get image():String
		{
			return _image;
		}
		public function StarlingTextureAtlasVO(img:String)
		{
			_image = img;
			_textures = new Vector.<StarlingTextureVO>();
		}
		
		public function pushTexture(texture:StarlingTextureVO):void
		{
			_textures.push(texture);
		}
		
		public function get textures():Vector.<StarlingTextureVO>
		{
			return _textures;
		}
	}
}