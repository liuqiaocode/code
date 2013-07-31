import editor.event.NotifyEvent;
import editor.model.asset.NewAssetLibraryConfirm;
import editor.model.asset.vo.Asset;
import editor.model.asset.vo.AssetLibrary;
import editor.model.asset.vo.AssetProject;
import editor.uitility.ui.AdvanceWindow;
import editor.uitility.ui.PopUpWindowManager;
import editor.utils.Common;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;
import flash.events.FileListEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import mx.controls.Alert;

import pixel.ui.control.asset.PixelAssetEmu;
import pixel.utility.System;

private var _library:AssetLibrary = null;
private var _asset:Vector.<Asset> = null;
private var _assetLoader:Loader = null;
private var _index:int = 0;
private var _source:Array = [];

/**
 * 资源库编译
 * 
 * 
 **/
protected function compileLibrary(library:AssetLibrary):void
{
	_index = 0;
	_library = library;
	loadAssetFiles(Vector.<Asset>(_library.assets));
}

/**
 * 下载资源文件
 * 
 **/
private function loadAssetFiles(ass:Vector.<Asset>):void
{
	_asset = ass;
	_assetLoader = new Loader();
	_assetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
	beginLoad();
}

private function beginLoad():void
{
	var asset:Asset = _asset[_index];
	var img:File = new File(asset.file);
	var reader:FileStream = new FileStream();
	reader.open(img,FileMode.READ);
	var data:ByteArray = new ByteArray();
	reader.readBytes(data);
	_assetLoader.loadBytes(data);
	//_assetLoader.load(new URLRequest(asset.file));
	_index++;
}

/**
 * 单个资源下载完毕
 * 
 **/
private function loadComplete(event:Event):void
{
	_source.push(_assetLoader.content);
	_assetLoader.unload();
	if(_index < _asset.length)
	{
		beginLoad();
	}
	else
	{
		libraryEncode();
	}
}

/**
 * 资源下载完毕，开始进行资源包编码
 * 
 **/
private function libraryEncode():void
{
	var exportName:String = _library.exportName;
	if(exportName == "")
	{
		exportName = _library.name;
	}
	var prj:AssetProject = findProjectByLibrary(_library);
	if(prj)
	{
		//获取保存路径
		var path:String = Common.getPathByNav(prj.fileNav);
		path += exportName + ".lib";
		var exportFile:File = new File(path);
	}
	
	var data:ByteArray = new ByteArray();
	//写入资源文件标识前缀
	data.writeUTFBytes(PixelAssetEmu.LIBRARY_PREFIX);
	//写入资源库Name(库ID)
	data.writeUTF(_library.name);
	//是否压缩
	data.writeByte(int(_library.isCompress));
	//资源总数
	data.writeInt(_library.assets.length);
	var idx:int = 0;
	var asset:Asset = null;
	var suffix:String = "";
	var assetData:ByteArray = null;
	for each(var content:DisplayObject in _source)
	{
		asset = _asset[idx];
		
		trace(_library.name + "_" + asset.id);
		//写入资源ID
		data.writeUTF(_library.name + "_" + asset.id);
		
		suffix = Common.getFileSuffix(asset.file);
		switch(suffix)
		{
			case "png":
				assetData = Bitmap(content).bitmapData.getPixels(Bitmap(content).bitmapData.rect);
				data.writeByte(PixelAssetEmu.ASSET_PNG);
				data.writeShort(Bitmap(content).width);
				data.writeShort(Bitmap(content).height);
				break;
			case "jpg":
				assetData = Common.getDataByFile(asset.file);
				data.writeByte(PixelAssetEmu.ASSET_JPG);
				data.writeShort(Bitmap(content).width);
				data.writeShort(Bitmap(content).height);
				break;
			case "mp3":
				break;
		}
		
		if(_library.isCompress)
		{
			assetData.compress();
			assetData.position = 0;
		}
		
		//资源长度
		data.writeInt(assetData.length);
		//资源数据
		data.writeBytes(assetData);
		idx++;
	}
	
	if(_library.isCompress)
	{
		data.compress();
		data.position = 0;
	}
	//保存文件
	var writer:FileStream = new FileStream();
	writer.open(exportFile,FileMode.WRITE);
	writer.writeBytes(data);
	writer.close();
	
	Alert.show("资源库保存完成");
}

/**
 * 创建资源库
 * 
 **/
private function onCreateLibrary(event:NotifyEvent):void
{
	var lib:AssetLibrary = new AssetLibrary();
	lib.name = event.Params.shift();
	lib.exportName = event.Params.shift();
	lib.packMode = event.Params.shift();
	lib.isCompress = event.Params.shift();
	
	if(_focus && _focus is AssetProject)
	{
		AssetProject(_focus).addLibrary(lib);
		//更新项目配置文件
		Common.setStringToFile(AssetProject(_focus).fileNav,AssetProject(_focus).toJson());
		prjTree.invalidateList();
	}
}

private var _browser:File = null;
/**
 * 导入资源
 * 
 **/
private function onImportBrowser():void
{
	_browser = new File();
	_browser.addEventListener(FileListEvent.SELECT_MULTIPLE,onImportBrowserComplete);
	_browser.browseForOpenMultiple("请选择要导入的图形或MP3文件",[new FileFilter("PNG","*.png"),new FileFilter("JPG","*.jpg"),new FileFilter("MP3","*.mp3")]);
}

/**
 * 导入文件选择完成
 **/
private function onImportBrowserComplete(event:FileListEvent):void
{
	var files:Array = event.files;
	for each(var file:File in files)
	{
		var asset:Asset = new Asset(file);
		if(_focus is AssetLibrary)
		{
			AssetLibrary(_focus).addAsset(asset);
			
		}
	}
	prjTree.invalidateList();
	
	var value:AssetProject = findProjectByLibrary(_focus as AssetLibrary);
	if(value)
	{
		Common.setStringToFile(value.fileNav,value.toJson());
	}
}

/**
 * 开启新建资源库窗口
 * 
 **/
public function showNewLibraryWindow():void
{
	var win:AdvanceWindow = PopUpWindowManager.PopUp(NewAssetLibraryConfirm) as AdvanceWindow;
	win.addEventListener(NotifyEvent.NEW_ASSET_LIBRARY,onCreateLibrary);
}

/**
 * 删除资源
 * 
 **/
private function deleteAsset():void
{
	if(_focus is Asset)
	{
		var lib:AssetLibrary = this.findLibraryByAsset(_focus as Asset);
		lib.delAsset(_focus as Asset);
		
		var value:AssetProject = findProjectByLibrary(lib);
		if(value)
		{
			Common.setStringToFile(value.fileNav,value.toJson());
		}
		
		prjTree.invalidateList();
	}
}
