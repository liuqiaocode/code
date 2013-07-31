package pixel.skeleton
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import pixel.skeleton.inf.IPixelBone;
	import pixel.skeleton.inf.IPixelBoneSkin;
	import pixel.skeleton.skin.PixelBitmapSkin;
	import pixel.skeleton.skin.PixelMovieClipSkin;

	public class PixelBone extends Node implements IPixelBone
	{
		protected static var BoneCount:int = 0;
		public function PixelBone(boneName:String = "")
		{
			name = boneName ? boneName:"Bone" + (BoneCount++);
		}
		
		private var _skinName:String = "";
		public function set skin(value:String):void
		{
			_skinName = value;
		}
		public function get skin():String
		{
			return _skinName;
		}
		
		private var _skin:IPixelBoneSkin = null;
		public function isBind():Boolean
		{
			return (_skin != null);
		}
		public function bind(skin:IPixelBoneSkin):void
		{
			_skin = skin;
			renderView();
		}
		
		private var _view:Sprite = null;
		public function get view():DisplayObject
		{
			if(!_view)
			{
				renderView();
			}
			
			
			return _view;
		}
		
		private var _children:Vector.<IPixelBone> = new Vector.<IPixelBone>();
		public function get children():Vector.<IPixelBone>
		{
			return _children;
		}
		
		public function set children(value:Vector.<IPixelBone>):void
		{
			_children = value;
		}
		
		protected function renderView():void
		{
			if(!_view)
			{
				_view = new Sprite();
				_view.mouseEnabled = _view.mouseChildren = false;
				_view.x = x;
				_view.y = y;
			}
			if(isBind())
			{
				if(_skin is PixelBitmapSkin)
				{
					Sprite(_view).graphics.clear();
					Sprite(_view).graphics.beginBitmapFill(PixelBitmapSkin(_skin).bitmap);
					Sprite(_view).graphics.drawRect(0,0,PixelBitmapSkin(_skin).bitmap.width,PixelBitmapSkin(_skin).bitmap.height);
					Sprite(_view).graphics.endFill();
				}
				else if(_skin is PixelMovieClipSkin)
				{
					_view.addChild(PixelMovieClipSkin(_skin).source);
				}
			}
			for each(var child:IPixelBone in _children)
			{
				_view.addChild(child.view);
			}
		}
		
		public function addChildBone(bone:IPixelBone):void
		{
			_children.push(bone);
			renderView();
		}
		
		public function update():void
		{
			
		}
		
		public function dispose():void
		{
			
		}
	}
}
