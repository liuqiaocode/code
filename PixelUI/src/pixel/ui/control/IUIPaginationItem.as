package pixel.ui.control
{
	import flash.display.DisplayObject;
	
	import pixel.utility.IDispose;
	
	/**
	 * 分页组件子视图接口
	 * 
	 **/
	public interface IUIPaginationItem extends IDispose
	{
		function set item(data:Object):void;
		function get item():Object;
		function get view():DisplayObject;
		
		function init():void;
	}
}