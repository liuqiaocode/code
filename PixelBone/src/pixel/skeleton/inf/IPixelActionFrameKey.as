package pixel.skeleton.inf
{
	public interface IPixelActionFrameKey
	{
		function get frameIndex():int;
		function get frameArgs():Vector.<String>;
		function set frameArgs(value:Vector.<String>):void;
	}
}