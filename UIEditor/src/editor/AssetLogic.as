import editor.cfg.EditorPreference;
import editor.event.NotifyEvent;
import editor.model.ComponentModel;
import editor.model.ModelFactory;
import editor.ui.AboutWindow;
import editor.ui.AssetLibraryWindow;
import editor.ui.AssetSelectWindow;
import editor.ui.ComboboxDataGridWindow;
import editor.ui.ComponentProfile;
import editor.ui.ControlLibraryItem;
import editor.ui.GlobalStyleManager;
import editor.ui.InlineStyleManagerWindow;
import editor.ui.ModuleWindow;
import editor.ui.NewAssetLibrary;
import editor.ui.NewStyleCategoryChoiceWindow;
import editor.ui.NotificationManager;
import editor.ui.PreferenceWindow;
import editor.ui.SwfImportWindow;
import editor.ui.WorkspacePlus;
import editor.ui.ControlLibrary;
import editor.uitility.ui.PopUpWindowManager;
import editor.uitility.ui.event.EditorUtilityEvent;
import editor.uitility.ui.event.PixelEditorEvent;
import editor.utils.Common;
import editor.utils.FileLoadQueue;
import editor.utils.GlobalStyle;
import editor.utils.Globals;
import editor.utils.InlineStyle;

import flash.filesystem.File;

import flashx.textLayout.elements.BreakElement;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;

import pixel.ui.control.IUIControl;
import pixel.ui.control.UIButton;
import pixel.ui.control.UICombobox;
import pixel.ui.control.UIContainer;
import pixel.ui.control.UIControl;
import pixel.ui.control.UIControlFactory;
import pixel.ui.control.UIImage;
import pixel.ui.control.UILabel;
import pixel.ui.control.UIPanel;
import pixel.ui.control.UIProgress;
import pixel.ui.control.UISlider;
import pixel.ui.control.UITextInput;
import pixel.ui.control.UIVerticalPanel;
import pixel.ui.control.UIWindow;
import pixel.ui.control.asset.AssetMovieClip;
import pixel.ui.control.asset.AssetTools;
import pixel.ui.control.asset.IAsset;
import pixel.ui.control.asset.IAssetImage;
import pixel.ui.control.asset.IAssetLibrary;
import pixel.ui.control.asset.PixelAssetEmu;
import pixel.ui.control.asset.PixelAssetLibrary;
import pixel.ui.control.asset.PixelAssetManager;
import pixel.ui.control.asset.PixelLoaderAssetLibrary;
import pixel.ui.control.event.DownloadEvent;
import pixel.ui.control.event.EditModeEvent;
import pixel.ui.control.style.UISliderStyle;
import pixel.ui.control.style.UIStyleFactory;
import pixel.ui.control.style.UIStyleManager;
import pixel.ui.control.utility.Utils;
import pixel.ui.control.vo.UIMod;
import pixel.ui.control.vo.UIStyleGroup;
import pixel.ui.control.vo.UIStyleMod;
import pixel.utility.MouseManager;
import pixel.utility.System;
import pixel.utility.Tools;

private var _resFiles:Array = [];
/**
 * 资源库加载
 * 
 * 搜索当前定义的所有目录,加载后缀为assl的资源库文件
 **/
private function initializerRes():void
{
	AssetLibraryTree.removeAll();
	moduleLibrary.removeAllElements();
	_resFiles.length = 0;
	var preference:EditorPreference = Globals.preference;
	
	if(preference)
	{
		var urls:Array = preference.assetLibraryLinks;
		var idx:int = 0;
		var file:File = null;
		for (idx = 0; idx<urls.length; idx++)
		{
			file = new File(urls[idx]);
			if(file.exists)
			{
				_resFiles.push(file);
			}
			else
			{
				preference.assetLibraryLinks.splice(idx,1);
			}
		}
		urls = preference.moduleLibraryLinks;
		for (idx = 0; idx<urls.length; idx++)
		{
			file = new File(urls[idx]);
			if(file.exists)
			{
				_resFiles.push(file);
			}
			else
			{
				preference.moduleLibraryLinks.splice(idx,1);
			}
		}
		
		if(_resFiles.length > 0)
		{
			loadResourceLibrary();
		}
		
		Globals.savePreferenceAndRefresh();
	}
}

private var file:File = null;
private var resLoader:Loader = null;
private function loadResourceLibrary():void
{
	if(_resFiles.length > 0)
	{
		file = _resFiles.shift();
		var reader:FileStream = new FileStream();
		reader.open(file,FileMode.READ);
		var data:ByteArray = new ByteArray();
		reader.readBytes(data);
		
		switch(file.extension)
		{
			case "lib":
				var lib:PixelAssetLibrary = AssetTools.convertByte2AssetLibrary(data);
				Globals.AppendAssetLibrary(lib);
				AssetLibraryTree.addItem(lib);
				PixelAssetManager.instance.addAssetLibrary(lib);
				if(_resFiles.length > 0)
				{
					loadResourceLibrary();
				}
				break;
			case "swf":
				resLoader = new Loader();
				resLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,resourceLibraryComplete);
				var ctx:LoaderContext = new LoaderContext();
				ctx.allowCodeImport = true;
				resLoader.loadBytes(data,ctx);
				break;
			case "mod":
				var mod:UIMod = UIControlFactory.instance.decode(data);
				var controlLib:ControlLibrary = new ControlLibrary();
				controlLib.module = mod;
				controlLib.libraryName = Tools.getFileName(file.name);
				moduleLibrary.addElement(controlLib);
				if(_resFiles.length > 0)
				{
					loadResourceLibrary();
				}
				break;
		}
	}
	
}
private function resourceLibraryComplete(event:Event):void
{
	var key:Vector.<String> = resLoader.contentLoaderInfo.applicationDomain.getQualifiedDefinitionNames();
	var lib:PixelLoaderAssetLibrary = new PixelLoaderAssetLibrary(resLoader,file.name,key);
	Globals.AppendAssetLibrary(lib);
	AssetLibraryTree.addItem(lib);
	PixelAssetManager.instance.addAssetLibrary(lib);
	resLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,resourceLibraryComplete);
	resLoader = null;
	
	if(_resFiles.length > 0)
	{
		loadResourceLibrary();
	}
}

