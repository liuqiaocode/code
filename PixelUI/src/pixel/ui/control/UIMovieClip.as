package pixel.ui.control
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import pixel.ui.control.asset.AssetMovieClip;
	import pixel.ui.control.asset.IAsset;
	import pixel.ui.control.asset.PixelAssetManager;

	/**
	 * Flash movieClip组件封装层
	 * 
	 **/
	public class UIMovieClip extends UIControl
	{
		private var _movieClip:MovieClip = null;
		private var _id:String = "";
		public function set movieClipId(value:String):void
		{
			_id = value;
		}
		public function get movieClipId():String
		{
			return _id;
		}
		public function UIMovieClip()
		{
			super();	
			width = 30;
			height = 30;
		}
		
		public function set movieClip(value:MovieClip):void
		{
			_movieClip = value;
			addChild(_movieClip);
			width = _movieClip.width;
			height = _movieClip.height;
			if(this._EditMode)
			{
				_movieClip.mouseChildren = false;
				_movieClip.mouseEnabled = false;
			}
		}
		public function get movieClip():MovieClip
		{
			return _movieClip;
		}
		
		override public function EnableEditMode():void
		{
			super.EnableEditMode();
			if(_movieClip)
			{
				_movieClip.mouseChildren = false;
				_movieClip.mouseEnabled = false;
			}
		}
		
		override protected function SpecialEncode(data:ByteArray):void
		{
			if(_movieClip)
			{
				data.writeBoolean(true);
				data.writeUTF(_id);
			}
			else
			{
				data.writeBoolean(false);
			}
		}
		
		override protected function SpecialDecode(data:ByteArray):void
		{
			if(data.readBoolean())
			{
				_id = data.readUTF();
				var clip:AssetMovieClip = PixelAssetManager.instance.FindAssetById(_id) as AssetMovieClip;
				if(clip)
				{
					movieClip = clip.resource;
				}
				else
				{
					PixelAssetManager.instance.registerAssetHook(_id,this);
				}
			}
		}
		
		/**
		 * 注册资源返回
		 * 
		 **/
		override public function assetComplete(id:String,asset:IAsset):void
		{
			var clip:AssetMovieClip = asset as AssetMovieClip;
			if(clip)
			{
				movieClip = clip.resource;
			}
		}
		
		public function gotoAndStop(index:int):void
		{
			if(_movieClip)
			{
				_movieClip.gotoAndStop(index);
			}
		}
		
		public function gotoAndPlay(index:int):void
		{
			if(_movieClip)
			{
				_movieClip.gotoAndPlay(index);
			}
		}
		
		public function playStop():void
		{
			if(_movieClip)
			{
				_movieClip.stop();
			}
		}
		
		override public function dispose():void
		{
			if(_movieClip)
			{
				_movieClip.stop();
				_movieClip = null;
			}
			super.dispose();
		}
	}
}