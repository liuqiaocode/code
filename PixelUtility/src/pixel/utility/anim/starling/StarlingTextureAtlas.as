package pixel.utility.anim.starling
{
	public class StarlingTextureAtlas
	{
		private var _atlasCfg:StarlingTextureAtlasVO = null;
		private var _textures:Vector.<StarlingTexture> = null;
		private var _totalCount:int = 0;
		
		public function StarlingTextureAtlas(cfg:StarlingTextureAtlasVO = null)
		{
			_textures = new Vector.<StarlingTexture>();
			_atlasCfg = cfg;
		}
		
		public function findByName(name:String):StarlingTexture
		{
			for each(var txt:StarlingTexture in _textures)
			{
				if (txt.name == name)
				{
					return txt;
				}
			}
			return null;
		}
		
		public function getFrameByIndex(idx:int):StarlingTexture
		{
			if (idx < _totalCount)
			{
				return _textures[idx];
			}
			return null;
		}
		
		public function pushTexture(value:StarlingTexture):void
		{
			_textures.push(value);
			_totalCount++;
		}
		
		public function get textures():Vector.<StarlingTexture>
		{
			return _textures;
		}
		
		public function get totalCount():int
		{
			return _totalCount;
		}
	}
}