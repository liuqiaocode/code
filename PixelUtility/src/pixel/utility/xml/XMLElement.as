package pixel.utility.xml
{
	public class XMLElement implements IXMLNode
	{
		protected var _name:String = "";
		
		protected var _elements:Vector.<XMLElement> = null;
		
		protected var _attributes:Vector.<XMLAttribute> = null;
		
		protected var _text:String = "";
		
		public function set text(value:String):void
		{
			_text = value;
		}
		public function XMLElement(name:String)
		{
			_name = name;
			_elements = new Vector.<XMLElement>();
			_attributes = new Vector.<XMLAttribute>();
		}
		
		public function appendElement(element:XMLElement):void
		{
			_elements.push(element);
		}
		
		public function createElement(name:String):XMLElement
		{
			var element:XMLElement = new XMLElement(name);
			_elements.push(element);
			return element;
		}
		
		public function appendAttribute(attribute:XMLAttribute):void
		{
			_attributes.push(attribute);
		}
		
		public function toXML():String
		{
			var xml:String = "<" + _name;
			for each(var attr:XMLAttribute in _attributes)
			{
				xml += " " + attr.toXML() + "";
			}
			xml += ">";
			if(_text)
			{
				xml += _text;
			}
			else
			{
				for each(var child:XMLElement in _elements)
				{
					xml += child.toXML();
				}
			}
			
			return xml += "</" + _name + ">";
		}
	}
}