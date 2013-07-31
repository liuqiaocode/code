package editor.uitility.ui.event
{
	import flash.events.Event;

	public class EditorUtilityEvent extends Event
	{
		public static const WINDOW_CLOSE:String = "WindowClose";
		public static const WINDOW_ENTER:String = "WindowEnter";
		public static const FRAME_RESIZED:String = "FrameResized";
		public static const CONTROL_DRAG_START:String = "ControlDragStart";
		public static const CONTROL_DRAG_DROP:String = "ControlDragDrop";
		public var Params:Array = [];
		public function EditorUtilityEvent(Type:String,Bubbles:Boolean = true)
		{
			super(Type,Bubbles);
		}
	}
}