package
{
	import editor.skeleton.event.SkeletonEditorEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import pixel.skeleton.PixelBone;
	import pixel.skeleton.inf.IPixelBone;

	
	public class SkeletonBoneVO extends EditorNode
	{
		public static const STATE_NORMAL:int = 1;
		public static const STATE_ACTIVE:int = 2;
		public static const STATE_FOCUS:int = 3;
		
		private var _state:int = STATE_NORMAL;
		private var _bone:IPixelBone = null;
//		private var _jointBorder:uint = 0x5d5d5d;
//		private var _jointColor:uint = 0x5d5d5d;
//		private var _arrowColor:uint = 0x000000;
		
		//激活状态颜色
		private var _activeBorderColor:uint = 0x0000ff;
		private var _activeColor:uint = 0x00ff00;
		
		private var _normalBorderColor:uint = 0x000000;
		private var _normalColor:uint = 0x000000;
		
		private var _borderColor:uint = 0;
		private var _color:uint = 0;
		
		public function get skeletonName():String
		{
			return _bone.name;
		}
		
		private var _children:Array = [];
		public function get children():Array
		{
			return _children;
		}
		public function get bone():IPixelBone
		{
			return _bone;
		}
		
		/**
		 * 变更状态
		 * 
		 **/
		public function set state(value:int):void
		{
//			if(value == STATE_NORMAL && _state == STATE_ACTIVE)
//			{
//				return ;
//			}
			_state = value;
			switch(_state)
			{
				case STATE_NORMAL:
					_borderColor = _normalBorderColor;
					_color = _normalColor;
					break;
				default:
					_borderColor = _activeBorderColor;
					_color = _activeColor;
					break;
			}
			render();
		}
		
		public function SkeletonBoneVO(parent:IPixelBone):void
		{
			_bone = parent;
			//addChild(_bone.view);
			render();
			
			addEventListener(MouseEvent.MOUSE_OVER,onFocus);
			addEventListener(MouseEvent.MOUSE_OUT,onFocusOut);
			
			updateChildren();
			addEventListener(MouseEvent.MOUSE_DOWN,dragDown);
			x = _bone.x;
			y = _bone.y;
			
			state = STATE_NORMAL;
			
			this.width = _bone.width;
			this.height = _bone.height;
		}
		
		protected function updateChildren():void
		{
			while(numChildren > 0)
			{
				this.removeChildAt(0);
			}
			
			_children.length = 0;
			for each(var bone:IPixelBone in _bone.children)
			{
				var child:SkeletonBoneVO = new SkeletonBoneVO(bone);
				_children.push(child);
				addChild(child);
			}
		}
		
		public function appendBone(bone:IPixelBone):void
		{
			bone.y = _bone.height;
			_bone.addChildBone(bone);
			updateChildren();
		}
			
		
		private function onFocus(event:MouseEvent):void
		{
			event.stopPropagation();
			state = STATE_FOCUS;
		}
		
		private function onFocusOut(event:MouseEvent):void
		{
			state = STATE_NORMAL;
		}
		
		private function dragDown(event:MouseEvent):void
		{
			event.stopPropagation();
			
			dispatchEvent(new SkeletonEditorEvent(SkeletonEditorEvent.SKELETON_BONE_SELECTE,true));
		}
		
		private function render():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,_borderColor);
			this.graphics.beginFill(_color);
			this.graphics.drawCircle(0,0,6);
			this.graphics.endFill();
			this.graphics.beginFill(0xffffff);
			this.graphics.lineStyle(2,0x000000);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(-5,10);
			this.graphics.lineTo(0,_bone.height);
			this.graphics.lineTo(5,10);
			this.graphics.lineTo(0,0);
			this.graphics.endFill();
			
			//this.graphics.lineStyle(1,0x0000ff);
			//this.graphics.drawRect(0,0,_bone.width,_bone.height);
		
		}
		
//		public function render():void
//		{
//			this.graphics.clear();
//			this.graphics.lineStyle(1,_jointBorder);
//			this.graphics.beginFill(_jointColor);
//			this.graphics.drawCircle(0,0,6);
//			this.graphics.endFill();
//			this.graphics.beginFill(0xffffff);
//			this.graphics.lineStyle(2,_arrowColor);
//			this.graphics.moveTo(0,0);
//			this.graphics.lineTo(-5,10);
//			this.graphics.lineTo(0,_bone.height);
//			this.graphics.lineTo(5,10);
//			this.graphics.lineTo(0,0);
//			this.graphics.endFill();
//		}
	}
}