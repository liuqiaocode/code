package pixel.ui.control.style
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public interface IBackgroundStyle
	{
		//背景颜色
		function set BackgroundColor(Value:uint):void;
		function get BackgroundColor():uint;
		
		//背景透明度
		function set BackgroundAlpha(Value:Number):void;
		function get BackgroundAlpha():Number;
		
		//背景图片
		function set BackgroundImage(Value:BitmapData):void;
		function get BackgroundImage():BitmapData;
		
		function set ImageFillType(Value:int):void;
		function get ImageFillType():int;
		
		function set BackgroundImageId(Value:String):void;
		function get BackgroundImageId():String;
	}
}