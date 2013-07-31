package pixel.utility.xml
{
	public class Document
	{
		private var _header:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		private var _root:XMLElement = null;
		
		public function Document(root:XMLElement)
		{
			_root = root;
		}
		
		public function toXML():String
		{
			return _header + _root.toXML();
		}
	}
}