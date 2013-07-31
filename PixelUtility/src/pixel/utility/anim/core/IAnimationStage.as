package pixel.utility.anim.core
{
	import flash.display.BitmapData;
	import flash.display.Stage;

	public interface IAnimationStage
	{
		function get running():Boolean;
		function createSprite(cfg:Object,source:BitmapData = null):IAnimationSprite;
		function starup():Boolean;
	}
}