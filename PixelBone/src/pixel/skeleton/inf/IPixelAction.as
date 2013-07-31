package pixel.skeleton.inf
{
	public interface IPixelAction
	{
		function set name(value:String):void;
		function get name():String;
		function get frames():Vector.<IPixelActionFrameKey>;
		function set frames(value:Vector.<IPixelActionFrameKey>):void;
		function addFrame(value:IPixelActionFrameKey):void;
		function findFrameByIndex(index:int):IPixelActionFrameKey;
		function isKeyFrame(index:int):Boolean;
	}
}