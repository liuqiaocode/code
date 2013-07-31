package
{
	import editor.skeleton.event.SkeletonEditorEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import pixel.skeleton.inf.IPixelBone;

	public class Worksapce extends UIComponent
	{
		private var _operatorLayer:Sprite = null;
		private var _effectLayer:EffectLayer = null;
		private var _skeleton:SkeletonVO = null;
		private var _activeBox:FocusBox = new FocusBox();
		public function Worksapce()
		{
			_operatorLayer = new Sprite();
			addChild(_operatorLayer);
			_effectLayer = new EffectLayer();
			addChild(_effectLayer);
			width = Globals.WORKSPACE_WIDTH;
			height = Globals.WORKSPACE_HEIGHT;
			_effectLayer.addChild(_activeBox);

			addEventListener(SkeletonEditorEvent.SKELETON_BONE_SELECTE,onSkeletonBoneSelected);
			_activeBox.addEventListener(SkeletonEditorEvent.SKELETON_BONE_PARAM_CHANGE,onBoneChange);
		}
		
		protected function onBoneChange(event:SkeletonEditorEvent):void
		{
			var boneName:String = SkeletonBoneVO(_activeBox.node).skeletonName;
			
			trace(Array(event.params).join(","));
		}
		
		public function set skeleton(value:SkeletonVO):void
		{
			if(_skeleton && this.contains(_skeleton))
			{
				this.removeChild(_skeleton);
			}
			_skeleton = value;
			_skeleton.x = width >> 1;
			_skeleton.y = height >> 1;
			addChild(_skeleton);
		}
		
		/**
		 * 添加骨骼到当前骨架
		 * 
		 **/
		public function addBoneToSkeleton(bone:IPixelBone):void
		{
			_skeleton.addBone(bone);
		}
		
		protected var _selected:SkeletonBoneVO = null;
		/**
		 * 骨骼选中响应
		 * 
		 **/
		protected function onSkeletonBoneSelected(event:SkeletonEditorEvent):void
		{
			_selected = event.target as SkeletonBoneVO;
			//stage.addEventListener(MouseEvent.MOUSE_MOVE,onBoneDragMove);
			//stage.addEventListener(MouseEvent.MOUSE_UP,onBoneDragEnd);
			
			if(_selected.parent)
			{
				var pos:Point = new Point(_selected.x,_selected.y);
				pos = _selected.parent.localToGlobal(pos);
				pos = _effectLayer.globalToLocal(pos);
				_activeBox.node = _selected;
				_activeBox.x = pos.x;
				_activeBox.y = pos.y;
			}
		}
		
		private var _mx:int = 0;
		private var _my:int = 0;
		
		/**
		 * 
		 **/
		protected function onBoneDragMove(event:MouseEvent):void
		{
			_mx = stage.mouseX - _mx;
			_my = stage.mouseY - _my;
			_selected.rotation += (_mx < 0 ? 2:-2);
			
			_mx = stage.mouseX;
			_my = stage.mouseY;
		}
		
		protected function onBoneDragEnd(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBoneDragMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBoneDragEnd);
		}
	}
}
import flash.display.Sprite;

class EffectLayer extends Sprite
{
	public function EffectLayer()
	{
	}
}