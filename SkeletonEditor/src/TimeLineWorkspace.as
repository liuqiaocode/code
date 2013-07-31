package
{
	import flash.display.Sprite;

	public class TimeLineWorkspace extends FlexSprite
	{
		private var _frameGap:int = 10;
		private var _timelineBackground:Sprite = null;
		private var _timelineBar:Sprite = null;
		public function TimeLineWorkspace()
		{
			width = 10000;
			height = 180;
			
			var line:TimeLine = new TimeLine(10000,40,6);
			addChild(line);
		}
	}
}