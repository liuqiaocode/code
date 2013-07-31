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
import editor.uitility.ui.PopUpWindowManager;
import editor.uitility.ui.event.PixelEditorEvent;
import editor.uitility.ui.event.EditorUtilityEvent;
import editor.utils.Common;
import editor.utils.FileLoadQueue;
import editor.utils.GlobalStyle;
import editor.utils.Globals;
import editor.utils.InlineStyle;

import flash.events.MouseEvent;
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
import pixel.ui.control.vo.UIStyleGroup;
import pixel.ui.control.vo.UIStyleMod;
import pixel.utility.MouseManager;
import pixel.utility.System;
import pixel.utility.Tools;

 /**
 * 组件转换成代码
 **/
//			protected function GenericSourceCode(event:MouseEvent):void
//			{
//				if(ComProfile)
//				{
//					//刷新自定义组件库
//					NotificationManager.Instance.Show("代码&模型输出成功完成.");
//				}
//			}

protected function CreateModel(event:MouseEvent):void
{
	var original:ByteArray = this.EditWorkspace.originalModel;
	var originalNav:String = EditWorkspace.originalNav;
	var current:ByteArray = EditWorkspace.GenerateControlModel();
	
	if(original && originalNav != "")
	{
		//保存数据至原文件
		var modFile:File = new File(originalNav);
		var writer:FileStream = new FileStream();
		writer.open(modFile,FileMode.WRITE);
		writer.writeBytes(current);
		writer.close();
		
		EditWorkspace.DecodeWorkspaceByModel(current,originalNav);
	}
	else
	{
		var Browser:File = new File();
		Browser.addEventListener(Event.SELECT,function(event:Event):void{
			var Data:ByteArray = EditWorkspace.GenerateControlModel();
			var ModelFile:File = new File(Browser.nativePath + ".mod");
			var Writer:FileStream = new FileStream();
			Writer.open(ModelFile,FileMode.WRITE);
			Writer.writeBytes(current);
			Writer.close();
		});
		
		Browser.browseForSave("请选择保存控件模型的目标路径");
	}
}


/**
 * 打开现有数据模型
 * 
 **/
private function fileOpen():void
{
	var modelBrowser:File = new File();
	modelBrowser.addEventListener(Event.SELECT,OnModelFileSelected);
	modelBrowser.browseForOpen("请选择要打开的组件模型",[new FileFilter("UI Module","*.mod")]);
}

/**
 * 选择打开指定的组件数据模型
 **/
private function OnModelFileSelected(event:Event):void
{
	var reader:FileStream = new FileStream();
	reader.open(File(event.target),FileMode.READ);
	var model:ByteArray = new ByteArray();
	reader.readBytes(model);
	
	if(WorkspaceContainer.containsElement(EditWorkspace))
	{
		WorkspaceContainer.removeElement(EditWorkspace);
	}
	EditWorkspace = null;
	//WorkspaceContainer.closeButton.visible = false;
	ComponentBar.enabled = false;
	ControlProperty.Reset();
	ControlProperty.enabled = false;
	Enabled = true;
	EditWorkspace = new WorkspacePlus();
	EditWorkspace.width = 2048;
	EditWorkspace.height = 2048;
	EditWorkspace.x = 10;
	EditWorkspace.y = 10;
	BackFill.width = EditWorkspace.width;
	BackFill.height = EditWorkspace.height;
	EditWorkspace.addEventListener(NotifyEvent.COMPONENT_SELECTED,UpdateParameter);
	EditWorkspace.addEventListener(NotifyEvent.COMPONENT_UNSELECT,onUnSelectComponent);
	WorkspaceContainer.enabled = true;
	WorkspaceContainer.visible = true;
	WorkspaceContainer.addElement(EditWorkspace);
	ComponentBar.enabled = true;
	closeEnabled = true;
	Enabled = true;
	EditWorkspace.DecodeWorkspaceByModel(model,File(event.target).nativePath);
	
	//激活菜单
	mainMenu.enableItemById(MENU_SAVE);
	mainMenu.enableItemById(MENU_SAVEAS);
	mainMenu.enableItemById(MENU_CLOSE);
	mainMenu.enableItemById(MENU_INLINESTYLE);
	mainMenu.enableItemById(MENU_EXPORTLIST);
}

