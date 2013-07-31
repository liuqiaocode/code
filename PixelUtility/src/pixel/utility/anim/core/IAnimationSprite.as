package pixel.utility.anim.core
{
	public interface IAnimationSprite
	{
		function play(delay:Number,repeat:int = 0,onChangeCallback:Function = null):void;
		function update():void;
		function dispose():void;
		function pause():void;
		function stop():void;
		function reset():void;
	}
}