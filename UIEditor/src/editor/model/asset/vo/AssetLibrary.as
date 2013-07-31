package editor.model.asset.vo
{
	/**
	 * 资源库
	 * 
	 * 
	 **/
	public class AssetLibrary
	{
		//资源库ID
		private var _name:String = "";
		public function set name(value:String):void
		{
			_name = value;
		}
		public function get name():String
		{
			return _name;
		}
		//生成文件名称
		private var _exportName:String = "";
		public function set exportName(value:String):void
		{
			_exportName = value;
		}
		public function get exportName():String
		{
			return _exportName;
		}
		
		private var _isCompress:Boolean = false;
		public function set isCompress(value:Boolean):void
		{
			_isCompress = value;
		}
		public function get isCompress():Boolean
		{
			return _isCompress;
		}
		private var _compressMode:int = 0;
		public function set compressMode(value:int):void
		{
			_compressMode = value;
		}
		public function get compressMode():int
		{
			return _compressMode;
		}
		private var _packMode:int = 0;
		public function set packMode(value:int):void
		{
			_packMode = value;
		}
		public function get packMode():int
		{
			return _packMode;
		}
		
		//资源列表
		private var _assets:Array = [];
		public function get assets():Array
		{
			return _assets;
		}
		public function addAsset(value:Asset):void
		{
			_assets.push(value);
		}
		
		public function delAsset(value:Asset):void
		{
			if(value && _assets && _assets.indexOf(value) >= 0)
			{
				_assets.splice(_assets.indexOf(value),1);
			}
		}
		
		public function get children():Array
		{
			return _assets;
		}
		
		public function AssetLibrary(obj:Object = null)
		{
			if(obj)
			{
				_name = obj.name;
				_exportName = obj.exportName;
				_isCompress = obj.isCompress;
				_compressMode = obj.compressMode;
				_packMode = obj.packMode;
				
				for each(var v:Object in obj.assets)
				{
					var ass:Asset = new Asset();
					//ass.decodeByJson(v);
					ass.decode(v);
					_assets.push(ass);
				}
			}
		}
		
		public function decodeByJson(value:String):void
		{
			var obj:Object = JSON.parse(value);
			_name = obj.name;
			_exportName = obj.exportName;
			_isCompress = obj.isCompress;
			_compressMode = obj.compressMode;
			_packMode = obj.packMode;
			
			for each(var v:Object in obj.assets)
			{
				var ass:Asset = new Asset();
				//ass.decodeByJson(v);
				ass.decode(v);
				_assets.push(ass);
			}
		}
	}
}