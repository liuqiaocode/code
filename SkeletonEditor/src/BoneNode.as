package
{
	public class BoneNode
	{
		public function get skeletonName():String
		{
			return "骨骼";
		}
		
		private var _children:Array = null;
		public function get children():Array
		{
			return _children;
		}
		public function addChild(value:SkeletonBoneVO):void
		{
			if(!_children)
			{
				_children = new [];
			}
			_children.push(value);
		}
		public function set children(value:Array):void
		{
			_children = value;
		}
		
		public function BoneNode():void
		{
		}
	}
	

}