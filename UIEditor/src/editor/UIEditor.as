import editor.ClipBoard;
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
import editor.uitility.ui.event.EditorUtilityEvent;
import editor.uitility.ui.event.PixelEditorEvent;
import editor.utils.Common;
import editor.utils.FileLoadQueue;
import editor.utils.GlobalStyle;
import editor.utils.Globals;
import editor.utils.InlineStyle;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.ui.Keyboard;

import flashx.textLayout.elements.BreakElement;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;

import pixel.ui.control.IUIContainer;
import pixel.ui.control.IUIControl;
import pixel.ui.control.UIButton;
import pixel.ui.control.UICombobox;
import pixel.ui.control.UIContainer;
import pixel.ui.control.UIControl;
import pixel.ui.control.UIImage;
import pixel.ui.control.UILabel;
import pixel.ui.control.UIPaginationPanel;
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

import spark.components.Application;
import spark.components.SkinnableContainer;
import spark.skins.spark.ImageSkin;

[Embed(source="assets/AssetLibrary.png")]
private var TreeIcon:Class;
[Embed(source="assets/AssetSwf.png")]
private var TreeSwfIcon:Class;

[Embed(source="assets/Button.png")]
private var ButtonIcon:Class;
private var buttonIcon:Bitmap = new ButtonIcon() as Bitmap;

[Embed(source="assets/SimplePanel.png")]
private var PanelIcon:Class;
private var panelIcon:Bitmap = new PanelIcon() as Bitmap;

[Embed(source="assets/Tabpanel.png")]
private var TabPanelIcon:Class;
private var tabPanelIcon:Bitmap = new TabPanelIcon() as Bitmap;

[Embed(source="assets/hslider.png")]
private var SliderIcon:Class;
private var sliderIcon:Bitmap = new SliderIcon() as Bitmap;

[Embed(source="assets/Label.png")]
private var LabelIcon:Class;
private var labelIcon:Bitmap = new LabelIcon() as Bitmap;

[Embed(source="assets/Component.png")]
private var ComponentIcon:Class;
private var componentIcon:Bitmap = new ComponentIcon() as Bitmap;

[Embed(source="assets/Combobox.png")]
private var ComboboxIcon:Class;
private var comboboxIcon:Bitmap = new ComboboxIcon() as Bitmap;

[Embed(source="assets/Input.png")]
private var TextInputIcon:Class;
private var textinputIcon:Bitmap = new TextInputIcon() as Bitmap;

[Embed(source="assets/VerticalPanel.png")]
private var VPanelIcon:Class;
private var vpanelIcon:Bitmap = new VPanelIcon() as Bitmap;

[Embed(source="assets/Progress.png")]
private var ProgressIcon:Class;
private var progressIcon:Bitmap = new ProgressIcon() as Bitmap;

[Embed(source="assets/Window.png")]
private var WindowIcon:Class;
private var windowIcon:Bitmap = new WindowIcon() as Bitmap;

[Embed(source="assets/Image.png")]
private var ImageIcon:Class;
private var imageIcon:Bitmap = new ImageIcon() as Bitmap;

[Embed(source="assets/Toggle.png")]
private var ToggleIcon:Class;
private var toggleIcon:Bitmap = new ToggleIcon() as Bitmap;

[Embed(source="assets/Radio.png")]
private var RadioIcon:Class;
private var radioIcon:Bitmap = new RadioIcon() as Bitmap;

[Embed(source="assets/RadioGroup.png")]
private var RadioGroupIcon:Class;
private var radioGroupIcon:Bitmap = new RadioGroupIcon() as Bitmap;

[Embed(source="assets/movie.png")]
private var MovieClipIcon:Class;
private var movieClipIcon:Bitmap = new MovieClipIcon() as Bitmap;

[Embed(source="assets/controlIcon.png")]
private var ControlIcon:Class;
private var controlIcon:Bitmap = new ControlIcon() as Bitmap;

