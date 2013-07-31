package pixel.ui.control.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import pixel.ui.control.IUIContainer;

	/**
	 * GRID布局管理器
	 * 
	 **/
	public class GridLayout extends GenericLayout
	{
		//行间距
		private var _rowspace:int = 0;
		public function set rowspace(value:int):void
		{
			_rowspace = value;
		}
		//列间距
		private var _colspace:int = 0;
		public function set colspace(value:int):void
		{
			_colspace = value;
		}
		
		public function GridLayout(container:IUIContainer) 
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
				offsetX += child.width;
				offsetX += ((offsetX + _colspace) > totalX ? 0 : _colspace);
				if (offsetX + child.width <= totalX)
				{
					maxHeight = child.height > maxHeight?child.height:maxHeight;
				}
				else
				{
					offsetX = 0;
					offsetY += maxHeight + _rowspace;
				}
			}
		}
	}
}