package editor.skeleton.event
{
	import flash.events.Event;

	public class SkeletonEditorEvent extends Event
	{
		//骨骼选中
		public static const SKELETON_BONE_SELECTE:String = "Skeleton_Bone_Select";
		
		//创建骨架
		public static const SKELETON_NEW:String = "Skeleton_CreateNew";
		
		public static const SKELETON_NEW_FRAME_KEY:String = "Skeleton_CreateFrameKey";
		
		//去到帧
		public static const SKELETON_FRAME_CHANGE:String = "frameChange";
		
		public static const SKELETON_FRAME_JUMP:String = "Skeleton_Frame_Jump";
		
		public static const SKELETON_FRAM_UPDATEBONE:String = "Skeleton_Frame_UpdateBone";
		
		public static const SKELETON_BONE_PARAM_CHANGE:String = "Skeleton_Bone_Param_Change";
		
		private var _params:Object = null;
		public function set params(value:Object):void
		{
			_params = value;
		}
		public function get params():Object
		{
			return _params;
		}
		public function SkeletonEditorEvent(type:String,bubbles:Boolean = false)
		{
			super(type,bubbles);
		}
	}
}