package pixel.ui.control.layout
{
	import pixel.utility.IDispose;

	public interface IContainerLayout extends IDispose
	{
		function layoutUpdate():void;
		
		function set gap(value:int):void;
		function get gap():int;
	}
}