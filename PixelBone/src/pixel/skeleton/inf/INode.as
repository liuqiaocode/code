package pixel.skeleton.inf
{
	import pixel.utility.IDispose;
	import pixel.utility.IUpdate;

	public interface INode
	{
		function set name(value:String):void;
		function get name():String;
		function set x(value:Number):void;
		function get x():Number;
		function set y(value:Number):void;
		function get y():Number;
		
		function set height(value:Number):void;
		function get height():Number;
		function set width(value:Number):void;
		function get width():Number;
	}
}