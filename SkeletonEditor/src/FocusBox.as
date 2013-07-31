package
{
	//import pixel.ui.control.UIControl;
	//import pixel.ui.control.event.EditModeEvent;
	//import pixel.ui.control.event.UIControlEvent;
	
	import editor.skeleton.event.SkeletonEditorEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	public class FocusBox extends Sprite
	{
		[Embed(source="../assets/move.png")]
		protected var MOVE:Class;
		
		
		[Embed(source="../assets/rotation.png")]
		protected var ROTATION:Class;
		
		protected var _Update:Boolean = false;
		//protected var _FrameWidth:int = 0;
		//protected var _FrameHeight:int = 0;
		protected var _BorderColor:uint = 0x1B8DEA;
		protected var _PointSize:int = 6;
		//protected var _Actived:Boolean = false;
		private var _lt:AnchorPoint = null;
		private var _lm:AnchorPoint = null;
		private var _lb:AnchorPoint = null;
		private var _mt:AnchorPoint = null;
		private var _mb:AnchorPoint = null;
		private var _rt:AnchorPoint = null;
		private var _rm:AnchorPoint = null;
		private var _rb:AnchorPoint = null;
		
		private var _node:EditorNode = null;
		
		private var _move:Sprite = null;
		private var _rotation:Sprite = null;
		public function set node(value:EditorNode):void
		{
			_node = value;
			
			redraw();
			if(_node)
			{
				visible = true;
			}
			
			var parent:SkeletonBoneVO = null;
			
			parent = _node.parent as SkeletonBoneVO;
			rotation = _node.rotation ;
			while(parent)
			{
				rotation += parent.rotation;
				parent = parent.parent as SkeletonBoneVO;
			}
		}
		public function get node():EditorNode
		{
			return _node;
		}
		
		private var _dragMode:int = 1;
		
		/**
		 * 旋转拖拽开始
		 * 
		 **/
		protected function onRotationDragBegin(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onDragMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onDragEnd);
			_dragMode = 1;
			
			_mx = stage.mouseX;
			_my = stage.mouseY;
		}
		
		/**
		 * 移动拖拽开始
		 * 
		 **/
		protected function onMoveDragBegin(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onDragMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onDragEnd);
			_dragMode = 2;
			_mx = stage.mouseX;
			_my = stage.mouseY;
		}
		
		private var _mx:int = 0;
		private var _my:int = 0;
		protected function onDragMove(event:MouseEvent):void
		{
			_mx = stage.mouseX - _mx;
			_my = stage.mouseY - _my;
			
			if(_dragMode == 1)
			{
				_node.rotation += (_mx < 0 ? 2:-2);
				rotation = _node.rotation;
				
				var parent:SkeletonBoneVO = null;
				
				parent = _node.parent as SkeletonBoneVO;
				//rotation = _node.rotation ;
				while(parent)
				{
					rotation += parent.rotation;
					parent = parent.parent as SkeletonBoneVO;
				}
			}
			else
			{
				_node.x += _mx;
				_node.y += _my;
				
				x += _mx;
				y += _my;
			}
			_mx = stage.mouseX;
			_my = stage.mouseY;
			var notify:SkeletonEditorEvent = new SkeletonEditorEvent(SkeletonEditorEvent.SKELETON_BONE_PARAM_CHANGE,true);
			notify.params = (_dragMode == 1 ? ["rotation",_node.rotation]:["x",_node.x,"y",_node.y]);
			dispatchEvent(notify);
		}
		
		protected function onDragEnd(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDragMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onDragEnd);
		}