//当前弹出的菜单
private var PopupWindow:SkinnableContainer = null;
//当前窗体类型
//private var WindowState:int = -1;

[Bindable]
private var AssetLibraryTree:ArrayCollection = new ArrayCollection();

[Bindable]
private var controlLibraryTree:ArrayCollection = new ArrayCollection();

[Bindable]
private var controlTree:ArrayCollection = new ArrayCollection();

[Bindable]
private var vv:Boolean = false;

[Bindable]
private var closeEnabled:Boolean = false;
public static const MENU_NEW:String = "New";
public static const MENU_SAVE:String = "Save";
public static const MENU_SAVEAS:String = "SaveAs";
public static const MENU_OPEN:String = "Open";
public static const MENU_CLOSE:String = "Close";
public static const MENU_EXPORTLIST:String = "ExportList";
public static const MENU_ANIM:String = "Anim";

public static const MENU_INLINESTYLE:String = "InlineStyle";
public static const MENU_GLOBALSTYLE:String = "GlobalStyle";
public static const MENU_VERSION:String = "Version";

public static const MENU_ASSET:String = "AssetManager";
public static const MENU_MOD:String = "ModManager";

[Bindable]
private var controls:ArrayCollection = new ArrayCollection([
	{
		label: "Button",
		id: Utils.BUTTON,
		icon: buttonIcon
	},
	{
		label: "FilterButton",
		id: Utils.BUTTON_FILTER,
		icon: buttonIcon
	},
	{
		label: "Panel",
		id: Utils.PANEL,
		icon: panelIcon
	},
	{
		label: "Slider",
		id: Utils.SLIDER,
		icon: sliderIcon
	},
	{
		label: "Label",
		id: Utils.LABEL,
		icon: labelIcon
	},
	{
		label: "Colorful Label",
		id: Utils.COLORFULLABEL,
		icon: labelIcon
	},
	{
		label: "TextInput",
		id: Utils.TEXTINPUT,
		icon: textinputIcon
	},
	{
		label: "Combobox",
		id: Utils.COMBOBOX,
		icon: comboboxIcon
	},
	{
		label: "VerticalPanel",
		id: Utils.VPANEL,
		icon: vpanelIcon
	},
	{
		label: "Progress",
		id: Utils.PROGRESS,
		icon: progressIcon
	},
	{
		label: "Image",
		id: Utils.IMAGE,
		icon: imageIcon
	},
	{
		label: "ImageNumber",
		id: Utils.IMAGENUMBER,
		icon: imageIcon
	},
	//				{
	//					label: "Window",
	//					id: Utils.WINDOW,
	//					icon: windowIcon
	//				},
	{
		label: "CheckBox",
		id: Utils.CHECKBOX,
		icon: windowIcon
	},
	{
		label : "ToggleButton",
		id: Utils.TOGGLE_BUTTON,
		icon: toggleIcon
	},
	{
		label : "Radio",
		id: Utils.RADIO,
		icon: radioIcon
	},
	{
		label : "ToggleGroup",
		id: Utils.TOGGLEGROUP,
		icon: radioGroupIcon
	},
	{
		label : "ScaleButton",
		id: Utils.SCALEBUTTON,
		icon: buttonIcon
	},
	{
		label : "MovieClip",
		id: Utils.MOVIECLIP,
		icon: radioGroupIcon
	},
	{
		label : "PagePanel",
		id : Utils.PAGE_PANEL,
		icon: panelIcon
	}
	
]);

