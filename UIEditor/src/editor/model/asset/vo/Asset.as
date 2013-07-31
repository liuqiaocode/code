package editor.model.asset.vo
{
	import editor.utils.Common;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	
	import pixel.utility.System;

	/**
	 * 单个资源
	 * 
	 **/
	public class Asset
	{
		//private var _loader:Loader = null;
		//private var _source:Object = null;
		//private var _sourceFile:File = null;
		private var _file:String = "";
		public function get file():String
		{
			return _file;
		}
		
		private var _id:String = "";
		public function set id(value:String):void
		{
			_id = value;
			
		}
		public function get id():String
		{
			if(_id == "")
			{
				return Common.getFileNameByNav(name);
			}
			return _id;
		}
		
		public function get name():String
		{
			return _file.substr(_file.lastIndexOf(System.SystemSplitSymbol) + 1);
		}
		
		public function Asset(file:File = null)
		{
			//_sourceFile = file;
			if(file)
			{
				_file = file.nativePath;
//				var reader:FileStream = new FileStream();
//				reader.open(_sourceFile,FileMode.READ);
//				var data:ByteArray = new ByteArray();
//				reader.readBytes(data);
//				
//				if(file.extension == "png" || file.extension == "jpg")
//				{
//					_loader = new Loader();
//					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadImageComplete);
//					_loader.loadBytes(data);
//				}
//				else if(file.extension == "mp3")
//				{
//					var sound:Sound = new Sound();
//					sound.loadCompressedDataFromByteArray(data,data.length);
//					_source = sound;
//				}
			}
		}
		
//		private function loadImageComplete(event:Event):void
//		{
//			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadImageComplete);
//			_source = _loader.content as Bitmap;
//			_loader.unload();
//			_loader = null;
//		}
		
		public function decode(value:Object):void
		{
			if(value is String)
			{
				decodeByJson(value as String);
			}
			else if(value is Object)
			{
				_file = value.file;
			}
		}
		
		public function decodeByJson(value:String):void
		{
			_file = value;
		}
	}
}