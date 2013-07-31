import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

private var _boneCtxMenu:ContextMenu = null;
private var _skinCtxMenu:ContextMenu = null;
private var _actionCtxMenu:ContextMenu = null;

public static const NEW_BONE:int = 1;
public static const DEL_BONE:int = 2;
public static const NEW_SKIN:int = 3;
public static const MOD_SKIN:int = 4;
public static const DEL_SKIN:int = 5;
public static const NEW_ACTION:int = 6;
public static const DEL_ACTION:int = 7;

private static var BONE_MENU:Array = [
	{
		label : "添加骨骼",
		id : NEW_BONE
	},
	{
		label : "删除骨骼",
		id : DEL_BONE
	}
];

private static var SKIN_MENU:Array = [
	{
		label : "添加皮肤",
		id : NEW_SKIN
	},
	{
		label : "修改",
		id : MOD_SKIN
	},
	{
		label : "删除",
		id : DEL_SKIN
	}
];


private static var ACTION_MENU:Array = [
	{
		label : "新增动作",
		id : NEW_ACTION
	},
	{
		label : "删除动作",
		id : DEL_ACTION
	}
];


[Bindable]
private var menuData:Array = [
	{
		label: "组件",
		children: [
			{
				id: MENU_SKELETON_NEW,
				label: "新建"
			},
			{
				label: "打开"
			},
			{
				label : "导出描述文件",
				enabled : false
			},
			{
				label: "保存",
				enabled: false
			},
			{
				label: "另存为",
				enabled: false
			}
		]
	}
];

private function initiContextMenu():void
{
	_boneCtxMenu = buildContextMenu(BONE_MENU);
	_skinCtxMenu = buildContextMenu(SKIN_MENU);
	_actionCtxMenu = buildContextMenu(ACTION_MENU);
}

private function buildContextMenu(source:Array):ContextMenu
{
	var menu:ContextMenu = new ContextMenu();
	for each(var obj:Object in source)
	{
		var item:ContextMenuItem = new ContextMenuItem(obj.label);
		item.data = obj.id;
		menu.addItem(item);
	}
	return menu;
}