[Bindable]
private var menuData:Array = [
	{
		label: "组件",
		children: [
			{
				id: MENU_NEW,
				label: "新建"
			},
			{
				id: MENU_OPEN,
				label: "打开"
			},
			{
				id: MENU_EXPORTLIST,
				label : "导出描述文件",
				enabled : false
			},
			{
				id: MENU_SAVE,
				label: "保存",
				enabled: false
			},
			{
				id: MENU_SAVEAS,
				label: "另存为",
				enabled: false
			}
		]
	},
	{
		label : "资源&组件",
		children : [
			{
				id: MENU_ASSET,
				label : "资源管理"
			},
			{
				id: MENU_ASSET,
				label : "组件管理"
			}
		]
	},
//	{
//		label : "样式管理",
//		children: [
//			{
//				enabled: false,
//				id: MENU_INLINESTYLE,
//				label: "局部样式"
//			},
//			{
//				enabled: true,
//				id: MENU_GLOBALSTYLE,
//				label: "全局样式"
//			}
//		]
//	},
//	{
//		label : "动画管理",
//		children : [
//			{
//				enabled: true,
//				id: MENU_ANIM,
//				label: "创建动画"
//			}
//		]
//	},
	{
		label : "帮助",
		children : [
			{
				id : MENU_VERSION,
				label : "版本说明"
			}
		]
	}
	
];

public static const WORKSPACE_WIDTH:int = 10000;
public static const WORKSPACE_HEIGHT:int = 10000;

//private var _commandPressed:Boolean = false;
/**
 * 初始化
 **/
protected function ApplicationComplete(event:Event):void
{
	Globals.preferenceInitializer();
	
	//nativeWindow.x = Screen.mainScreen.visibleBounds.width/2 - this.width/2;
	//nativeWindow.y = Screen.mainScreen.visibleBounds.height/2 - this.height/2;
	WorkspaceContainer.enabled = true;
	
	stage.addEventListener(KeyboardEvent.KEY_DOWN,function(event:KeyboardEvent):void{
		
		switch(event.keyCode)
		{
			case Keyboard.DELETE:
				if(EditWorkspace)
				{
					EditWorkspace.deleteFocusControl();
				}
				break;
			case Keyboard.ALTERNATE:
				
				Globals.command = true;
				break;
			case Keyboard.C:
				if(Globals.command && EditWorkspace.getCurrentSelected())
				{
					//复制当前选中的组件,将当前组件的数据放入剪切板
					ClipBoard.pushToClipboard(EditWorkspace.getCurrentSelected());
				}
				break;
			case Keyboard.V:
				if(Globals.command)
				{
					var control:IUIControl = ClipBoard.getControlFromClipboard();
					var container:UIContainer = EditWorkspace.getCurrentSelected() as UIContainer;
					if(container)
					{
						//将复制的控件添加进入当前选中的容器
						container.addChild(control as DisplayObject);
					}
					else
					{
						EditWorkspace.addChild(control as DisplayObject);
					}
				}
				break;
			case Keyboard.S:
				if(EditWorkspace)
				{
					fileSave();
				}
				break;
			case Keyboard.UP:
				if(EditWorkspace && EditWorkspace.focus)
				{
					EditWorkspace.focusMove(EditWorkspace.focus.x,EditWorkspace.focus.y - 1);
				}
				break;
			case Keyboard.LEFT:
				if(EditWorkspace && EditWorkspace.focus)
				{
					EditWorkspace.focusMove(EditWorkspace.focus.x - 1,EditWorkspace.focus.y);
				}
				break;
			case Keyboard.RIGHT:
				if(EditWorkspace && EditWorkspace.focus)
				{
					EditWorkspace.focusMove(EditWorkspace.focus.x + 1,EditWorkspace.focus.y);
				}
				break;
			case Keyboard.DOWN:
				if(EditWorkspace && EditWorkspace.focus)
				{
					EditWorkspace.focusMove(EditWorkspace.focus.x,EditWorkspace.focus.y + 1);
				}
				break;
		}
	});
	
	stage.addEventListener(KeyboardEvent.KEY_UP,function(event:KeyboardEvent):void{
		
		if(event.keyCode == Keyboard.ALTERNATE)
		{
			Globals.command = false;
		}
		
	});
	initializerRes();
	GlobalStyle.refresh();
	
	//组件容器监听组件拖拽事件
	moduleLibrary.addEventListener(EditorUtilityEvent.CONTROL_DRAG_START,onControlDragStart);
}


