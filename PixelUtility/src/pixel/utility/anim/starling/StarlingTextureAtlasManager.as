package pixel.utility.anim.starling
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class StarlingTextureAtlasManager
	{
		private static var _instance:IStarlingTextureAtlasManager = null;
		public function StarlingTextureAtlasManager()
		{
		}
		
		public static function get instance():IStarlingTextureAtlasManager
		{
			if (!_instance)
			{
				_instance = new StarlingTextureAtlasManagerImpl();
			}
			return _instance;
		}
	}
}
import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import pixel.utility.anim.starling.IStarlingTextureAtlasManager;
import pixel.utility.anim.starling.StarlingTextureAtlasVO;
import pixel.utility.anim.starling.StarlingTextureAtlas;
import pixel.utility.anim.starling.StarlingTextureVO;
import pixel.utility.anim.starling.StarlingTexture;
class StarlingTextureAtlasManagerImpl extends EventDispatcher implements IStarlingTextureAtlasManager
{
	private var _cache:Dictionary = null;
	
	public function StarlingTextureAtlasManagerImpl()
	{
		_cache = new Dictionary();
	}
	
	public function build(cfg:StarlingTextureAtlasVO, source:BitmapData,isCache:Boolean = true):StarlingTextureAtlas
	{
		if (cfg)
		{
			if (cfg.image in _cache)
			{
				return _cache[cfg.image];
			}
			if (source)
			{
				var atlas:StarlingTextureAtlas = new StarlingTextureAtlas(cfg);
				var textureCfg:StarlingTextureVO = null;
				var textureCfgs:Vector.<StarlingTextureVO> = cfg.textures;
				var rect:Rectangle = new Rectangle(0, 0, 0, 0);
				var texture:BitmapData = null;
				var dest:Point = new Point();
				for each (textureCfg in textureCfgs)
				{
					rect.x = textureCfg.x;
					rect.y = textureCfg.y;
					rect.width = textureCfg.width;
					rect.height = textureCfg.height;
					
					texture = new BitmapData(rect.width, rect.height, true, 0);
					texture.copyPixels(source, rect, dest);
					atlas.pushTexture(new StarlingTexture(texture, textureCfg));
				}
				return atlas;
			}
		}
		return null;
	}

}
