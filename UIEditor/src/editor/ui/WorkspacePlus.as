package editor.ui
{
	import editor.event.NotifyEvent;
	import editor.model.ComponentModel;
	import editor.model.ModelFactory;
	import editor.model.ModelFactoryBAJK;
	import editor.uitility.ui.event.EditorUtilityEvent;
	import editor.utils.Globals;
	import editor.utils.InlineStyle;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.text.engine.TextLine;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.utils.StringUtil;
	
	import pixel.ui.control.IUIContainer;
	import pixel.ui.control.IUIControl;
	import pixel.ui.control.UIButton;
	import pixel.ui.control.UIContainer;
	import pixel.ui.control.UIControl;
	import pixel.ui.control.UIControlFactory;
	import pixel.ui.control.UIPanel;
	import pixel.ui.control.asset.AssetImage;
	import pixel.ui.control.asset.IAsset;
	import pixel.ui.control.event.ControlEditModeEvent;
	import pixel.ui.control.event.EditModeEvent;
	import pixel.ui.control.event.UIControlEvent;
	import pixel.ui.control.style.IVisualStyle;
	import pixel.ui.control.utility.Utils;
	import pixel.ui.control.vo.UIControlMod;
	import pixel.ui.control.vo.UIMod;
	import pixel.ui.control.vo.UIStyleMod;
	import pixel.utility.IDispose;
	import pixel.utility.Tools;
	
	import spark.components.Group;
	
	/**
	 * 
	 * 工作区容器
	 * 因为要用到sprite的组件,所以增加一个容器进行组件管理
	 * 
	 **/
	public class WorkspacePlus extends UIComponent implements IDispose
	{
		private var _Children:Array = [];
		//新创建组件的基本信息
		private var _ComponentProfile:ComponentProfile = null;
		//当前选择的控件
		private var _focus:IUIControl = null;
		//控件层
		private var _controlLayer:Sprite = null;
		//编辑器效果层
		private var _effectLayer:Sprite = null;
		
		private var _focusBox:FocusBox = null;
		
//		private var _focusBoxArray:Array = [];
		
		private var _backgroundLayer:Sprite = null;
		
		//当前是否控件多选状态
		private var _isMuti:Boolean = false;
		
		private var _focusQueue:Array = [];
		public function WorkspacePlus()
		{
			_backgroundLayer = new Sprite();
			_backgroundLayer.graphics.beginFill(0,0);
			_backgroundLayer.graphics.drawRect(0,0,10000,10000);
			super.addChild(_backgroundLayer);
			_controlLayer = new Sprite();
			_effectLayer = new Sprite();
			_focusBox = new FocusBox();
			super.addChild(_controlLayer);
			super.addChild(_effectLayer);
			
			_effectLayer.addChild(_focusBox);
			_controlLayer.addEventListener(MouseEvent.MOUSE_DOWN,DragStart,true);
			
			_backgroundLayer.addEventListener(MouseEvent.MOUSE_DOWN,clearFocus);
		}
		
		public function get focus():IUIControl
		{
			return _focus;
		}
		
		public function focusMove(x:int,y:int):void
		{
			if(_focus)
			{
				_focus.x = x;
				_focus.y = y;
				_focus.dispatchEvent(new EditModeEvent(EditModeEvent.CONTROL_MOVED));
			}
		}
		
		private function clearFocus(event:MouseEvent):void
		{
			event.stopPropagation();
			if(_focusBox)
			{
				_focus = null;
				_focusBox.close();
				dispatchEvent(new NotifyEvent((NotifyEvent.COMPONENT_UNSELECT)));
			}
			clearMutiFocus();
		}
		
		private function clearMutiFocus():void
		{
			if(_isMuti)
			{
				_isMuti = false;
				for each(var box:FocusBox in _focusQueue)
				{
					box.close();
					box = null;
				}
			}
		}
		
		private function onControlStyleUpdate(event:UIControlEvent):void
		{
			if(_focus)
			{
				_focusBox.update();
			}
		}
		
		public function get Children():Array
		{
			return _Children;
		}
		
		public function dispose():void
		{
			if(_Children && _Children.length > 0)
			{
				var Obj:DisplayObject = null;
				
				while(Obj = _Children.pop())
				{
					if(contains(Obj))
					{
						removeChild(Obj);
					}
				}
			}
		}
		
		/**
		 * 选中指定ID的组件
		 * 
		 * 
		 **/
		public function focusControlById(id:String):void
		{
			if(_focus && _focus is IUIContainer)
			{
				var target:IUIControl = IUIContainer(_focus).findChildById(id,true);
				if(target)
				{
					_focus.removeEventListener(UIControlEvent.STYLE_UPDATE,onControlStyleUpdate);
					_focus.removeEventListener("PostionUpdate",onPositionUpdate);
					if(!Globals.command)
					{
						clearMutiFocus();
					}
					_focus = target;
					_focus.addEventListener(UIControlEvent.STYLE_UPDATE,onControlStyleUpdate);
					_focus.addEventListener("PostionUpdate",onPositionUpdate);
					_focusBox.control = _focus;
					//onPositionUpdate(null);
					if(_focus.owner)
					{
						var pos:Point = new Point(_focus.x,_focus.y);
						pos = _focus.owner ? DisplayObject(_focus.owner).localToGlobal(pos):_controlLayer.localToGlobal(pos);
						pos = _effectLayer.globalToLocal(pos);
						_focusBox.x = pos.x;
						_focusBox.y = pos.y;
						var ChoiceNotify:NotifyEvent = new NotifyEvent(NotifyEvent.COMPONENT_SELECTED);
						ChoiceNotify.Params.push(_focus);
						dispatchEvent(ChoiceNotify);
						dispatchEvent(new NotifyEvent(NotifyEvent.UPDATECONSTRUCT));
					}
				}
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(child)
			{
				_Children.push(child);
				dispatchEvent(new NotifyEvent(NotifyEvent.UPDATECONSTRUCT));
				return _controlLayer.addChild(child);
			}
			return null;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(_Children.indexOf(child) >= 0)
			{
				_Children.splice(_Children.indexOf(child),1);
			}
			return _controlLayer.removeChild(child);
		}
		
		private var offsetX:int = 0;
		private var offsetY:int = 0;
		//private var dragControl:UIControl = null;
		//private var pos:Point = new Point();
		private function DragStart(event:MouseEvent):void
		{
			if(event.target is UIControl)
			{
				event.stopImmediatePropagation();
				
				if(_focus)
				{
					_focus.removeEventListener(UIControlEvent.STYLE_UPDATE,onControlStyleUpdate);
					_focus.removeEventListener("PostionUpdate",onPositionUpdate);
					if(!Globals.command)
					{
						clearMutiFocus();
					}
				}
				if(event.target is UIControl)
				{
					_focus = event.target as UIControl;
					_focus.addEventListener(UIControlEvent.STYLE_UPDATE,onControlStyleUpdate);
					_focus.addEventListener("PostionUpdate",onPositionUpdate);
					
					if(Globals.command)
					{
//						_isMuti = true;
//						var box:FocusBox = new FocusBox();
//						box.control = _focus;
//						box.x = _effectLayer.mouseX - event.localX;
//						box.y = _effectLayer.mouseY - event.localY;
//						_focusQueue.push(box);
//						_effectLayer.addChild(box);
						_focusBox.x = _effectLayer.mouseX - event.localX;
						_focusBox.y = _effectLayer.mouseY - event.localY;
						_focusBox.control = _focus;
					}
					else
					{
						_focusBox.x = _effectLayer.mouseX - event.localX;
						_focusBox.y = _effectLayer.mouseY - event.localY;
						_focusBox.control = _focus;
					}
					
					var ChoiceNotify:NotifyEvent = new NotifyEvent(NotifyEvent.COMPONENT_SELECTED);
					ChoiceNotify.Params.push(_focus);
					dispatchEvent(ChoiceNotify);
					
					if(_Children.indexOf(_focus) >= 0)
					{
						//_FocusControl.dispatchEvent(new NotifyEvent(NotifyEvent.COMPONENT_DRAG_START));
					}
					
					if(_isMuti)
					{
						offsetX = _controlLayer.mouseX;
						offsetY = _controlLayer.mouseY;
					}
					else
					{
						offsetX = _focus.mouseX;
						offsetY = _focus.mouseY;
					}
					stage.addEventListener(MouseEvent.MOUSE_MOVE,dragControlMove);
					stage.addEventListener(MouseEvent.MOUSE_UP,DragEnd);
				}
			}
		}
		
//		public function focusPositionUpdate(x:int,y:int):void
//		{
//			if(_focus)
//			{
//				_focus.x = x;
//				_focus.y = y;
//				onPositionUpdate(null);
//			}
//		}
		
		private function onPositionUpdate(event:Event):void
		{
			var pos:Point = new Point(_focus.x,_focus.y);
			pos = _controlLayer.localToGlobal(pos);
			pos = _effectLayer.globalToLocal(pos);
			_focusBox.x = pos.x;
			_focusBox.y = pos.y;
		}
		
		public function getCurrentSelected():IUIControl
		{
			if(_focus)
			{
				return _focus as IUIControl;
			}
			return null;
		}
		
		public function deleteFocusControl():void
		{
			if(_focus)
			{
				if(_Children.indexOf(_focus) >= 0)
				{
					removeChild(_focus as DisplayObject);
					_focus = null;
					_focusBox.close();

				}
				else
				{
					_focus.owner.removeChild(_focus as DisplayObject);
					_focus = null;
					_focusBox.close();
				}
			}
		}
		
		
		private var TransPoint:Point = new Point();
		private var PosX:int = 0;
		private var PosY:int = 0;
		private function dragControlMove(Event:MouseEvent):void
		{
			
//			if(_isMuti)
//			{
//				offsetX = _controlLayer.mouseX - offsetX;
//				offsetY = _controlLayer.mouseY - offsetY;
//				
//				trace(offsetX,"_",offsetY);
//				for each(var box:FocusBox in _focusQueue)
//				{
//					box.x += offsetX;
//					box.control.x += offsetX;
//					box.y += offsetY;
//					box.control.y += offsetY;
//				}
//				offsetX = _controlLayer.mouseX;
//				offsetY = _controlLayer.mouseY;
//			}
//			else
//			{
//				
//				focusPositionFix(_focusBox);
//				_focus.dispatchEvent(new EditModeEvent(EditModeEvent.CONTROL_MOVED));
//			}
			focusPositionFix(_focusBox);
			_focus.dispatchEvent(new EditModeEvent(EditModeEvent.CONTROL_MOVED));
		}
		
		/**
		 * 修正焦点框和控件的位置
		 * 
		 **/
		private function focusPositionFix(box:FocusBox):void
		{
			TransPoint.x = _focusBox.control && _focusBox.control.owner ? _focusBox.control.owner.mouseX:_controlLayer.mouseX;
			TransPoint.y = _focusBox.control && _focusBox.control.owner ? _focusBox.control.owner.mouseY:_controlLayer.mouseY;
			PosX = TransPoint.x - offsetX;
			PosY = TransPoint.y - offsetY;
			
			var w:int = box.control && box.control.owner is UIControl ? box.control.owner.width:width;
			var h:int = box.control && box.control.owner is UIControl ? box.control.owner.height:height;
			if(PosX + box.control.width > (w))
			{
				PosX = w - box.control.width;
			}
			if(PosY + box.control.height > h)
			{
				PosY = h - box.control.height;
			}
			if(PosX < 0)
			{
				PosX = 0;
			}
			if(PosY < 0)
			{
				PosY = 0;
			}
			box.control.x = PosX;
			box.control.y = PosY;
			
			var t:Point = new Point();
			t.x = PosX;
			t.y = PosY;
			
			box.x = _effectLayer.mouseX - box.control.mouseX;
			box.y = _effectLayer.mouseY - box.control.mouseY;
		}
		
		private function DragEnd(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragControlMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,DragEnd);
		}
		
		
		/**
		 * 
		 * 
		 * 
		 **/
		public function GenerateControlModel():ByteArray
		{
			var controls:Vector.<UIControlMod> = new Vector.<UIControlMod>();
			for each(var control:IUIControl in _Children)
			{
				controls.push(new UIControlMod(control));
			}
			var mod:UIMod = new UIMod(controls,InlineStyle.styles);
			var data:ByteArray = UIControlFactory.instance.encode(mod);
			return data;
		}
		private var _originalData:ByteArray = null;
		private var _originalNav:String = "";
		public function get originalModel():ByteArray
		{
			return _originalData;
		}
		public function get originalNav():String
		{
			return _originalNav;
		}
		
		public function DecodeWorkspaceByModel(Model:ByteArray,fileNav:String = ""):void
		{
			dispose();
			_originalData = Tools.byteArrayClone(Model);
			_originalNav = fileNav;
			Model.position = 0;

			var mod:UIMod = UIControlFactory.instance.decode(Model,false);
			
			var controls:Vector.<IUIControl> = new Vector.<IUIControl>();
			for each(var controlMod:UIControlMod in mod.controls)
			{
				controls.push(controlMod.getControl(false));
			}
			InlineStyle.styles = mod.styles;
			for each(var child:UIControl in controls)
			{
				child.EnableEditMode();
				addChild(child);
			}
		}
		
		public function DecodeModelByByteOld(Model:ByteArray):void
		{
			Model.position = 0;
			dispose();
			var Component:ComponentModel = ModelFactory.Instance.Decode(Model);
			Component.Control.EnableEditMode();
			addChild(Component.Control);
		}
		
	}
}