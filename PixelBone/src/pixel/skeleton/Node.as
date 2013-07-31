package pixel.skeleton
{
	import pixel.skeleton.inf.INode;

	public class Node implements INode
	{
		protected var _name:String = "";
		public function set name(value:String):void
		{
			_name = value;
		}
		public function get name():String
		{
			return _name;
		}
		protected var _parent:INode = null;
		public function get parent():INode
		{
			return _parent;
		}
		public function set parent(value:INode):void
		{
			_parent = value;
		}
		
		protected var _x:Number = 0;
		public function set x(value:Number):void
		{
			_x = value;
		}
		public function get x():Number
		{
			return _x;
		}
		protected var _y:Number = 0;
		public function set y(value:Number):void
		{
			_y = value;
		}
		public function get y():Number
		{
			return _y;
		}
		
		//骨架宽度
		protected var _width:Number = 0;
		public function set width(value:Number):void
		{
			_width = value;
		}
		public function get width():Number
		{
			return _width;
		}
		//骨架高度
		protected var _height:Number = 0;
		public function set height(value:Number):void
		{
			_height = value;
		}
		public function get height():Number
		{
			return _height;
		}
		public function Node()
		{
		}
	}
}