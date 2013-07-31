package pixel.ui.control.layout
{
	import flash.display.DisplayObjectContainer;
	
	import pixel.ui.control.IUIContainer;

	public class GenericLayout implements IContainerLayout
	{
		protected var _container:IUIContainer = null;
		
//		//容器内部物件与容器边缘的距离
//		protected var _paddingTop:int = 0;
//		protected var _paddingLeft:int = 0;
//		protected var _paddingRight:int = 0;
//		protected var _paddingBottom:int = 0;
//		
//		public function set paddingTop(value:int):void
//		{
//			_paddingTop = value;
//		}
//		public function get paddingTop():int
//		{
//			return _paddingTop;
//		}
//		public function set paddingLeft(value:int):void
//		{
//			_paddingLeft = value;
//		}
//		public function get paddingLeft():int
//		{
//			return _paddingLeft;
//		}
//		public function set paddingRight(value:int):void
//		{
//			_paddingRight = value;
//		}
//		public function get paddingRight():int
//		{
//			return _paddingRight;
//		}
//		public function set paddingBottom(value:int):void
//		{
//			_paddingBottom = value;
//		}
//		public function get paddingBottom():int
//		{
//			return _paddingBottom;
//		}
		protected var _gap:int = 0;
		public function set gap(value:int):void
		{
			_gap = value;
		}
		public function get gap():int
		{
			return _gap;
		}
		
		public function GenericLayout(container:IUIContainer)
		{
			_container = container;
		}
		
		public function layoutUpdate():void
		{
			
		}
		
		public function dispose():void
		{
			_container = null;
		}
	}
}