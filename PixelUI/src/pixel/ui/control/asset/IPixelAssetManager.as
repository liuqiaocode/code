package pixel.ui.control.asset
{
	import flash.display.Bitmap;
	import flash.events.IEventDispatcher;
	
	import pixel.ui.control.UIControl;

	public interface IPixelAssetManager extends IEventDispatcher
	{
		function download(url:String,type:int = PixelAssetEmu.ASSET_SWF):void;
		//function Download(Uri:Array):void;
		function FindAssetById(Id:String,domain:Boolean = true):IAsset;
		function FindBitmapById(Id:String):Bitmap;
		function addAssetLibrary(lib:IAssetLibrary):void;
		//function PushQueue(Url:String):void;
		function registerAssetHook(id:String,target:IAssetNotify):void;
		function removeAssetHook(id:String,target:IAssetNotify):void;
		//function AssetHookRegister(Id:String,Target:UIControl):void;
		//function AssetHookRemove(Id:String,Target:UIControl):void;
		function get Librarys():Vector.<IAssetLibrary>;
		function removeAssetLibrary(id:String):void;
		function clearAssetLibrary():void;
	}
}