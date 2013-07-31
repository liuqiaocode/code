package pixel.ui.control
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import pixel.ui.control.layout.GridLayout;
	import pixel.ui.control.layout.HorizontalLayout;
	import pixel.ui.control.layout.IContainerLayout;
	import pixel.ui.control.layout.VerticalLayout;
	import pixel.ui.control.style.UIContainerStyle;
	import pixel.ui.control.utility.Utils;
	import pixel.ui.core.PixelUINS;
	
//	import pixel.utility.Tools;
	
	use namespace PixelUINS;
	/**
	 * 基础容器类,不提供视觉渲染
	 * 
	 * 定义子组件布局
	 * 定义子组件管理
	 * 响应子组件的更新
	 * 
	 **/
	public class UIContainer extends UIControl implements IUIContainer
	{
		//protected var _Padding:int = 0
		
		//布局样式,默认为绝对布局
		//private var _Layout:uint = LayoutConstant.ABSOLUTE;
		//子对象队列
		protected var _children:Array = [];
		public function get children():Array
		{
			return _children;
		}
		protected var _layoutManager:IContainerLayout = null;
		public function UIContainer(Skin:Class = null)
		{
			var SkinStyle:Class = Skin ? Skin: UIContainerStyle;
			super(SkinStyle);
			_content = new Sprite();
			
			super.addChild(_content);
			//_content.x = _content.y = _Style.BorderThinkness;
			_content.x = _content.y = 0;
		}
		
		override public function EnableEditMode():void
		{
			super.EnableEditMode();
			
			for each(var Child:IUIControl in _children)
			{
				Child.EnableEditMode();
			}
		}
		
		/**
		 * 获取子控件间隔
		 * 
		 **/
		public function get Gap():int
		{
			return UIContainerStyle(Style).Gap;
		}
		
		/**
		 * 设置子控件间隔
		 * 
		 **/
		public function set Gap(Value:int):void
		{
			UIContainerStyle(Style).Gap = Value;
			UpdateLayout();
		}
		
		/**
		 * 子组件容器与容器的padding
		 * 
		 **/
		public function set padding(value:int):void
		{
			UIContainerStyle(_Style).padding = value;
			//_Padding = Value;
			//_content.x = _content.y = value + _Style.BorderThinkness;
			_content.x = _content.y = value;
			this.UpdateLayout();
		}
		public function get padding():int
		{
			return UIContainerStyle(_Style).padding;
		}
		
		override public function set BorderThinkness(Value:int):void
		{
			super.BorderThinkness = Value;
			_content.x = _content.y = UIContainerStyle(_Style).padding + Value;
		}
		
		public function get contentWidth():int
		{
			return width - (UIContainerStyle(_Style).padding * 2);
		}
		public function get contentHeight():int
		{
			return height - (UIContainerStyle(_Style).padding * 2);
		}
		
		/**
		 * 变更当前布局
		 **/
		public function set Layout(Value:uint):void
		{
			//判断是否与当前布局不一致
			if(UIContainerStyle(Style).Layout != Value)
			{
				UIContainerStyle(Style).Layout = Value;
				UpdateLayout();
			}
		}
		
		public function get Layout():uint
		{
			return UIContainerStyle(Style).Layout;
		}
		
		public function IsChildren(Obj:Object):Boolean
		{
			if(_children.indexOf(Obj) < 0)
			{
				return false;
			}
			return true;
		}
		
		public function get ChildrenIds():Vector.<String>
		{
			var Vec:Vector.<String> = new Vector.<String>();
			var Child:IUIControl = null;
			for each(Child in _children)
			{
				Vec.push(Child.id);
			}
			return Vec;
		}
		
		/**
		 * 复写Sprite addChild函数.将添加的Child作为子组件保存并且进行布局调整
		 **/
		override public function addChild(Child:DisplayObject):DisplayObject
		{
			Append(Child);
			//return super.addChild(Child);
			return _content.addChild(Child);
		}
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			Remove(child);
			//return super.removeChild(child);
			_content.removeChild(child);
			UpdateLayout();
			return child;
		}
		
		PixelUINS function OrignalAddChild(Child:DisplayObject):DisplayObject
		{
			//_children.push(Child);
			return super.addChild(Child);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			if(_content.contains(child))
			{
				return _content.getChildIndex(child);
			}
			return -1;
		}
		
		/**
		 * 复写Sprite addChildAt函数.将添加的Child作为子组件保存并且进行布局调整
		 **/
		override public function addChildAt(Child:DisplayObject, Index:int):DisplayObject
		{
			Append(Child);
			//return super.addChildAt(Child,Index);
			if(Child is IUIControl)
			{
				IUIControl(Child).owner = this;
			}
			return _content.addChildAt(Child,Index);
		}
		
		public function removeAllChildren():void
		{
			for each(var child:DisplayObject in _children)
			{
				if(_content.contains(child))
				{
					_content.removeChild(child);
				}
			}
			
			_children = [];
		}
		
		/**
		 * 更新布局,对所以子对象重新进行排序
		 **/
		protected function UpdateLayout():void
		{
//			var Idx:int = 0;
//			var Len:int = _children ? _children.length:0;
//			var Seek:int = 0;
//			var conWidth:int = contentWidth;
//			var conHeight:int = contentHeight;
			if(_layoutManager)
			{
				_layoutManager.dispose();
				_layoutManager = null;
			}
			switch(Layout)
			{
				case UILayoutConstant.HORIZONTAL:
					_layoutManager = new HorizontalLayout(this);
					break;
				case UILayoutConstant.VERTICAL:
					_layoutManager = new VerticalLayout(this);
					break;
				case UILayoutConstant.GRID:
					_layoutManager = new GridLayout(this);
					break;
				default:
					_layoutManager = null;
					break;
			}
			if(_layoutManager)
			{
				_layoutManager.gap = this.Gap;
				_layoutManager.layoutUpdate();
			}
		}
		
		
