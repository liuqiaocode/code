package pixel.utility.anim.starling
{
	/**
	 * starling 纹理图片配置解析
	 * 
	 * 
	 **/
	public class StarlingTextureAtlasLoader
	{
		public function StarlingTextureAtlasLoader()
		{
			
		}
		
		public static function parse(cfg:String):StarlingTextureAtlasVO
		{
			var doc:XML = new XML(cfg);
			var atlas:StarlingTextureAtlasVO = new StarlingTextureAtlasVO(doc.@imagePath);
			var textures:XMLList = doc.SubTexture;
			var node:XML = null;
			var texture:StarlingTextureVO = null;
			for each(node in textures)
			{
				texture = new StarlingTextureVO();
				texture.name = node.@name;
				texture.x = Number(node.@x);
				texture.y = Number(node.@y);
				texture.frameH = Number(node.@frameHeight);
				texture.frameW = Number(node.@frameWidth);
				texture.frameX = Number(node.@frameX);
				texture.frameY = Number(node.@frameY);
				texture.width = Number(node.@width);
				texture.height = Number(node.@height);
				atlas.pushTexture(texture);
			}
			return atlas;
		}
	}
}