private function initializerStyle():void
{
	var styleDir:File = new File(Common.DEFAULT_DIR_STYLES);
	
	if(!styleDir.exists)
	{
		styleDir.createDirectory();
		return;
	}
}

private function ModelFileLoaded(ModelFile:File,Data:ByteArray):void
{
	var Component:ComponentModel = ModelFactory.Instance.Decode(Data);
	Component.ModelFile = ModelFile;
	var ComponentItem:ControlLibraryItem = new ControlLibraryItem();
	ComponentItem.AddComponent(Component);
	//ComponentLibrary.addElement(ComponentItem);
}

private var Total:int = 10;
/**
 * 资源库创建成功回调
 **/
private function AssetLibraryCreated(event:NotifyEvent):void
{
	var Library:IAssetLibrary = event.Params.pop() as IAssetLibrary;
	AssetLibraryTree.addItem(Library);
}

[Bindable]
private var Enabled:Boolean = false;

private function CreateWindowByClass(WindowClass:Class):SkinnableContainer
{
	var Window:SkinnableContainer = new WindowClass() as SkinnableContainer;
	return Window;
}

//组件基本信息
private var ComProfile:ComponentProfile = null;
//复合组件的底层容器
private var ParentContainer:UIContainer;
//private var EditWorkspace:Workspace = null;
private var EditWorkspace:WorkspacePlus = null;

private var _CurrentSelect:UIControl = null;
/**
 * 更新当前选择控件的属性面板
 **/
private function UpdateParameter(event:NotifyEvent):void
{
	_CurrentSelect = event.Params.pop() as UIControl;
	ControlProperty.Control = _CurrentSelect;
	ControlProperty.enabled = true;
	
	controlTree.removeAll();
	
	if(_CurrentSelect is UIContainer)
	{
		controlTree.addAll(CreateTreeNodes(UIContainer(_CurrentSelect)));
	}
}

private function CreateTreeNodes(Parent:UIContainer):ArrayCollection
{
	var List:ArrayCollection = new ArrayCollection();
	var Children:Array = Parent.children;
	
	for each(var Child:UIControl in Children)
	{
		//var ChildNode:Array = (Child is Container ? CreateTreeNodes(Child):[]);
		List.addItem({
			id: Child.id,
			Type: Utils.GetControlPrototype(Child),
			Control: Child,
			children: (Child is UIContainer ? CreateTreeNodes(UIContainer(Child)):[])
		});
	}
	
	return List;
}


/**
 * 资源库图标生成
 **/
private function TreeIconFactory(Item:Object):Class
{
	if(Item is IAssetLibrary)
	{
		return TreeSwfIcon;
	}
	return TreeIcon;	
}

/**
 * 资源库选择 
 **/
private function TreeItemClick(event:ListEvent):void
{
	var Library:IAssetLibrary = AssetLibraryTree.getItemAt(event.rowIndex) as IAssetLibrary;
	var window:AssetLibraryWindow = PopUpWindowManager.PopUp(AssetLibraryWindow) as AssetLibraryWindow;
	var i:IUIControl
	window.AssetLibraryItem(Library);
}

/**
 * 
 * 新建文件
 * 
 **/
private function fileNew():void
{
	if(null != EditWorkspace)
	{
		Alert.show("是否保存当前工作区的任务然后再新建？","任务进度保存提醒",Alert.YES | Alert.CANCEL,null,function(event:CloseEvent):void{
			
			if(event.detail == Alert.YES)
			{
				//保存当前工作区状态
				var Browser:File = new File();
				Browser.addEventListener(Event.SELECT,function(event:Event):void{
					var Data:ByteArray = EditWorkspace.GenerateControlModel();
					var ModelFile:File = new File(Browser.nativePath + ".mod");
					var Writer:FileStream = new FileStream();
					Writer.open(ModelFile,FileMode.WRITE);
					Writer.writeBytes(Data,0,Data.length);
					Writer.close();
					//清理当前工作区
					resetEditor();
					//保存完成后初始化工作区
					WorkspaceInitializer();
				});
				Browser.browseForSave("请选择保存控件模型的目标路径");
			}
		});
	}
	else
	{
		mainMenu.enableItemById(MENU_SAVE);
		mainMenu.enableItemById(MENU_SAVEAS);
		mainMenu.enableItemById(MENU_CLOSE);
		mainMenu.enableItemById(MENU_INLINESTYLE);
		mainMenu.enableItemById(MENU_EXPORTLIST);
		resetEditor();
		WorkspaceInitializer();
	}
}