//		public function get Content():Sprite
//		{
//			return _content;
//		}
//		
//		public function get Children():Array
//		{
//			return _children;
//		}
		
		private function Remove(Child:DisplayObject):void
		{
			if(_children.indexOf(Child) >= 0)
			{
				_children.splice(_children.indexOf(Child),1);
				
			}
		}
		
		private var _content:DisplayObjectContainer = null;
		/**
		 * 返回当前子对象容器
		 * 
		 **/
		public function get childContent():DisplayObjectContainer
		{
			return _content;
		}
	
		
		/**
		 * 将子组件添加至管理队列.同时根据当前的布局状态进行布局调整
		 **/
		private function Append(Child:DisplayObject):void
		{
			if(!_children)
			{
				_children = [];
			}
			var pad:int = padding;
			var Last:DisplayObject = _children.length > 0 ? _children[_children.length - 1]:null;
			switch(UIContainerStyle(Style).Layout)
			{
				case UILayoutConstant.HORIZONTAL:
					if(Last)
					{
						Child.x = Last.x + Last.width + Gap + pad;
						Child.y = Last.y;
					}
					else
					{
						Child.x = 0;
						Child.y = 0;
					}
					break;
				case UILayoutConstant.VERTICAL:
					if(Last)
					{
						Child.x = Last.x;
						Child.y = Last.y + Last.height + Gap;
					}
					else
					{
						Child.x = 0;
						Child.y = 0;
					}
					break;
				case UILayoutConstant.GRID:
					if(Last)
					{
						if((Last.x + Last.width + Child.width + Gap) >= width)
						{
							Child.x = 0;
							Child.y = Last.y + Last.height + Gap;
						}
						else
						{
							Child.x = (Last.x + Last.width + Gap);
							Child.y = Last.y;
						}
						
//						if(Child.y + Child.height > height)
//						{
//							return;
//						}
					}
					else
					{
						Child.x = 0;
						Child.y = 0;
					}
					break;
				default:
					break;
			}
			_children.push(Child);
			if(Child is IUIControl)
			{
				IUIControl(Child).owner = this;
			}
		}
		
		public function findChildById(id:String,DeepSearch:Boolean = false):IUIControl
		{
			var item:DisplayObject = null;
			var childs:Array = DeepSearch ? totalChildren : _children;
			for each(item in childs)
			{
				if(item is IUIControl && IUIControl(item).id == id)
				{
					return item as IUIControl;
				}
			}
			return null;
		}
		
		public function findChildsByClass(prototype:Class,deepSearch:Boolean = false):Array
		{
			var items:Array = [];
			var item:IUIControl = null;
			var childs:Array = deepSearch ? totalChildren : _children;
			for each(item in childs)
			{
				if(item is prototype)
				{
					items.push(item);
				}
			}
			return items;
		}
		
		override public function dispose():void
		{
			super.dispose();
			var child:IUIControl = null;
			for each(child in _children)
			{
				_content.removeChild(child as DisplayObject);
				child.dispose();
				child = null;
			}
		}
		
		/**
		 * 增加一个子对象的层级
		 * 
		 **/
		public function childIndexAdd(child:DisplayObject):void
		{
			if(_content.contains(child))
			{
				var idx:int = _content.getChildIndex(child);
				if(idx + 1 < _content.numChildren)
				{
					idx++;
					_content.setChildIndex(child,idx);
					refreshIndex();
				}
			}
		}
		
		/**
		 * 减少一个子对象的层级
		 * 
		 **/
		public function childIndexSub(child:DisplayObject):void
		{
			if(_content.contains(child))
			{
				var idx:int = _content.getChildIndex(child);
				if(idx - 1 >= 0)
				{
					idx--;
					_content.setChildIndex(child,idx);
					refreshIndex();
				}
			}
		}
		
		/**
		 * 获取真实高度
		 * 
		 * 在有子对象的情况下计算所有子项的高度合+Gap
		 * 
		 **/
		override public function get RealHeight():Number
		{
			if(_children && _children.length > 0)
			{
				var child:IUIControl = null;
				var size:int = 0;
				for each(child in  _children)
				{
					size += child.height;
				}
				size += (_children.length) * Gap + _content.y;
				return size;
			}
			else
			{
				return super.height;
			}
		}
		
		override public function get RealWidth():Number
		{
			if(_children && _children.length > 0)
			{
				var child:IUIControl = null;
				var size:int = 0;
				for each(child in  _children)
				{
					size += child.width;
				}
				size += (_children.length) * Gap + _content.x;
				return size;
			}
			else
			{
				return super.RealWidth;
			}
		}
		
		public function OnDrop(Control:IUIControl):void
		{
			addChild(Control as DisplayObject);
		}
		
		
		/**
		 * 获取全部子控件,全部层级
		 * 
		 * 
		 **/
		public function get totalChildren():Array
		{
			var childrens:Array = [];
			var Child:DisplayObject = null;
			for each(Child in _children)
			{
				childrens.push(Child);
				if(Child is IUIContainer)
				{
					childrens = childrens.concat(UIContainer(Child).totalChildren);
				}
			}
			return childrens;
		}

		
		override protected function SpecialEncode(Data:ByteArray):void
		{
			var ChildLen:int = _children.length;
			
			Data.writeByte(ChildLen);
			var Child:IUIControl = null;
			var ChildData:ByteArray = null;
			for(var Idx:int=0; Idx<ChildLen; Idx++)
			{
				Child = _children[Idx];
				//Data.writeByte(Utils.GetControlPrototype(Child));
				ChildData = Child.encode();
				Data.writeBytes(ChildData,0,ChildData.length);
			}
		}
		
		override protected function SpecialDecode(Data:ByteArray):void
		{
			var ChildLen:int = Data.readByte();
			var Child:IUIControl = null;
			var ChildData:ByteArray = null;
			var Prototype:Class = null;
			var Type:uint = 0;
			for(var Idx:int=0; Idx<ChildLen; Idx++)
			{
				if(Data.bytesAvailable > 0)
				{
					Type = Data.readByte();
					Prototype = Utils.GetPrototypeByType(Type);
					Child = new Prototype() as IUIControl;
					Child.decode(Data);
					addChild(Child as DisplayObject);
				}
				
			}
			
			padding = padding;
			this.UpdateLayout();
		}
		
		override public function set ImagePack(Value:Boolean):void
		{
			super.ImagePack = Value;
			var Child:UIControl = null;
			
			for each(Child in _children)
			{
				Child.ImagePack = Value;
			}
		}
		
		/**
		 * 更新索引
		 * 
		 **/
		protected function refreshIndex():void
		{
			var childs:Array = [];
			var idx:int = 0;
			var child:IUIControl = null;
			while(idx < _content.numChildren)
			{
				child = _content.getChildAt(idx) as IUIControl;
				if(child)
				{
					childs.push(child);
				}
				idx++;
			}
			_children = childs;
		}
	}
}