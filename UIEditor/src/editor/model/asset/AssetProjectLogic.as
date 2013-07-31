import editor.event.NotifyEvent;
import editor.model.asset.NewAssetProjectConfirm;
import editor.model.asset.vo.Asset;
import editor.model.asset.vo.AssetLibrary;
import editor.model.asset.vo.AssetProject;
import editor.model.asset.vo.AssetProjectConfig;
import editor.uitility.ui.AdvanceWindow;
import editor.uitility.ui.PopUpWindowManager;

import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import mx.controls.Alert;
import mx.events.CloseEvent;

/**
 * 查找目标资源库所属的资源项目
 * 
 * 
 **/
private function findProjectByLibrary(lib:AssetLibrary):AssetProject
{
	for each(var prj:AssetProject in _metadata)
	{
		if(prj.children.indexOf(lib) >= 0)
		{
			return prj;
		}
	}
	return null;
}

private function findLibraryByAsset(asset:Asset):AssetLibrary
{
	for each(var prj:AssetProject in _metadata)
	{
		for each(var lib:AssetLibrary in prj.librarys)
		{
			for each(var child:Asset in lib.assets)
			{
				if(child.name == asset.name)
				{
					return lib;
				}
			}
		}
	}
	return null;
}

private var _config:AssetProjectConfig = null;
protected function newProject(event:MouseEvent):void
{

	var win:AdvanceWindow = PopUpWindowManager.PopUp(NewAssetProjectConfirm) as AdvanceWindow;
	win.addEventListener(NotifyEvent.NEW_ASSET_PROJECT,onCreateComplete);
}

/**
 * 创建项目
 * 
 **/
private function onCreateComplete(event:NotifyEvent):void
{
	var prjName:String = event.Params.shift();
	var prjDir:String = event.Params.shift();
	var a:Alert
	
	var prjDirectory:File = new File(prjDir + pixel.utility.System.SystemSplitSymbol + prjName);
	if(prjDirectory.exists && prjDirectory.isDirectory)
	{
		Alert.show("目录不为空，是否覆盖？","覆盖确认",Alert.OK | Alert.CANCEL,null,function(cls:CloseEvent):void{
			if(cls.detail == Alert.OK)
			{
				projectInitializer(prjName,prjDirectory);
			}
		});
	}
	else
	{
		if(!prjDirectory.exists)
		{
			prjDirectory.createDirectory();
		}
		projectInitializer(prjName,prjDirectory);
	}
}


/**
 * 项目文件初始化
 * 
 **/
private function projectInitializer(prjName:String,prjDirectory:File):void
{
	if(prjDirectory && prjDirectory.exists)
	{
		//项目属性文件
		var prjPropertieUri:String = prjDirectory.nativePath + pixel.utility.System.SystemSplitSymbol + prjName + ".prop";
		var prjPropertie:File = new File(prjPropertieUri);
		//生成项目属性文件
		var prj:AssetProject = new AssetProject();
		prj.name = prjName;
		prj.fileNav = prjPropertieUri;
		var writer:FileStream = new FileStream();
		writer.open(prjPropertie,FileMode.WRITE);
		writer.writeUTFBytes(prj.toJson());
		writer.close();
		_metadata.addItem(prj);
		_config.addProject(prjPropertie.nativePath);
		updateConfig();
	}
}

public function compileProject():void
{
	if(_focus is AssetProject)
	{
		
	}
}