package pixel.ui.control.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import pixel.ui.control.IUIContainer;
	
	/**
	 * 横向布局管理器
	 * 
	 **/
	public class HorizontalLayout extends GenericLayout
	{
		public function HorizontalLayout(container:IUIContainer)
		{
			super(container);
		}
		
		/**
		 * 布局更新
		 */
		override public function layoutUpdate():void
		{
			//起始坐标
			var offsetX:int = 0;
			var offsetY:int = 0;
			var idx:int = 0;
			
			//计算允许布局的最大宽度和高度
			var totalX:int = _container.width - offsetX;
			//var totalY:int = _container.height - offsetY;
			
			var maxHeight:int = 0;
			var child:DisplayObject = null;
			var content:DisplayObjectContainer = _container.childContent;
			while (idx < content.numChildren)
			{
				child = content.getChildAt(idx);
				idx++;
				
				child.x = offsetX;
				child.y = offsetY;
				
				offsetX += child.width + _gap;
			}
			
		}
	}
}