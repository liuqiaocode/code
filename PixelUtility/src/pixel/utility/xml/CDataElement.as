package pixel.utility.xml
{
	public class CDataElement extends XMLElement
	{
		public function CDataElement(name:String)
		{
			super(name);
		}
		
		override public function toXML():String
		{
			var xml:String = "<" + _name;
			for each(var attr:XMLAttribute in _attributes)
			{
				xml += " " + attr.toXML() + "";
			}
			xml += "><![CDATA[" + _text + "]]>";
			return xml += "</" + _name + ">";
		}
	}
}