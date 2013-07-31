package editor.cfg
{
	import flash.utils.ByteArray;

	public class EditorPreference
	{
		public var assetLibraryLinks:Array = [];
		public var moduleLibraryLinks:Array = [];
		
		public function EditorPreference()
		{
		}
		
		public function encode():ByteArray
		{
			var data:ByteArray = new ByteArray();
			var value:String = JSON.stringify(this);
			data.writeUTFBytes(value);
			return data;
		}
		
		public function decode(source:ByteArray):void
		{
			var data:Object = JSON.parse(source.readUTFBytes(source.length));
			assetLibraryLinks = data.assetLibraryLinks;
			
			moduleLibraryLinks = data.moduleLibraryLinks;
		}
	}
}