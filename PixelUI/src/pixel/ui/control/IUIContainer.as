package pixel.ui.control
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * UI容器组件接口
	 * 
	 **/
	public interface IUIContainer extends IUIControl
	{
		function findChildById(id:String,deepSearch:Boolean = false):IUIControl;
		function findChildsByClass(prototype:Class,deepSearch:Boolean = false):Array;
		function get children():Array;
		function removeAllChildren():void;
		function getChildIndex(child:DisplayObject):int;
		
		/**
		 * 增加一个子对象的层级
		 * @param		child		要进行层级调整的子对象
		 **/
		function childIndexAdd(child:DisplayObject):void;
		
		/**
		 * 减少一个子对象的层级
		 * @param		child		要进行层级调整的子对象
		 **/
		function childIndexSub(child:DisplayObject):void;
		
		/**
		 * 返回当前子对象容器
		 * 
		 **/
		function get childContent():DisplayObjectContainer;
	}
}