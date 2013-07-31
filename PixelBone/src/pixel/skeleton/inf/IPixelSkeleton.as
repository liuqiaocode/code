package pixel.skeleton.inf
{
	import flash.display.DisplayObject;
	
	import pixel.utility.IDispose;
	import pixel.utility.IUpdate;

	public interface IPixelSkeleton extends INode,IUpdate
	{
		function get view():DisplayObject;
		function play(actionName:String = null):void;
		function changeAction(name:String,frameIndex:int = 0):void;
		function findActionByName(name:String):IPixelAction;
		function findBondByName(name:String,reserve:Boolean = false):IPixelBone;
		
		function addBone(value:IPixelBone):void;
		function addAction(value:IPixelAction):void;
		function addSkin(value:IPixelBoneSkin):void;
		
		function get bones():Vector.<IPixelBone>;
		function get skins():Vector.<IPixelBoneSkin>;
		function get actions():Vector.<IPixelAction>;
	}
}