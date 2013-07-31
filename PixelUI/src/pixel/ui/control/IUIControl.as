package pixel.ui.control
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import pixel.ui.control.asset.IAssetNotify;
	import pixel.ui.control.style.IVisualStyle;
	import pixel.ui.core.PixelUINS;
	import pixel.utility.IDispose;
	import pixel.utility.ISerializable;
	import pixel.utility.IUpdate;
	
	use namespace PixelUINS;
	/**
	 * 
	 * UI组件基类接口
	 * 
	 **/
	public interface IUIControl extends IDispose,IEventDispatcher,ISerializable,IUpdate,IFlashSprite,IAssetNotify
	{
		//绘制接口
		function Render():void;
		
		function get id():String;
		function set id(Value:String):void;
		function get version():uint;
		function set version(Value:uint):void;
		function get Style():IVisualStyle;
		function set Style(value:IVisualStyle):void;
		function initializer():void;
		function enabled(value:Boolean,gloom:Boolean = false):void;
		
		function set data(value:String):void;
		function get data():String;
		
		function clone():IUIControl;
		function EnableEditMode():void;
		//以中心为注册点进行缩放
		//function CenterScale(Value:Number):void;
	}
}