private function AssetLibraryInitalized(event:DownloadEvent):void
{
	var Vec:Vector.<IAssetLibrary> = PixelAssetManager.instance.Librarys;
	
	for each(var Lib:IAssetLibrary in Vec)
	{
		Globals.AppendAssetLibrary(Lib);
		AssetLibraryTree.addItem(Lib);
	}
	//PixelAssetManager.instance.removeEventListener(DownloadEvent.DOWNLOAD_SUCCESS,AssetLibraryInitalized);
}

//private function ImportSwfLibrary(event:MouseEvent):void
//{
//	PopupWindow = PopUpWindowManager.PopUp(SwfImportWindow) as SkinnableContainer;
//	PopupWindow.addEventListener(NotifyEvent.IMPORTSWF,OnImportSwfLibrary);
//}
//
///**
// * 通过网络加载外部SWF
// **/
//private function DownloadSwfLibrary(event:MouseEvent):void
//{
//}
//
///**
// * 响应SWF导入事件
// **/
//private function OnImportSwfLibrary(event:NotifyEvent):void
//{
//	try
//	{
//		//清除该事件引用,因为响应事件的同时窗口已经关闭
//		PopupWindow.removeEventListener(NotifyEvent.IMPORTSWF,AssetLibraryCreated);
//		//PixelAssetManager.instance.addEventListener(DownloadEvent.DOWNLOAD_SINGLETASK_SUCCESS,OnImportSwfSuccess);
//		//PixelAssetManager.instance.download(event.Message);
//		
//		//将导入的库路径写入编辑器配置
//		var preference:EditorPreference = Globals.preference;
//		if(preference)
//		{
//			var files:Array = event.Params;
//			for each(var file:File in files)
//			{
//				if(file.extension == "swf")
//				{
//					preference.assetLibraryLinks.push(file.nativePath);
//				}
//				else if(file.extension == "mod")
//				{
//					preference.moduleLibraryLinks.push(file.nativePath);
//				}
//			}
//			//preference.assetLibraryLinks.push(event.Message);
//			Globals.savePreferenceAndRefresh();
//			this.initializerRes();
//		}
//	}
//	catch(Err:Error)
//	{
//		NotificationManager.Instance.Show("导入SWF失败!错误原因[" + Err.message + "]");
//	}
//	
//	NotificationManager.Instance.Show("导入SWF完成");
//}
//
//private function OnImportSwfSuccess(event:DownloadEvent):void
//{
//	Globals.Clear();
//	initializerRes();
//	PixelAssetManager.instance.removeEventListener(DownloadEvent.DOWNLOAD_SINGLETASK_SUCCESS,OnImportSwfSuccess);
//}

/**
 * 刷新资源库.
 * 
 * 先清理所有数据然后重新解析并且填充
 **/
private function OnRefreshAssetLibrary(event:MouseEvent):void
{
	Alert.show("是否确认要刷新资源库?","",Alert.YES | Alert.NO,null,function(event:CloseEvent):void{
		if(event.detail == Alert.YES)
		{
			Globals.Clear();
			AssetLibraryTree.removeAll();
			initializerRes();
		}
	});
}

private var _modulePickUpWindow:SkinnableContainer = null;
/**
 * 导入组件库
 * 
 **/
protected function importModelLibrary(event:MouseEvent):void
{
	_modulePickUpWindow = PopUpWindowManager.PopUp(SwfImportWindow) as SkinnableContainer;
	_modulePickUpWindow.addEventListener(NotifyEvent.IMPORTSWF,onModuleSelected);
}

/**
 * 组件库选择完成
 * 
 **/
private function onModuleSelected(event:NotifyEvent):void
{//清除该事件引用,因为响应事件的同时窗口已经关闭
	_modulePickUpWindow.removeEventListener(NotifyEvent.IMPORTSWF,onModuleSelected);
	_modulePickUpWindow = null;
	
	//将导入的库路径写入编辑器配置
	var preference:EditorPreference = Globals.preference;
	if(preference)
	{
		var files:Array = event.Params;
		for each(var file:File in files)
		{
			if(file.extension == "swf")
			{
				preference.assetLibraryLinks.push(file.nativePath);
			}
			else if(file.extension == "mod")
			{
				preference.moduleLibraryLinks.push(file.nativePath);
			}
		}
		//preference.assetLibraryLinks.push(event.Message);
		Globals.savePreferenceAndRefresh();
		this.initializerRes();
	}
}

/**
 * 刷新组件库
 * 
 **/
protected function refreshModelLibrary(event:MouseEvent):void
{}
