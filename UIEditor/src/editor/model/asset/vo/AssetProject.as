package editor.model.asset.vo
{
	public class AssetProject
	{
		private var _name:String = "";
		public function set name(value:String):void
		{
			_name = value;
		}
		public function get name():String
		{
			return _name;
		}
		
		private var _librarys:Array = [];
		public function get librarys():Array
		{
			return _librarys;
		}
		public function addLibrary(library:AssetLibrary):void
		{
			_librarys.push(library);

		}
		public function get children():Array
		{
			return _librarys;
		}
		
		public function AssetProject()
		{
		}
		
		public function toXML():String
		{
			return "";
		}
		
		private var _fileNav:String = "";
		public function set fileNav(value:String):void
		{
			_fileNav = value;
		}
		public function get fileNav():String
		{
			return _fileNav;
		}
		
		public function decodeByJson(value:String):void
		{
			var obj:Object = JSON.parse(value);
			_name = obj.name;
			_fileNav = obj.fileNav;
			for each(var libObj:Object in obj.librarys)
			{
				var lib:AssetLibrary = new AssetLibrary(libObj);
				_librarys.push(lib);
			}
		}
		
		public function toJson():String
		{
			return JSON.stringify(this);
		}
	}
}