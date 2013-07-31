package pixel.ui.control
{
	import pixel.ui.core.PixelUINS;

	use namespace PixelUINS
	public class UIToolTipManager
	{
		private static var _Instance:IUITipManager;
		public function UIToolTipManager()
		{
		}
		
		public static function get Instance():IUITipManager
		{
			if(null == _Instance)
			{
				_Instance = new ToolTipImpl();
			}
			return _Instance;
		}
	}
}
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flash.utils.getTimer;

import pixel.ui.control.IUITip;
import pixel.ui.control.IUITipManager;
import pixel.ui.control.TextAlign;
import pixel.ui.control.UIControl;
import pixel.ui.control.UIControlFactory;
import pixel.ui.control.UILabel;
import pixel.ui.control.UIPanel;
import pixel.ui.control.UITipDefault;
import pixel.ui.control.asset.IPixelAssetManager;
import pixel.ui.control.style.IVisualStyle;
import pixel.ui.control.vo.UIControlMod;
import pixel.ui.core.PixelUINS;

class ToolTipImpl implements IUITipManager
{
	use namespace PixelUINS;
	
	//private var _Tip:TipPanel = new TipPanel();
	private var _tip:IUITip = null;
	private var _LazyTime:int = 0;
	private var _LazyTimer:Timer = new Timer(30);
	private var _Queue:Vector.<UIControl> = null;
	private var _tipCache:Dictionary = null;
	public function ToolTipImpl()
	{
		_Queue = new Vector.<UIControl>();
		_LazyTimer.addEventListener(TimerEvent.TIMER,TimerProcess);
		_tip = new UITipDefault();
		_tipCache = new Dictionary();
	}
	
	//给控件绑定ToolTip
	public function Bind(Control:UIControl):void
	{
		if(_Queue.indexOf(Control) < 0)
		{
			_Queue.push(Control);
			Control.addEventListener(MouseEvent.MOUSE_MOVE,ToolTipActive);
			Control.addEventListener(MouseEvent.MOUSE_OUT,ToolTipUnActive);
		}
	}
	
	//解绑
	public function UnBind(Control:UIControl):void
	{
		if(_Queue.indexOf(Control) > 0)
		{
			_Queue.splice(_Queue.indexOf(Control),1);
			Control.removeEventListener(MouseEvent.MOUSE_MOVE,ToolTipActive);
			Control.removeEventListener(MouseEvent.MOUSE_OUT,ToolTipUnActive);
		}
	}
	
	public function set LazyTime(Value:int):void
	{
		_LazyTime = Value;
	}
	
	private var _Start:int = 0;
	private var _Show:Boolean = false;
	
	private function ShowTip():void
	{
		if(_CurrentControl && _CurrentControl.stage)
		{
			if(!_Show)
			{
				_CurrentControl.stage.addChild(_tip as DisplayObject);
				_tip.tipData = _CurrentControl.ToolTip;
				
				_Show = true;
			}
			_tip.x = _CurrentControl.stage.mouseX + 10;
			_tip.y = _CurrentControl.stage.mouseY + 30;
		}
	}
	
	/**
	 * 变更Tip面板
	 * 
	 **/
	public function changeTip(tip:IUITip):void
	{
		_tip = tip;
	}
	
	private function HideTip():void
	{
		_Show = false;
		if(_CurrentControl && _CurrentControl.stage)
		{
			if(_CurrentControl.stage.contains(_tip as DisplayObject))
			{
				_CurrentControl.stage.removeChild(_tip as DisplayObject);
			}
		}
	}
	
	/**
	 * 延迟计时器处理
	 **/
	private function TimerProcess(event:TimerEvent):void
	{
		var Delay:int = flash.utils.getTimer() - _Start;
		if(Delay >= _LazyTime)
		{
			//延迟时间到达。显示TIP。停止计时器
			_LazyTimer.stop();
			ShowTip();
		}
	}
	
	private var _CurrentControl:UIControl = null;
	/**
	 * 激活ToolTip
	 * 
	 * 
	 **/
	private function ToolTipActive(event:MouseEvent):void
	{
		_CurrentControl = event.currentTarget as UIControl;
		
		if(_CurrentControl)
		{
			if(_LazyTime > 0 && !_Show)
			{
				if(!_LazyTimer.running)
				{
					//延迟显示时间大于0则启动计时器
					_Start = flash.utils.getTimer();
					_LazyTimer.start();
				}
				
			}
			else
			{
				ShowTip();
			}
		}
	}
	
	/**
	 * 取消激活ToolTip
	 * 
	 * 
	 **/
	private function ToolTipUnActive(event:MouseEvent):void
	{
		if(_LazyTimer.running)
		{
			_LazyTimer.stop();
		}
		HideTip();
	}
	
	//变更皮肤
	public function ChangeSkin(style:IVisualStyle):void
	{
		UIControl(_tip).Style = style;
	}
	
	private var _showSender:DisplayObject = null;
	private var _showTipWindow:IUITip = null;
	/**
	 * 显示TIP
	 * 
	 * @param		sender		触发显示TIP的源显示对象
	 * @param		tip			要显示TIP窗口的ID
	 * @param		data		TIP要显示的数据
	 * @param		posX		TIP显示的屏幕X坐标
	 * @param		posY		TIP显示的屏幕Y坐标
	 **/
	public function show(sender:DisplayObject,tip:String,data:Object = null,posX:int = 0,posY:int = 0):void
	{
		if(_showTipWindow && _showSender)
		{
			
		}
		
		_showSender = sender;
		
		if(!(tip in _tipCache))
		{
			var mod:UIControlMod = UIControlFactory.instance.findControlById(tip);
			if(mod)
			{
				_showTipWindow = mod.getControl() as IUITip;
				if(_showTipWindow)
				{
					_tipCache[tip] = _showTipWindow;
				}
			}
		}
		else
		{
			_showTipWindow = _tipCache[tip];
		}
		
		if(_showTipWindow && sender && sender.stage)
		{
			_showTipWindow.tipData = data;
			_showTipWindow.x = posX > 0 ? posX:sender.stage.mouseX;
			_showTipWindow.y = posY > 0 ? posY:sender.stage.mouseY;
			sender.stage.addChild(_showTipWindow as DisplayObject);
			_showSender.addEventListener(MouseEvent.MOUSE_OUT,onSenderFocusOut);
		}
	}
	
	public function hideAndClear():void
	{
		if(_showSender && _showSender.stage && _showTipWindow)
		{
			if(_showSender.stage.contains(_showTipWindow as DisplayObject))
			{
				_showSender.stage.removeChild(_showTipWindow as DisplayObject);
			}
			_showSender.removeEventListener(MouseEvent.MOUSE_OUT,onSenderFocusOut);
		}
	}
	
	protected function onSenderFocusOut(event:MouseEvent):void
	{
		hideAndClear();
	}
}

