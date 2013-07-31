package pixel.skeleton.inf
{
	public interface IPixelSkeletonPlayer
	{
		function register(skeleton:IPixelSkeleton):void;
		function remove(skeleton:IPixelSkeleton):void;
		function isRegister(skeleton:IPixelSkeleton):Boolean;
	}
}
