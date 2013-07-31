package pixel.utility
{
	/**
	 * 日期时间工具
	 * 
	 **/
	public class DateTimeTools
	{
		public function DateTimeTools()
		{
		}
		
		/**
		 * 秒转时间
		 * 
		 **/
		public static function secondToTime(second:int,split:String = ":"):String
		{
			if(second <= 0)
			{
				return "00" + split + "00" + split + "00";
			}
			var min:int = second / 60;
			var sec:int = second % 60;
			var hour:int = 0;
			if(min > 60)
			{
				hour = min / 60;
				min = min % 60;
			}
			
			return ((hour < 10 ? "0" + hour:String(hour)) + split + (min < 10 ? "0" + min:String(min)) + split + (sec < 10 ? "0" + sec:String(sec)));
		}
	}
}