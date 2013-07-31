package pixel.ui.control.asset
{
	import pixel.ui.core.PixelUINS;

	use namespace PixelUINS;
	/**
	 * 组件资源加载管理
	 **/
	public class PixelAssetManager
	{
		private static var _Instance:IPixelAssetManager = null;
		
		public function PixelAssetManager()
		{
		}
		
		public static function get instance():IPixelAssetManager
		{
			if(null == _Instance)
			{
				_Instance = new ControlAssetManagerImpl();
			}
			
			return _Instance;
		}
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import pixel.ui.control.UIControl;
import pixel.ui.control.asset.AssetBitmap;
import pixel.ui.control.asset.AssetImage;
import pixel.ui.control.asset.AssetTools;
import pixel.ui.control.asset.IAsset;
import pixel.ui.control.asset.IAssetLibrary;
import pixel.ui.control.asset.IAssetNotify;
import pixel.ui.control.asset.IPixelAssetManager;
import pixel.ui.control.asset.PixelAssetEmu;
import pixel.ui.control.asset.PixelLoaderAssetLibrary;
import pixel.ui.control.asset.PixelSwfLibrary;
import pixel.ui.control.asset.PixelTextureAssetLibrary;
import pixel.ui.control.event.DownloadEvent;
import pixel.utility.IDispose;
import pixel.utility.Tools;

class ControlAssetManagerImpl extends EventDispatcher implements IPixelAssetManager,IDispose
{
	private var AssetDictionary:Dictionary = new Dictionary();
	//加载器
	//private var AssetLoader:Loader = null;
	//private var _Loader:Loader = null;
	private var _loader:URLLoader = null;
	//加载队列
	private var DownloadQueue:Vector.<TaskNode> = new Vector.<TaskNode>();
	//锁定标识
	private var _Busy:Boolean = false;
	
	private var _AssetLibArray:Vector.<IAssetLibrary> = new Vector.<IAssetLibrary>();
	//正在加载的资源
	private var _LibraryLoading:int = 1;
	//正在加载的资源URL
	//private var _LibraryLoadingUrl:String = "";
	private var loadingTask:TaskNode = null;
	//本次加载队列的文件总数
	private var _Total:int = 0;
	
	private var _self:ControlAssetManagerImpl = null;
	public function ControlAssetManagerImpl()
	{
		_loader = new URLLoader();
		//_Loader = new Loader();
		_loader.dataFormat = URLLoaderDataFormat.BINARY;
		//			_Loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,OnProgress);
		//			_Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,OnError);
		//			_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,OnComplete);
		//			_Loader.contentLoaderInfo.addEventListener(Event.OPEN,OnStart);
		_loader.addEventListener(ProgressEvent.PROGRESS,OnProgress);
		_loader.addEventListener(IOErrorEvent.IO_ERROR,OnError);
		_loader.addEventListener(Event.COMPLETE,OnComplete);
		_loader.addEventListener(Event.OPEN,OnStart);
		_self = this;
	}
	
	public function download(url:String,type:int = PixelAssetEmu.ASSET_SWF):void
	{
		var task:TaskNode = new TaskNode();
		task.url = url;
		task.type = type;
		DownloadQueue.push(task);
		
		if(!_Busy)
		{
			StartDownloadQueue();
		}
	}
	
	public function get Librarys():Vector.<IAssetLibrary>
	{
		return _AssetLibArray;
	}
	
	public function addAssetLibrary(lib:IAssetLibrary):void
	{
		_AssetLibArray.push(lib);
		this.checkAssetHook(lib);
	}
	
	public function clearAssetLibrary():void
	{
		_AssetLibArray.length = 0;
	}
	
	public function removeAssetLibrary(id:String):void
	{
		for each(var lib:IAssetLibrary in _AssetLibArray)
		{
			if(id == lib.id)
			{
				_AssetLibArray.splice(_AssetLibArray.indexOf(lib),1);
				return;
			}
		}
	}
	
	private var HookDict:Dictionary = new Dictionary();
	public function registerAssetHook(id:String,target:IAssetNotify):void
	{
		for each(var lib:IAssetLibrary in _AssetLibArray)
		{
			if(lib.hasDefinition(id))
			{
				//当前库资源已加载
				target.assetComplete(id,lib.findAssetByName(id));
				//target.AssetComleteNotify(id,lib.findAssetByName(id));
				return;
			}
		}
		var Vec:Vector.<IAssetNotify> = null;
		if(id in HookDict)
		{
			Vec = HookDict[id];
			if(Vec.indexOf(target) < 0)
			{
				Vec.push(target);
			}
		}
		else
		{
			Vec = new Vector.<IAssetNotify>();
			Vec.push(target);
			HookDict[id] = Vec;
		}
	}
	
	/**
	 * 资源回调注册解除
	 * 
	 * 
	 **/
	public function removeAssetHook(id:String,hook:IAssetNotify):void
	{
		if(id in HookDict)
		{
			var hooks:Vector.<IAssetNotify> = HookDict[id];
			if(hooks.indexOf(hook))
			{
				hooks.splice(hooks.indexOf(hooks),1);
			}
		}
	}
	
	private function checkAssetHook(lib:IAssetLibrary):void
	{
		var key:String = "";
		var hooks:Vector.<IAssetNotify> = null;
		var hook:IAssetNotify = null;
		for(key in HookDict)
		{
			if(lib.hasDefinition(key))
			{
				var asset:IAsset = lib.findAssetByName(key);
				hooks = HookDict[key];
				for each(hook in hooks)
				{
					hook.assetComplete(key,asset);
				}
			}
		}
	}
	
	public function PushQueue(Url:String):void
	{
		DownloadQueue.push(Url);
		if(!_Busy)
		{
			StartDownloadQueue();
		}
	}
	
	/**
	 * 开始下载队列
	 **/
	protected function StartDownloadQueue():void
	{
		if(!_Busy)
		{
			_Busy = true;
			loadingTask = DownloadQueue.shift();
			
			//var ctx:LoaderContext = new LoaderContext();
			//ctx.allowCodeImport = true;
			_loader.load(new URLRequest(loadingTask.url));
		}
	}
	
	/**
	 **/
	private function OnProgress(event:ProgressEvent):void
	{
		var Notify:DownloadEvent = new DownloadEvent(DownloadEvent.DOWNLOAD_START);
		Notify.CurrentIndex = _LibraryLoading;
		Notify.CurrentUri = loadingTask.url;
		Notify.LoadedBytes = event.bytesLoaded;
		Notify.TotalBytes = event.bytesTotal;
		Notify.Total = _Total;
		dispatchEvent(Notify);
	}
	
	private function OnError(event:IOErrorEvent):void
	{
		var Notify:DownloadEvent = new DownloadEvent(DownloadEvent.DOWNLOAD_ERROR);
		Notify.Message = event.text;
		dispatchEvent(Notify);
		if(DownloadQueue.length > 0)
		{
			//继续加载下一个资源
			StartDownloadQueue();
		}
	}
	
	private function OnComplete(event:Event):void
	{
		var lib:IAssetLibrary = null;
		var id:String = Tools.getFileName(loadingTask.url);
		var Notify:DownloadEvent = null;
		switch(loadingTask.type)
		{
			case PixelAssetEmu.ASSET_SWF:
				
				var reader:Loader = new Loader();
				reader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBinary2SwfComplete);
				var ctx:LoaderContext = new LoaderContext();
				//ctx.applicationDomain = ApplicationDomain.currentDomain;
				ctx.allowCodeImport = true;
				reader.loadBytes(_loader.data as ByteArray,ctx);
				break;
			case PixelAssetEmu.ASSET_CPL:
				lib = AssetTools.convertByte2AssetLibrary(_loader.data as ByteArray);
				_AssetLibArray.push(lib);
				IAssetNotify(lib);
				if(DownloadQueue.length > 0)
				{
					//继续加载下一个资源
					StartDownloadQueue();
				}
				else
				{
					_Busy = false;
				}
				break;
		
		}
	}
	
	private function onBinary2SwfComplete(event:Event):void
	{
		var reader:Loader = event.target as Loader;
		reader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBinary2SwfComplete);
		reader.unload();
		reader = null;
		var lib:PixelSwfLibrary = new PixelSwfLibrary(reader.content);
		//lib = new PixelLoaderAssetLibrary(reader,id);
		_AssetLibArray.push(lib);
		checkAssetHook(lib);
		var notify:DownloadEvent = new DownloadEvent(DownloadEvent.DOWNLOAD_SUCCESS);
		dispatchEvent(notify);
		if(DownloadQueue.length > 0)
		{
			//继续加载下一个资源
			StartDownloadQueue();
		}
		else
		{
			_Busy = false;
		}
	}
	
	private function definitionParse():Vector.<Object>
	{
		return null;
	}
	/**
	 * 加载开始
	 **/
	private function OnStart(event:Event):void
	{
		var Notify:DownloadEvent = new DownloadEvent(DownloadEvent.DOWNLOAD_START);
		Notify.CurrentIndex = _LibraryLoading;
		Notify.CurrentUri = loadingTask.url;
		dispatchEvent(Notify);
	}
	
	private function Clear():void
	{
		_LibraryLoading = 1;
		_Total = 0;
		loadingTask = null;
		_Busy = false;
	}
	
	public function dispose():void
	{
	}
	
	public function FindAssetById(Id:String,domain:Boolean = true):IAsset
	{
		var asset:IAsset = null;
		if(Id in AssetDictionary)
		{
			return AssetDictionary[Id];
		}
		
		var Lib:IAssetLibrary = null;
		for each(Lib in _AssetLibArray)
		{
			if(Lib.hasDefinition(Id))
			{
				asset = Lib.findAssetByName(Id);
				AssetDictionary[Id] = asset;
				return asset;
			}
		}
		
		if(domain)
		{
			if(ApplicationDomain.currentDomain.hasDefinition(Id))
			{
				var cls:Class = ApplicationDomain.currentDomain.getDefinition(Id) as Class;
				var source:BitmapData = new cls() as BitmapData;
				if(source)
				{
					asset = new AssetImage(Id,source);
					AssetDictionary[Id] = asset;
					return asset;
				}
			}
		}
		return null;
	}
	
	public function FindBitmapById(Id:String):Bitmap
	{
		var Result:Object = FindAssetById(Id);
		if(Result)
		{
			if(Result is BitmapData)
			{
				return new Bitmap(Result as BitmapData);
			}
		}
		return Result as Bitmap;
	}
}

class TaskNode
{
	public var url:String = "";
	public var type:int = PixelAssetEmu.ASSET_SWF;
}