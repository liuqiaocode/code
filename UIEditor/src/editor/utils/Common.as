package editor.utils
{
	import editor.model.asset.vo.AssetLibrary;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import pixel.utility.System;

	public class Common
	{
		//输出目录
		//public static const OUTPUT:String = File.applicationDirectory.nativePath + System.SystemSplitSymbol + "Output" + System.SystemSplitSymbol;
		//public static const MODEL:String = OUTPUT + "Model" + System.SystemSplitSymbol;
		//public static const ASSETLIB:String = OUTPUT + "AssetLibrary" + System.SystemSplitSymbol;
		public static const PACKAGE:String = "ui";
		//public static const ASSETS:String = OUTPUT + "assets" + System.SystemSplitSymbol;
		public static const CORECOMPACK:String = "corecom.control.*;\n import corecom.control.asset.ControlAssetManager;\n";
		public static const INSTALL_DIR:String = File.applicationDirectory.nativePath + System.SystemSplitSymbol;
		public static const PREFERENCE:String = INSTALL_DIR + "Preference.cfg";
		public static const ASSETPRJ:String = "AssetPrj.cfg";
		public static const ASSL:String = ".assl";
		public static const STYLEGROUP_SUFFIX:String = ".sg";
		
		//public static const DEFAULT_DIR_RES:String = File.applicationDirectory.nativePath + System.SystemSplitSymbol+ "res" + System.SystemSplitSymbol;
		public static const DEFAULT_DIR_STYLES:String = File.applicationDirectory.nativePath + System.SystemSplitSymbol + "styles" + System.SystemSplitSymbol;
		public static const DEFAULT_DIR_ANIM:String = File.applicationDirectory.nativePath + System.SystemSplitSymbol+ "anim" + System.SystemSplitSymbol;
		
		public static const TEXT_ERRORTIP:String = "错误提示";
		
		public function Common()
		{
		}
		
		public static function getDataByFile(nav:String):ByteArray
		{
			var file:File = new File(nav);
			if(file.exists && !file.isDirectory)
			{
				var reader:FileStream = new FileStream();
				reader.open(file,FileMode.READ);
				var data:ByteArray = new ByteArray();
				reader.readBytes(data);
				reader.close();
				return data;
			}
			return new ByteArray();
		}
		
		public static function setStringToFile(nav:String,data:String):void
		{
			var writer:FileStream = new FileStream();
			var file:File = new File(nav);
			writer.open(file,FileMode.WRITE);
			writer.writeUTFBytes(data);
			writer.close();
		}
		
		public static function getFileSuffix(nav:String):String
		{
			if(nav.indexOf(".") >= 0)
			{
				return nav.substring(nav.indexOf(".") + 1);
			}
			return "";
		}
		
		public static function getPathByNav(nav:String):String
		{
			if(nav.lastIndexOf(System.SystemSplitSymbol) >= 0)
			{
				return nav.substring(0,(nav.lastIndexOf(System.SystemSplitSymbol) + 1));
			}
			return "";
		}
		
		public static function getFileNameByNav(nav:String):String
		{
			var value:String = nav.substring(nav.lastIndexOf(System.SystemSplitSymbol) + 1,nav.lastIndexOf("."));
			return value;
		}
	}
}