private function fileClose():void
{
	resetEditor();
	mainMenu.disabledItemById(MENU_SAVE);
	mainMenu.disabledItemById(MENU_SAVEAS);
	mainMenu.disabledItemById(MENU_CLOSE);
	mainMenu.disabledItemById(MENU_INLINESTYLE);
	mainMenu.disabledItemById(MENU_EXPORTLIST);
}
/**
 * 
 * 保存当前编辑数据
 * 
 **/
private function fileSave():void
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
		
		//EditWorkspace.DecodeWorkspaceByModel(current,originalNav);
	}
	else
	{
		var Browser:File = new File();
		Browser.addEventListener(Event.SELECT,function(event:Event):void{
			saveModStream(current,Browser.nativePath);
		});
		
		Browser.browseForSave("请选择保存控件模型的目标路径");
	}
}

/**
 * 
 * 另存当前数据
 * 
 **/
private function fileSaveas():void
{
	var current:ByteArray = EditWorkspace.GenerateControlModel();
	var Browser:File = new File();
	Browser.addEventListener(Event.SELECT,function(event:Event):void{
		var Data:ByteArray = EditWorkspace.GenerateControlModel();
		saveModStream(Data,Browser.nativePath);
	});
	
	Browser.browseForSave("请选择保存控件模型的目标路径");
}

private function saveModStream(data:ByteArray,nav:String):void
{
	var filePath:String = nav.indexOf(".mod") < 0 ? nav + ".mod":nav;
	var ModelFile:File = new File(filePath);
	var Writer:FileStream = new FileStream();
	Writer.open(ModelFile,FileMode.WRITE);
	Writer.writeBytes(data);
	Writer.close();
}

/**
 * 全局样式组管理
 * 
 * 
 **/
private function globalStyleManager():void
{
	var window:GlobalStyleManager = PopUpWindowManager.PopUp(GlobalStyleManager) as GlobalStyleManager;
	
}

/**
 * 工作区初始化
 * 
 * 
 **/
private function WorkspaceInitializer():void
{
	Enabled = true;
	ComponentBar.enabled = true;
	closeEnabled = true;
	EditWorkspace = new WorkspacePlus();
	EditWorkspace.width = WORKSPACE_WIDTH;
	EditWorkspace.height = WORKSPACE_HEIGHT;
	BackFill.width = EditWorkspace.width;
	BackFill.height = EditWorkspace.height;
	
	EditWorkspace.addEventListener(NotifyEvent.UPDATECONSTRUCT,function(event:NotifyEvent):void{
		controlTree = new ArrayCollection(event.Params.pop() as Array);
	});
	//EditWorkspace.BuildWorkspace(ComProfile);
	WorkspaceContainer.enabled = true;
	EditWorkspace.x = 10;
	EditWorkspace.y = 10;
	WorkspaceContainer.addElement(EditWorkspace);
	WorkspaceContainer.visible = true;
	EditWorkspace.addEventListener(NotifyEvent.COMPONENT_SELECTED,UpdateParameter);
	EditWorkspace.addEventListener(NotifyEvent.COMPONENT_UNSELECT,onUnSelectComponent);
	closeEnabled = true;
	InlineStyle.clear();
}

private function onUnSelectComponent(event:NotifyEvent):void
{
	ControlProperty.Reset();
}

