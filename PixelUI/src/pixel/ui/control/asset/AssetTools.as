package pixel.ui.control.asset
{
	import flash.utils.ByteArray;

	public class AssetTools
	{
		public function AssetTools()
		{
		}
		
		/**
		 * 数据对象转换成资源库对象
		 * 
		 **/
		public static function convertByte2AssetLibrary(source:ByteArray):PixelAssetLibrary
		{
			source.uncompress();
			source.position = 0;
			//读取前3位资源标识
			var flag:String = source.readUTFBytes(3);
			
			if(flag == PixelAssetEmu.LIBRARY_PREFIX)
			{
				var id:String = source.readUTF();
				var library:PixelAssetLibrary = new PixelAssetLibrary();
				library.id = id;
				
				var compress:Boolean = Boolean(source.readByte());
				//资源总数
				var totalCount:int = source.readInt();
				var type:int = 0;
				var len:int = 0;
				var data:ByteArray = null;
				var asset:IAsset = null;
				
				for(var idx:int = 0; idx<totalCount; idx++)
				{
					data = new ByteArray();
					id = source.readUTF();
					type = source.readByte();
					switch(type)
					{
//						case PixelAssetEmu.ASSET_PNG:
//							break;
//						case PixelAssetEmu.ASSET_JPG:
//							break;
						default:
							asset = new AssetBitmap(null,type);
							asset.name = id;
							AssetBitmap(asset).imgWidth = source.readShort();
							AssetBitmap(asset).imgHeight = source.readShort();
							len = source.readInt();
							source.readBytes(data,0,len);
							AssetBitmap(asset).source = data;
							library.addAsset(asset);
							break;
					}
					
				}
				return library;
			}
			return null;
		}
	}
}