//		
//		private function onControlStyleUpdate(event:UIControlEvent):void
//		{
//			redraw();
//		}
		
		public function close():void
		{
			_node = null;
			visible = false;
		}
		
		//private var _Control:UIControl = null;
		//private var _Focus:Boolean = false;
		
		public function FocusBox()
		{
			//_FrameWidth = _Control.width;
			//_FrameHeight = _Control.height;
			//addChild(_Control);
			visible = false;
			_lt = new AnchorPoint(_PointSize,_BorderColor);
			_lm = new AnchorPoint(_PointSize,_BorderColor);
			_lb = new AnchorPoint(_PointSize,_BorderColor);
			_mt = new AnchorPoint(_PointSize,_BorderColor);
			_mb = new AnchorPoint(_PointSize,_BorderColor);
			_rt = new AnchorPoint(_PointSize,_BorderColor);
			_rm = new AnchorPoint(_PointSize,_BorderColor);
			_rb = new AnchorPoint(_PointSize,_BorderColor);
			
			addChild(_lt);
			addChild(_lm);
			addChild(_lb);
			addChild(_mt);
			addChild(_mb);
			addChild(_rt);
			addChild(_rm);
			addChild(_rb);
			//_lt.visible = _lm.visible = _lb.visible = _mt.visible = _mb.visible = _rt.visible = _rm.visible = _rb.visible = true;
			//addEventListener(Event.ADDED_TO_STAGE,OnAdded);
			
			addEventListener(MouseEvent.MOUSE_OVER,onOver);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
			/*
			_lt.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			_lm.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			_lb.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			_mt.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			_mb.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			_rt.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			_rm.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			_rb.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			*/
			this.addEventListener(MouseEvent.MOUSE_DOWN,Click);
			
			var icon:Bitmap = new MOVE() as Bitmap;
			_move = new Sprite();
			_move.graphics.beginBitmapFill(icon.bitmapData);
			_move.graphics.drawRect(0,0,icon.width,icon.height);
			_move.graphics.endFill();
			
			icon = new ROTATION() as Bitmap;
			_rotation = new Sprite(); 
			_rotation.graphics.beginBitmapFill(icon.bitmapData);
			_rotation.graphics.drawRect(0,0,icon.width,icon.height);
			_rotation.graphics.endFill();
			
			addChild(_move);
			addChild(_rotation);
			
			_move.addEventListener(MouseEvent.MOUSE_DOWN,onMoveDragBegin);
			_rotation.addEventListener(MouseEvent.MOUSE_DOWN,onRotationDragBegin);
		}
		
		public function update():void
		{
			redraw();
		}
		
		protected function redraw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0x0000ff);
			
			if(_node)
			{
				this.graphics.drawRect(0,0,_node.width,_node.height);
				var Offset:int = _PointSize / 2 + 1;
				var Width:int =_node.width;
				var Height:int = _node.height;
				
				_lt.x = -Offset;
				_lt.y = -Offset;
				
				_lm.y = ((Height - _PointSize)) / 2;
				_lm.x = -Offset;
				
				_lb.y = Height - Offset;
				_lb.x = -Offset;
				
				_mt.x = (Width - _PointSize) / 2;
				_mt.y = -Offset;
				
				_mb.x = _mt.x;
				_mb.y = _lb.y;
				
				_rt.x = Width - Offset;
				_rt.y = _mt.y;
				
				_rm.x = _rt.x;
				_rm.y = _lm.y;
				
				_rb.x = _rt.x;
				_rb.y = _mb.y;
				
				//_control.dispatchEvent(new EditModeEvent(EditModeEvent.FRAME_RESIZED));
			}
			
			_move.x = -(_move.width);
			_move.y = -(_move.height);
			
			_rotation.x = (_node.width);
			_rotation.y = -(_rotation.height);
		}
		
		private function onOver(event:MouseEvent):void
		{
			if(event.target is AnchorPoint)
			{
				Mouse.cursor = MouseCursor.HAND;
			}
			else
			{
				Mouse.cursor = MouseCursor.ARROW;
			}
		}
		
		private function onOut(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private var _Resizable:Boolean = false;
		private var _ResizablePoint:AnchorPoint = null;
		private var _LastPoint:Point = new Point();
		protected function Click(event:MouseEvent):void
		{
			if(event.target is AnchorPoint)
			{
				_Resizable = true;
				_ResizablePoint = event.target as AnchorPoint;
				stage.addEventListener(MouseEvent.MOUSE_MOVE,ResizeMove,true);
				stage.addEventListener(MouseEvent.MOUSE_UP,ResizeClose,true);
				_LastPoint.x = event.stageX;
				_LastPoint.y = event.stageY;
			}
			else
			{
				FrameDragStart(event.localX,event.localY);
			}
		}
		
		public function EnableDragStart(Point:Object):void
		{
			_Resizable = true;
			_ResizablePoint = Point as AnchorPoint;
			if(_ResizablePoint)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,ResizeMove,true);
				stage.addEventListener(MouseEvent.MOUSE_UP,ResizeClose,true);
				_LastPoint.x = stage.mouseX;
				_LastPoint.y = stage.mouseY;
			}
		}
		
		protected function FrameDragStart(OffsetX:int,OffsetY:int):void
		{
			
		}
		
		private function ResizeClose(event:MouseEvent):void
		{
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,ResizeMove,true);
				stage.removeEventListener(MouseEvent.MOUSE_UP,ResizeClose,true);
				_Resizable = false;
				_ResizablePoint = null;
			}
			
		}
		
		private var Pos:Point = new Point();
		private function ResizeMove(event:MouseEvent):void
		{
			if(_Resizable)
			{
				event.stopPropagation();
				Pos.x = event.stageX - _LastPoint.x;
				Pos.y = event.stageY - _LastPoint.y;
				_LastPoint.x = event.stageX;
				_LastPoint.y = event.stageY;
				
				if(_ResizablePoint == _mt || _ResizablePoint == _mb)
				{
					if(_ResizablePoint == _mt)
					{
						Pos.y *= -1;
						_node.height += Pos.y;
						_node.y -= Pos.y;
						y -= Pos.y;
					}
					else
					{
						_node.height += Pos.y;
						
					}
				}
				else if(_ResizablePoint == _lm || _ResizablePoint == _rm)
				{
					if(_ResizablePoint == _lm)
					{
						Pos.x *= -1;
						_node.width += Pos.x;
						x -= Pos.x;
						_node.x -= Pos.x;
					}
					else
					{
						_node.width += Pos.x;
						
					}
				}
				else if(_ResizablePoint == _lt || _ResizablePoint == _lb)
				{
					if(_ResizablePoint == _lt)
					{
						Pos.x *= -1;
						_node.width += Pos.x;
						x -= Pos.x;
						_node.x -= Pos.x;
						
						Pos.y *= -1;
						_node.height += Pos.y;
						y -= Pos.y;
						_node.y -= Pos.y;
					}
					else
					{
						Pos.x *= -1;
						_node.width += Pos.x;
						x += Pos.x * -1;
						_node.x -= Pos.x;
						_node.height += Pos.y;
					}
				}
				else if(_ResizablePoint == _rt || _ResizablePoint == _rb)
				{
					if(_ResizablePoint == _rt)
					{
						//Pos.x *= -1;
						_node.width += Pos.x;
						
						Pos.y *= -1;
						_node.height += Pos.y;
						y -= Pos.y;
						_node.y -= Pos.y;
					}
					else
					{
						_node.width += Pos.x;
						
						_node.height += Pos.y;
					}
				}
				redraw();
			}
		}
	}
}

import flash.display.Shape;
import flash.display.Sprite;

class AnchorPoint extends Sprite
{
	public function AnchorPoint(Size:int,Color:uint)
	{
		super();
		this.graphics.clear();
		this.graphics.beginFill(Color);
		this.graphics.lineStyle(1,Color);
		this.graphics.drawRect(0,0,Size,Size);
		this.graphics.endFill();
	}
}