package pixel.utility.xml
{
	public class XMLAttribute implements IXMLNode
	{
		private var _name:String = "";
		public function set name(data:String):void
		{
			_name = data;
		}
		private var _value:String = "";
		public function set value(data:String):void
		{
			_value = data;
		}
		
		public function XMLAttribute(name:String,value:String)
		{
			_name = name;
			_value = value;
		}
		
		public function toXML():String
		{
			return _name + "=\"" + _value + "\"";
		}
		
	}
}