private function resetEditor():void
{
	
	if(WorkspaceContainer.containsElement(EditWorkspace))
	{
		WorkspaceContainer.removeElement(EditWorkspace);
	}
	EditWorkspace = null;
	//WorkspaceContainer.closeButton.visible = false;
	ComponentBar.enabled = false;
	ControlProperty.Reset();
	ControlProperty.enabled = false;
	
	controlTree = new ArrayCollection();
	closeEnabled = false;
	Enabled = false;
	InlineStyle.clear();
	
}

/**
 * 当前选择控件变更背景图片的响应事件
 **/
private function OnChangeControlImage(event:NotifyEvent):void
{
	var window:IFlexDisplayObject = PopUpWindowManager.PopUp(AssetSelectWindow);
	AssetSelectWindow(window).Item = AssetLibraryTree;
	window.addEventListener(NotifyEvent.SELECTEDASSET,function(event:NotifyEvent):void{
		AssetSelectWindow(window).CloseWindow();
		//资源选择完成
		var LibId:String = event.Params.pop();
		var AssId:String = event.Params.pop();
		ControlProperty.ChangeImageResult(LibId,AssId);
	});
}

private var _DragControl:UIControl = null;
private var _DefaultCursor:String = "";
private var _CursorName:String = "";
/**
 * 控件开始拖拽
 **/
public function StartDrag(event:MouseEvent):void
{
	var type:int = int(event.currentTarget.name);
	var prototype:Class = Utils.GetPrototypeByType(type);
	try
	{
		_DragControl = new prototype() as UIControl;
		if(_DragControl)
		{
			_DragControl.initializer();
		}
		MouseManager.Instance.Register("Drag",[ImageSkin(event.target).imageDisplay.bitmapData],true);
		_DragControl.EnableEditMode();
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE,DragMove);
		this.stage.addEventListener(MouseEvent.MOUSE_UP,DropControl);
	}
	catch(Err:Error)
	{
		Alert.show("错误组件");
	}
}

private function ComponentStartDrag(event:NotifyEvent):void
{
	_DragControl = ComponentModel(event.Params.pop()) as UIControl;
	//MouseManager.Instance.Register("Drag",[Bitmap(new ComponentIcon()).bitmapData],true);
	
	stage.addEventListener(MouseEvent.MOUSE_MOVE,DragMove);
	stage.addEventListener(MouseEvent.MOUSE_UP,DropControl);
}

private function ComponentChoice(event:NotifyEvent):void
{
	var Data:ByteArray = new ByteArray();
	var Source:ByteArray = ComponentModel(_DragControl).ModelByte;
	Source.position = 0;
	Source.readBytes(Data,0,Source.length);
	//ComponentModel(_DragControl).ModelByte.readBytes(Data,0,ComponentModel(_DragControl).ModelByte.length);
	Data.position = 0;
	var Copy:ComponentModel = ModelFactory.Instance.Decode(Data);
	var Control:UIControl = Copy.Control;
	
	EditWorkspace.addChild(Control);
}

private function DragMove(event:MouseEvent):void
{
	//trace(event.target);	
}

private function DropControl(event:MouseEvent):void
{
	stage.removeEventListener(MouseEvent.MOUSE_MOVE,DragMove);
	stage.removeEventListener(MouseEvent.MOUSE_UP,DropControl);
	var control:UIControl = null;
	control = _DragControl.clone() as UIControl;
	control.EnableEditMode();
	MouseManager.Instance.Default();
	try
	{
		if(_DragControl is UIControl)
		{
			control.x = event.localX;
			control.y = event.localY;
			
			if(event.target is UIContainer && !(event.target is UIPaginationPanel))
			{
				UIContainer(event.target).OnDrop(control);
				//this.EditWorkspace.OnComponentChoice(_DragControl);
			}
			else
			{
				EditWorkspace.addChild(control);
			}
		}
		
	}
	catch(Err:Error)
	{
		trace(Err.message);
	}
}

private var _dragControl:IUIControl = null;
/**
 * 组件库组件拖拽开始
 * 
 **/
