package editor.utils
{
	import editor.cfg.EditorPreference;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import pixel.ui.control.asset.IAsset;
	import pixel.ui.control.asset.IAssetLibrary;


	public class Globals
	{
		private static var _AssetLibrarys:Dictionary = new Dictionary();
		
		public static function AppendAssetLibrary(Library:IAssetLibrary):void
		{
			_AssetLibrarys[Library.id] = Library;
		}
		
		public static function FindAssetLibraryById(Id:String):IAssetLibrary
		{
			if(_AssetLibrarys.hasOwnProperty(Id))
			{
				return _AssetLibrarys[Id];
			}
			return null;
		}
		
		public static function Clear():void
		{
			_AssetLibrarys = new Dictionary();
		}
		public function Globals()
		{
		}
		
		public static function FindAssetById(LibraryId:String,AssetId:String):IAsset
		{
			var Library:IAssetLibrary = FindAssetLibraryById(LibraryId);
			
			if(Library)
			{
				return Library.findAssetByName(AssetId);
				
			}
			return null;
		}
		
		public static function FindAssetByAssetId(Id:String):IAsset
		{
			var Library:IAssetLibrary = null;
			
			for each(Library in _AssetLibrarys)
			{
				if(Library.hasDefinition(Id))
				{
					return Library.findAssetByName(Id);
				}
			}
			return null;
		}
		
		private static var _preference:EditorPreference = null;
		public static function get preference():EditorPreference
		{
			return _preference;
		}
		public static function preferenceInitializer():void
		{
			var cfg:File = new File(Common.PREFERENCE);
			var io:FileStream = null;
			_preference = new EditorPreference();
			try
			{
				if(cfg.exists)
				{
					io = new FileStream();
					io.open(cfg,FileMode.READ);
					var source:ByteArray = new ByteArray();
					io.readBytes(source);
					source.position = 0;
					_preference.decode(source);
				}
				else
				{
					//创建新配置
					_preference = new EditorPreference();
					io = new FileStream();
					io.open(cfg,FileMode.WRITE);
					io.writeBytes(_preference.encode());
				}
			}
			catch(err:Error)
			{
				
			}
			finally
			{
				if(io)
				{
					io.close();
					io = null;
				}
			}
		}
		
		/**
		 * 保存当前编辑器配置
		 * 
		 **/
		public static function savePreferenceAndRefresh():void
		{
			var cfg:File = new File(Common.PREFERENCE);
			var io:FileStream = null;
			try
			{
				if(cfg.exists && _preference)
				{
					io = new FileStream();
					io = new FileStream();
					io.open(cfg,FileMode.WRITE);
					io.writeBytes(_preference.encode());
				}
				
			}
			catch(err:Error)
			{
				
			}
			finally
			{
				if(io)
				{
					io.close();
					io = null;
				}
			}
		}
		
		private static var _command:Boolean = false;
		public static function set command(value:Boolean):void
		{
			_command = value;
		}
		public static function get command():Boolean
		{
			return _command;
		}
	}
}