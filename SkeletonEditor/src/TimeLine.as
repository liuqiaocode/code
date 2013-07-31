package
{
	import editor.skeleton.event.SkeletonEditorEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import pixel.skeleton.PixelActionFrameKey;
	import pixel.skeleton.inf.IPixelActionFrameKey;
	
	/**
	 * 时间线
	 * 
	 **/
	public class TimeLine extends EditorNode
	{
		private var _width:int = 0;
		private var _height:int = 0;
		private var _grid:TimeLineGrid = null;
		private var _effect:TimeLineEffect = null;
		private var _active:Shape = null;
		private var _fwidth:int = 0;
		
		private var _ctxMenu1:ContextMenu = null;
		private var _ctxMenu2:ContextMenu = null;
		public function TimeLine(width:int,height:int,frameWidth:int)
		{
			_fwidth = frameWidth;
			_grid = new TimeLineGrid(width,height,frameWidth);
			addChild(_grid);
			_width = width;
			_height = height;
			_effect = new TimeLineEffect(width,height,frameWidth);
			addChild(_effect);
			_active = new Shape();
			_active.graphics.beginFill(0x666666,1);
			_active.graphics.drawRect(0,0,frameWidth,height);
			_active.graphics.endFill();
			
			addChild(_active);
			_active.visible = false;
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			addEventListener(MouseEvent.CLICK,onFrameClick);
			
			_ctxMenu1 = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("创建关键帧");
			item.data = 1;
			_ctxMenu1.addItem(item);
			
			_ctxMenu2 = new ContextMenu();
			item = new ContextMenuItem("删除关键帧");
			item.data = 2;
			_ctxMenu2.addItem(item);
			
			_ctxMenu1.addEventListener(Event.SELECT,onContextMenuSelect);
			_ctxMenu2.addEventListener(Event.SELECT,onContextMenuSelect);
		}
		
		protected function onFrameClick(event:MouseEvent):void
		{
			var idx:int = int(this.mouseX / _fwidth);
			
			var notify:SkeletonEditorEvent = new SkeletonEditorEvent(SkeletonEditorEvent.SKELETON_FRAME_JUMP,true);
			notify.params = idx;
			dispatchEvent(notify);
		}
		
		protected function onContextMenuSelect(event:Event):void
		{
			if(event.target.data == 1)
			{
				var notify:SkeletonEditorEvent = new SkeletonEditorEvent(SkeletonEditorEvent.SKELETON_NEW_FRAME_KEY,true);
				notify.params = _activeKeyNumber + 1;
				dispatchEvent(notify);
			}
			
		}
		
		private var _activeKeyNumber:int = 0;
		private var _keys:Vector.<IPixelActionFrameKey> = null;
		public function set frameKeys(value:Vector.<IPixelActionFrameKey>):void
		{
			_keys = value;
			_effect.keys = _keys;
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			_active.visible = true;
			_active.x = int(this.mouseX / _fwidth) * _fwidth;
			_active.y = 0;
			_activeKeyNumber = int(this.mouseX / _fwidth);
			//var idx:int = int(this.mouseX / _fwidth) + 1;
			
			for each(var key:IPixelActionFrameKey in _keys)
			{
				if(key.frameIndex == _activeKeyNumber + 1)
				{
					this.contextMenu = _ctxMenu2;
					return;
				}
			}
			this.contextMenu = _ctxMenu1;
		}
		
		/**
		 * 时间线右键菜单弹出
		 * 
		 **/
//		protected function onPopUpContextMenu(event:MouseEvent):void
//		{
//			
//		}
//		
		private var _action:SkeletonActionVO = null;
		public function set action(value:SkeletonActionVO):void
		{
			_action = value;
			this.frameKeys = _action.action.frames;
		}
		public function get action():SkeletonActionVO
		{
			return _action;
		}
		
		public function refreshView():void
		{
			_grid.redraw();
		}
	}
}
import flash.display.Sprite;
import flash.text.TextField;

import pixel.skeleton.inf.IPixelActionFrameKey;

class TimeLineGrid extends Sprite
{
	private var _w:int = 0;
	private var _h:int = 0;
	private var _f:int = 0;
	public function TimeLineGrid(width:int,height:int,frameWidth:int)
	{
		_w = width;
		_h = height;
		_f = frameWidth;
		redraw();
	}
	
	public function redraw():void
	{
		graphics.clear();
		graphics.lineStyle(1,0x000000);
		graphics.moveTo(0,0);
		graphics.drawRect(0,0,_w,_h);
		var count:int = _w / _f;
		var idx:int = 0;
		while(idx < count)
		{
			graphics.moveTo(idx * _f,0);
			graphics.lineTo(idx * _f,_h);
			idx++;
			
		}
	}
}

/**
 * 时间线效果层
 * 
 **/
class TimeLineEffect extends Sprite
{
	private var _w:int = 0;
	private var _h:int = 0;
	private var _f:int = 0;
	
	private var _keys:Vector.<IPixelActionFrameKey> = null;
	public function TimeLineEffect(width:int,height:int,frameWidth:int)
	{
		_w = width;
		_h = height;
		_f = frameWidth;
		//redraw();
	}
	
	/**
	 * 设置关键帧数据，重绘视图
	 * 
	 **/
	public function set keys(value:Vector.<IPixelActionFrameKey>):void
	{
		_keys = value;
		redraw();
	}
	
	public function redraw():void
	{
		this.graphics.clear();
		this.graphics.beginFill(0,0);
		this.graphics.drawRect(0,0,_w,_h);
		this.graphics.endFill();
		var key:IPixelActionFrameKey = null;
		
		while(numChildren > 0)
		{
			this.removeChildAt(0);
		}
		
		//绘制关键帧
		for each(key in _keys)
		{
			var idx:int = key.frameIndex;
			var keyNode:TimeLineKey = new TimeLineKey(key);
			if(idx > 0)
			{
				idx--;
			}
			
			keyNode.x = idx * _f;
			keyNode.y = 0;
			addChild(keyNode);
		}
		
		var next:IPixelActionFrameKey = null;
		for (var index:int = 0; index<_keys.length; index++)
		{
			key = _keys[index];
			
			if(index + 1 < _keys.length)
			{
				next = _keys[index+1];
				graphics.beginFill(0x00ff00,0.3);
				graphics.drawRect((key.frameIndex) * _f,0,((next.frameIndex - key.frameIndex - 1) * _f),height);
				graphics.endFill();
			}
		}
	}
}

class TimeLineKey extends Sprite
{
	private var _key:IPixelActionFrameKey = null;
	public function TimeLineKey(key:IPixelActionFrameKey):void
	{
		_key = key;
		
		graphics.beginFill(0x0000ff,0.3);
		graphics.drawRect(0,0,10,60);
		graphics.endFill();
	}
}