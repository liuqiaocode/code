package editor.ui
{
	import editor.uitility.ui.event.EditorUtilityEvent;
	
	import flash.events.MouseEvent;
	
	import mx.events.CloseEvent;
	
	import spark.components.TitleWindow;

	public class AdvanceTitleWindow extends TitleWindow
	{
		public function AdvanceTitleWindow()
		{
			addEventListener(CloseEvent.CLOSE,OnCloseWindow);
		}
		
		private function OnCloseWindow(event:CloseEvent):void
		{
			removeEventListener(CloseEvent.CLOSE,OnCloseWindow);
			CloseWindow();
		}
		
		public function CloseWindow():void
		{
			var Notify:EditorUtilityEvent = new EditorUtilityEvent(EditorUtilityEvent.WINDOW_CLOSE);
			dispatchEvent(Notify);
		}
		
		protected function Close(event:MouseEvent):void
		{
			CloseWindow();
		}
		
		public function set closeButtonEnabled(value:Boolean):void
		{
			super.closeButton.visible = value;
		}
	}
}