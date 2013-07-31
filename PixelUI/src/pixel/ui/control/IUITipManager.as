package pixel.ui.control
{
	import flash.display.DisplayObject;
	
	import pixel.ui.control.style.IVisualStyle;

	public interface IUITipManager
	{
		//给控件绑定ToolTip
		function Bind(Control:UIControl):void;
		//解绑
		function UnBind(Control:UIControl):void;
		//变更皮肤
		function ChangeSkin(Skin:IVisualStyle):void;
		
		function changeTip(tip:IUITip):void;
		
		function set LazyTime(Value:int):void;
		
		function show(sender:DisplayObject,tip:String,data:Object = null,posX:int = 0,posY:int = 0):void;
	}
}