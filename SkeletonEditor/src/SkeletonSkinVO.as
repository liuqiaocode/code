package
{
	import pixel.skeleton.inf.IPixelBoneSkin;

	public class SkeletonSkinVO
	{
		private var _skin:IPixelBoneSkin = null;
		public function get skeletonName():String
		{
			return _skin.name;
		}
		
		public function SkeletonSkinVO(skin:IPixelBoneSkin)
		{
			_skin = skin;
		}
	}
}