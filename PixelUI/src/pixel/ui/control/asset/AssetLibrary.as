package pixel.ui.control.asset
{
	import flash.utils.Dictionary;
	
	import pixel.ui.core.PixelUINS;

	use namespace PixelUINS;
	
	public class AssetLibrary implements IAssetLibrary
	{
		protected var _assets:Vector.<IAsset> = null;
		protected var _assetsMap:Dictionary = null;
		protected var _assetKeys:Vector.<String> = null;
		
		private var _id:String = "";
		public function set id(value:String):void
		{
			_id = value;
		}
		public function get id():String
		{
			return _id;
		}
		
		public function AssetLibrary(id:String = "")
		{
			_assets = new Vector.<IAsset>();
			_assetsMap = new Dictionary();
			_assetKeys = new Vector.<String>();
			_id = id;
		}
		
		public function addAsset(asset:IAsset):void
		{
			_assets.push(asset);
			_assetsMap[asset.name] = asset;
			_assetKeys.push(asset.name);
		}
		
		public function get keys():Vector.<String>
		{
			return _assetKeys;
		}
		
		public function get assets():Vector.<IAsset>
		{
			return _assets;
		}
		
		public function hasDefinition(name:String):Boolean
		{
			return (name in _assetsMap);
		}
		
		public function findAssetByName(name:String):IAsset
		{
			if(name in _assetsMap)
			{
				return _assetsMap[name];
			}
			return null;
		}
		
		public function unload():void
		{}
	}
}