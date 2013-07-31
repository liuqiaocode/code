package pixel.skeleton.inf
{
	import flash.display.DisplayObject;
	
	import pixel.utility.IDispose;
	import pixel.utility.IUpdate;

	/**
	 * 骨骼接口
	 * 
	 **/
	public interface IPixelBone extends IUpdate,IDispose,INode
	{
		function get parent():INode;
		function set parent(value:INode):void;
		
		function set skin(value:String):void;
		function get skin():String;
		
		function isBind():Boolean;
		function bind(skin:IPixelBoneSkin):void;
		function get view():DisplayObject;
		
		function addChildBone(bone:IPixelBone):void;
		
		function get children():Vector.<IPixelBone>;
		function set children(value:Vector.<IPixelBone>):void;
	}
}