protected function onControlDragStart(event:EditorUtilityEvent):void
{
	MouseManager.Instance.Register("ControlDrag",[controlIcon.bitmapData],true);
	stage.addEventListener(MouseEvent.MOUSE_UP,onControlDrogDrop);
	_dragControl = event.Params.shift();
}

/**
 * 组件放置
 * 
 **/
protected function onControlDrogDrop(event:MouseEvent):void
{
	stage.removeEventListener(MouseEvent.MOUSE_UP,onControlDrogDrop);
	MouseManager.Instance.Default();
	
	if(event.target is UIContainer && !(event.target is UIPaginationPanel))
	{
		_dragControl.EnableEditMode();
		UIContainer(event.target).OnDrop(_dragControl);
	}
	else
	{
		if(EditWorkspace)
		{
			var control:IUIControl = _dragControl.clone();
			control.id = "";
			control.EnableEditMode();
			EditWorkspace.addChild(control as DisplayObject);
		}
	}
}

protected function menuSelected(event:PixelEditorEvent):void
{
	var id:String = event.value as String;
	switch(id)
	{
		case MENU_NEW:
			fileNew();
			break;
		case MENU_OPEN:
			fileOpen();
			break;
		case MENU_SAVE:
			fileSave();
			break;
		case MENU_CLOSE:
			fileClose();
			break;
		case MENU_SAVEAS:
			fileSaveas();
			break;
		case MENU_GLOBALSTYLE:
			globalStyleManager();
			break;
		case MENU_INLINESTYLE:
			PopUpWindowManager.PopUp(InlineStyleManagerWindow);
			break;
		case MENU_VERSION:
			PopUpWindowManager.PopUp(AboutWindow);
			break;
		case MENU_EXPORTLIST:
			exportList();
			break;
		case MENU_ANIM:
			openAssetManagerModule();
			break;
	}
}

private var _module:ModuleWindow = null;
private function openAssetManagerModule():void
{
	_module = PopUpWindowManager.PopUp(ModuleWindow) as ModuleWindow;
	_module.navUrl = "editor/model/asset/AssetManager.swf";
	_module.addEventListener(NotifyEvent.MODULE_CLOSE,onModuleClose);
}

private function onModuleClose(event:NotifyEvent):void
{
	
}

/**
 * 导出组件集的描述文件
 * 
 **/
protected function exportList():void
{
	var itemTemplate:String = "<control id=\"{id}\" type=\"{type}\">";
	var doc:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><controls>";
	
	var controls:Array = this.EditWorkspace.Children;
	
	for each(var control:IUIControl in controls)
	{
		doc += exportControl(control);
	}
	
	doc += "</controls>";
	
	var browser:File = new File();
	browser.addEventListener(Event.SELECT,function(event:Event):void{
		var file:File = new File(browser.nativePath + ".xml");
		var writer:FileStream = new FileStream();
		writer.open(file,FileMode.WRITE);
		writer.writeUTFBytes(doc);
		writer.close();
	});
	browser.browseForSave("保存路径");
}
private var itemTemplate:String = "<control id=\"{id}\" type=\"{type}\">";
private function exportControl(control:IUIControl):String
{
	var id:String = "";
	var type:String = "";
	var item:String = "";
	id = control.id;
	type = flash.utils.getQualifiedClassName(control);
	type = type.replace("::",".");
	item = itemTemplate.replace("{id}",id);
	item = item.replace("{type}",type);
	
	if((control is UIContainer))
	{
		var controls:Array = UIContainer(control).children;
		for each(var child:UIControl in controls)
		{
			item += exportControl(child);
		}
	}
	item += "</control>";
	return item;
}

protected function controlTreeClick(event:ListEvent):void
{
	if(event.itemRenderer && event.itemRenderer.data)
	{
		var id:String = event.itemRenderer.data.id;
		if(id)
		{
			this.EditWorkspace.focusControlById(id);
		}
	}
}

protected function closeWorkeidt(event:CloseEvent):void
{
	fileClose();
}