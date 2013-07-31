package pixel.skeleton.error
{
	public class PixelSkeletonError extends Error
	{
		public static const ERROR_ACTIONNAME:String = "ErrorActionName";
		
		public function PixelSkeletonError(message:*,id:int = 0)
		{
			super(message,id);
		}
	}
}