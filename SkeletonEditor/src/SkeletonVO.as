package
{
	import editor.skeleton.event.SkeletonEditorEvent;
	
	import pixel.skeleton.PixelSkeletonAction;
	import pixel.skeleton.inf.IPixelAction;
	import pixel.skeleton.inf.IPixelBone;
	import pixel.skeleton.inf.IPixelBoneSkin;
	import pixel.skeleton.inf.IPixelSkeleton;
	import pixel.skeleton.skin.PixelSkin;

	public class SkeletonVO extends EditorNode
	{
		public function get skeletonName():String
		{
			return _skeleton.name;
		}
		
		private var _children:Array = [];
		public function get children():Array
		{
			return _children;
		}
		
		private var _bones:Array = [];
		private var _skeleton:IPixelSkeleton = null;
		public function get skeleton():IPixelSkeleton
		{
			return _skeleton;
		}
		public function SkeletonVO(skeleton:IPixelSkeleton)
		{
			_skeleton = skeleton;
			
			this.graphics.clear();
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0,0,6);
			this.graphics.endFill();
			
			_children.length = 0;
			var child:SkeletonBoneVO = null;
			for each(var bone:IPixelBone in _skeleton.bones)
			{
				child = new SkeletonBoneVO(bone);
				addChild(child);
			}
			
			_boneNode = new BoneNode();
			_children.push(_boneNode);
			_actionNode = new ActionNode();
			_children.push(_actionNode);
			_skinNode = new SkinNode();
			_children.push(_skinNode);
			
			var act:PixelSkeletonAction = new PixelSkeletonAction();
			act.name = "act1";
			addAction(act);
			
			var sk:PixelSkin = new PixelSkin();
			sk.name = "111";
			
			addSkin(sk);
			
			render();
		}
		
		private var _boneNode:BoneNode = null;
		private var _actionNode:ActionNode = null;
		private var _skinNode:SkinNode = null;
		
		/**
		 * 添加骨骼
		 * 
		 **/
		public function addBone(bone:IPixelBone):void
		{
			_skeleton.addBone(bone);
			//var child:SkeletonBone = new SkeletonBone(bone);
			while(this.numChildren)
			{
				removeChildAt(0);
			}
			_children.length = 0;
			var childBone:SkeletonBoneVO = null;
			for each(var child:IPixelBone in _skeleton.bones)
			{
				childBone = new SkeletonBoneVO(child);
				//_children.push(childBone);
				_bones.push(childBone);
				addChild(childBone);
			}
		}
		
		public function addAction(action:IPixelAction):void
		{
			_skeleton.addAction(action);
			_actionNode.addChild(new SkeletonActionVO(action));
			
		}
		public function addSkin(value:IPixelBoneSkin):void
		{
			_skeleton.addSkin(value);
			_skinNode.addChild(new SkeletonSkinVO(value));
		}
		
		public function render():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0x0000ff);
			this.graphics.drawRect(0,0,500,500);
		}
		
	}
}
