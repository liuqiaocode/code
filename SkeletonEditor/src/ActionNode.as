package
{
	public class ActionNode
	{
		private var _children:Array = null;
		public function get children():Array
		{
			return _children;
		}
		public function addChild(value:SkeletonActionVO):void
		{
			if(!_children)
			{
				_children = [];
			}
			_children.push(value);
		}
		public function set children(value:Array):void
		{
			_children = value;
		}
		
		public function get skeletonName():String
		{
			return "动作";
		}
	}
}