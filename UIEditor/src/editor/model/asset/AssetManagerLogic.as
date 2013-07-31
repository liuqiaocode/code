import editor.event.NotifyEvent;
import editor.model.asset.vo.Asset;
import editor.model.asset.vo.AssetLibrary;
import editor.model.asset.vo.AssetProject;
import editor.model.asset.vo.AssetProjectConfig;
import editor.ui.AdvanceTitleWindow;
import editor.uitility.ui.AdvanceWindow;
import editor.uitility.ui.PopUpWindowManager;
import editor.utils.Common;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;
import flash.utils.ByteArray;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.IUIComponent;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.DragManager;

import pixel.utility.System;

[Bindable]
private var _metadata:ArrayCollection = new ArrayCollection();

//导入资源
public static const CTXMENU_IMPORT:int = 1;
//设置
public static const CTXMENU_SETTING:int = 2;
//删除资源
public static const CTXMENU_DEL:int = 3;
//创建资源库
public static const CTXMENU_NEWLIB:int = 4;
//删除资源库
public static const CTXMENU_DELLIB:int = 5;
//资源库设置
public static const CTXMENU_SETLIB:int = 6;
//项目编译
public static const CTXMENU_COMPILEPRJ:int = 7;
//库编译
public static const CTXMENU_COMPILELIB:int = 8;

public static const CTXMENU_SET:int = 9;
private static var PRJ_MENU:Array = [
	{
		label : "新建资源库",
		id : CTXMENU_NEWLIB
	},
	{
		label : "项目编译",
		id : CTXMENU_COMPILEPRJ
	},
	{
		label : "项目属性",
		id : CTXMENU_SETTING
	}
];

private static var AST_MENU:Array = [
	{
		label : "删除资源",
		id : CTXMENU_DEL
	},
	{
		label : "资源设置",
		id : CTXMENU_SET
	}
];
private static var LIB_MENU:Array = [
	{
		label : "导入资源",
		id : CTXMENU_IMPORT
	},
	{
		label : "编译库",
		id : CTXMENU_COMPILELIB
	},
	{
		label : "删除资源库",
		id : CTXMENU_DELLIB
	},
	{
		label : "资源库属性",
		id : CTXMENU_SETLIB
	}
];


private var _loader:Loader = null;
private function onListClick(event:ListEvent):void
{
	if(_focus is Asset)
	{
		if(!_loader)
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadImageComplete);
		}

		var file:File = new File(Asset(_focus).file);
		var reader:FileStream = new FileStream();
		reader.open(file,FileMode.READ);
		var data:ByteArray = new ByteArray();
		reader.readBytes(data);
		
		_loader.loadBytes(data);
	}
}

/**
 * 缩略图加载完成
 * 
 * 
 **/
private function loadImageComplete(event:Event):void
{
	if(_loader.content)
	{
		preview.source = _loader.content;
		
		//更新资源信息区域数据
		classId.text = Asset(_focus).id;
		imgWidth.text = String(Bitmap(_loader.content).width);
		imgHeight.text = String(Bitmap(_loader.content).height);
	}
}

/**
 * 更新配置文件
 * 
 **/
protected function updateConfig():void
{
	var cfg:File = new File(Common.INSTALL_DIR + Common.ASSETPRJ);
	if(cfg.exists && _config)
	{
		var writer:FileStream = new FileStream();
		writer.open(cfg,FileMode.WRITE);
		writer.writeUTFBytes(_config.toJson());
		writer.close();
	}
}

protected function onInitializer(event:FlexEvent):void
{
	var cfg:File = new File(Common.INSTALL_DIR + Common.ASSETPRJ);
	if(!cfg.exists)
	{
		_config = new AssetProjectConfig();
		var writer:FileStream = new FileStream();
		writer.open(cfg,FileMode.WRITE);
		writer.writeUTFBytes(_config.toJson());
		writer.close();
	}
	else
	{
		var data:ByteArray = Common.getDataByFile(cfg.nativePath);
		_config = new AssetProjectConfig();
		_config.decodeByJson(data.readUTFBytes(data.length));
		
		for each(var prj:String in _config.projects)
		{
			var prjData:ByteArray = Common.getDataByFile(prj);
			var assPrj:AssetProject = new AssetProject();
			assPrj.decodeByJson(prjData.readUTFBytes(prjData.length));
			assPrj.fileNav = prj;
			_metadata.addItem(assPrj);
		}
	}
	
	//右键菜单初始化
	initTreeMenu(PRJ_MENU,AST_MENU,LIB_MENU);
}


private var _prjMenuItems:Array = [];
private var _libMenuItems:Array = [];
private var _astMenuItems:Array = [];

private var _ctxMenu:ContextMenu = null;
private var _astMenu:ContextMenu = null;
private var _libMenu:ContextMenu = null;
private function initTreeMenu(treeMenu:Array,itemMenu:Array,libMenu:Array):void
{
	_ctxMenu = new ContextMenu();
	_astMenu = new ContextMenu();
	_libMenu = new ContextMenu();
	for each(var item:Object in treeMenu)
	{
		var menuItem:ContextMenuItem = new ContextMenuItem(item.label);
		menuItem.data = item.id;
		menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuSelect);
		_prjMenuItems.push(menuItem);
		_ctxMenu.addItem(menuItem);
	}
	
	for each(var astItem:Object in itemMenu)
	{
		var assetItem:ContextMenuItem = new ContextMenuItem(astItem.label);
		assetItem.data = astItem.id;
		assetItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuSelect);
		_astMenuItems.push(assetItem);
		_astMenu.addItem(assetItem);
	}
	
	for each(var libItem:Object in libMenu)
	{
		var libMenuItem:ContextMenuItem = new ContextMenuItem(libItem.label);
		libMenuItem.data = libItem.id;
		libMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onMenuSelect);
		_libMenuItems.push(libMenuItem);
		_libMenu.addItem(libMenuItem);
	}
	prjTree.contextMenu = _ctxMenu;
}


/**
 * 右键菜单响应
 * 
 **/
private function onMenuSelect(event:ContextMenuEvent):void
{
	switch(ContextMenuItem(event.currentTarget).data)
	{
		case CTXMENU_IMPORT:
			onImportBrowser();
			break;
		case CTXMENU_NEWLIB:
			showNewLibraryWindow();
			break;
		case CTXMENU_COMPILELIB:
			compileLibrary(_focus as AssetLibrary);
			//库编译
			break;
		case CTXMENU_COMPILEPRJ:
			//项目编译
			break;
		case CTXMENU_DEL:
			deleteAsset();
			//资源删除
			break;
	}
}


private var _focus:Object = null;
private function onListFocus(event:ListEvent):void
{
	_focus = event.itemRenderer.data;
	if(_focus is AssetProject)
	{
		prjTree.contextMenu = _ctxMenu;
	}
	else if(_focus is AssetLibrary)
	{
		prjTree.contextMenu = _libMenu;
	}
	else if(_focus is Asset)
	{
		prjTree.contextMenu = _astMenu;
	}
}
