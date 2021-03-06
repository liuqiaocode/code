package pixel.ui.control
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import pixel.ui.control.asset.Asset;
	import pixel.ui.control.asset.AssetImage;
	import pixel.ui.control.asset.IAsset;
	import pixel.ui.control.asset.IAssetImage;
	import pixel.ui.control.asset.PixelAssetManager;
	import pixel.ui.control.event.UIControlEvent;
	import pixel.ui.control.style.IStyle;
	import pixel.ui.control.style.IVisualStyle;
	import pixel.ui.control.style.StyleShape;
	import pixel.ui.control.style.UIStyle;
	import pixel.ui.control.style.UIStyleLinkEmu;
	import pixel.ui.control.style.UIStyleManager;
	import pixel.ui.control.utility.ScaleRect;
	import pixel.ui.control.utility.Utils;
	import pixel.ui.control.vo.UIStyleMod;
	import pixel.ui.core.PixelUINS;
	import pixel.utility.BitmapTools;
	import pixel.utility.ISerializable;
	import pixel.utility.Tools;
	
	use namespace PixelUINS;
	/**
	 * UI顶层类
	 **/
	public class UIControl extends Sprite implements IUIControl
	{
		protected var _Style:IVisualStyle = null;
		private var _StyleChanged:Boolean = false;
		private var _StyleClass:Class = null;
		private var _Scale9Grid:Scale9GridBitmap = null;
		protected var _EditMode:Boolean = false;	//编辑模式.编辑模式开启的情况下可以对控件进行样式的更改.如果控件处于容器内部可以进行拖拽操作
		//是否样式链接
		private var _styleLinked:Boolean = false;
		//链接样式
		private var _styleLinkId:String = "";
		
		public function UIControl(Skin:Class = null)
		{
			_StyleClass = Skin;
			if(Skin == null)
			{
				_Style = new UIStyle();
				_StyleClass = UIStyle;
			}
			else
			{
				_Style = new Skin() as IVisualStyle;
			}
			//RegisterEvent();
			Update();
			addEventListener(Event.ADDED_TO_STAGE,OnAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			//this.mouseEnabled = false;
			
			//initializer();
		}
		
		public function initializer():void
		{
			
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			stage.removeEventListener(Event.RENDER,StageRender);
		}
		
		protected var _owner:IUIContainer = null;
		public function get owner():IUIContainer
		{
			return _owner;
		}
		
		public function set owner(value:IUIContainer):void
		{
			_owner = value;
		}
		
		//protected var _Frame:FocusFrame = null;
		/**
		 * 开启控件的编辑模式
		 **/
		public function EnableEditMode():void
		{
			_EditMode = true;
		}
		public function DisableEditMode():void
		{
			_EditMode = false;
		}
		
		private var _ToolTip:String = "";
		public function set ToolTip(Value:String):void
		{
			_ToolTip = Value;
			if(null != _ToolTip && "" != _ToolTip)
			{
				UIToolTipManager.Instance.Bind(this);
			}
			else
			{
				UIToolTipManager.Instance.UnBind(this);	
			}
		}
		public function get ToolTip():String
		{
			return _ToolTip
		}
		
		/**
		 **/
		public function get StyleClass():Class
		{
			return _StyleClass;
		}
		
		/**
		 * 当控件进入显示队列时的初始化处理
		 **/
		protected function OnAdded(event:Event):void
		{
			//removeEventListener(Event.ADDED_TO_STAGE,OnAdded);
			if(stage)
			{
				if(!hasEventListener(Event.RENDER))
				{
					stage.addEventListener(Event.RENDER,StageRender);
				}
				
				if(_StyleChanged)
				{
					stage.invalidate();
				}
			}
		}
		
		/**
		 * 场景渲染处理
		 **/
		private function StageRender(event:Event):void
		{
			
			if(_StyleChanged)
			{
				_StyleChanged = false;
				//样式变更后调用Render进行处理
				Render();
			}
		}
		
		public function dispose():void
		{
			//RemoveEvent();
			removeEventListener(Event.ADDED_TO_STAGE,OnAdded);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			if(stage)
			{
				stage.removeEventListener(Event.RENDER,StageRender);
			}
//			if(_Style.BackgroundImage)
//			{
//				_Style.BackgroundImage.bitmapData.dispose();
//				_Style.BackgroundImage = null;
//			}
			_Style.dispose();
			_owner = null;
			_Style = null;
		}
		
		protected function StyleUpdate():void
		{
			dispatchEvent(new UIControlEvent(UIControlEvent.STYLE_UPDATE,true));
			Update();
		}
		
		/**
		 * 变更更新标识,同时发送更新事件.
		 **/
		public function Update():void
		{
			_StyleChanged = true;
			if(stage)
			{
				stage.invalidate();
			}
		}
		
		protected var _ActualWidth:int = 0;
		protected var _ActualHeight:int = 0;
		
		/**
		 * 
		 * 以中心为注册点进行缩放
		 **/
		public function CenterScale(Value:Number):void
		{
			scaleX = Value;
			scaleY = Value;
			var Mtx:Matrix = this.transform.matrix;
			//Mtx.translate(-(_Style.Width >> 1),-(_Style.Height >> 1));
			Mtx.translate(-(_ActualWidth >> 1),-(_ActualHeight >> 1));
		}
		
		/**
		 * 自定义渲染
		 **/
		public function Render():void
		{
			styleRender(_Style);
			dispatchEvent(new UIControlEvent(UIControlEvent.RENDER_UPDATE));
		}
		
		/**
		 * 按照给定的样式进行渲染
		 **/
		protected function styleRender(style:IVisualStyle):void
		{
			if(style)
			{
				var Pen:Graphics = graphics;
				Pen.clear();
				if(style.BorderThinkness > 0)
				{
					//设置边框线条样式
					Pen.lineStyle(style.BorderThinkness,style.BorderColor,style.BorderAlpha);
				}
				//设置了背景图片则进行图片填充,否则用背景颜色填充
				if(style.HaveImage)
				{
					if(style.BackgroundImage != null)
					{
						bitmapRender();
					}
					else
					{
						if(!style.ImagePack)
						{
							var asset:IAssetImage = PixelAssetManager.instance.FindAssetById(style.BackgroundImageId) as IAssetImage;
							if(asset)
							{
								//资源已经预载
								_Style.BackgroundImage = asset.image;
								bitmapRender();
							}
							else
							{
								//注册资源加载通知
								PixelAssetManager.instance.registerAssetHook(style.BackgroundImageId,this);
							}
						}
					}
				}
				else
				{
					graphics.beginFill(style.BackgroundColor,style.BackgroundAlpha);
				}
				
				switch(style.Shape)
				{
					case StyleShape.RECT:
						if(style.LeftBottomCorner > 0 || style.LeftTopCorner > 0 || style.RightTopCorner > 0 || style.RightBottomCorner > 0)
						{
							//graphics.drawRoundRectComplex(0,0,Style.Width,Style.Height,Style.LeftTopCorner,Style.RightTopCorner,Style.LeftBottomCorner,Style.RightBottomCorner);
							graphics.drawRoundRectComplex(0,0,_ActualWidth,_ActualHeight,style.LeftTopCorner,style.RightTopCorner,style.LeftBottomCorner,style.RightBottomCorner);
						}
						else
						{
							graphics.drawRect(0,0,_ActualWidth,_ActualHeight);
							//graphics.drawRect(0,0,Style.Width,Style.Height);
						}
						//矩形
						break;
					case StyleShape.CIRCLE:
						graphics.drawCircle(0,0,style.Radius);
						//圆形
						break;
					case StyleShape.ELLIPSE:
						//椭圆
						break;
					default:
				}
				graphics.endFill();
				//trace("Render end");
			}
		}
		
		protected function bitmapRender():void
		{
			var Pen:Graphics = graphics;
			if(!Style.Scale9Grid)
			{
				Pen.beginBitmapFill(Style.BackgroundImage,null,Boolean(Style.ImageFillType));
			}
			else
			{
				if(Style.Scale9GridLeft == 0 || Style.Scale9GridTop == 0 || Style.Scale9GridRight == 0 || Style.Scale9GridBottom == 0)
				{
					//任意参数为0时按默认方式渲染
					Pen.beginBitmapFill(Style.BackgroundImage,null,Boolean(Style.ImageFillType));
				}
				else
				{
					if(null == _Scale9Grid)
					{
						_Scale9Grid = new Scale9GridBitmap(Style.BackgroundImage);
						_Scale9Grid.Scale9Grid(Style.Scale9GridLeft,Style.Scale9GridTop,Style.Scale9GridRight,Style.Scale9GridBottom);
						_Scale9Grid.width = _ActualWidth;
						_Scale9Grid.height = _ActualHeight;
						
					}
					else
					{
						_Scale9Grid.UpdateScale(Style.Scale9GridLeft,Style.Scale9GridTop,Style.Scale9GridRight,Style.Scale9GridBottom);
					}
					
					var Vec:Vector.<ScaleRect> = _Scale9Grid.Rect;
					var Source:BitmapData = Style.BackgroundImage;
					var Rect:ScaleRect = null;
					//var Data:BitmapData = null;
					var Bit:Bitmap = null;
					var Pos:Point = new Point();
					var idx:int = 0;
					//Data = new BitmapData(width,height);
					var Mtx:Matrix = new Matrix();
					for each(Rect in Vec)
					{
						Mtx.a = Rect.FillWidth / Rect.width;
						Mtx.d = Rect.FillHeight / Rect.height;
						Mtx.tx = Rect.x - Rect.BitX * Mtx.a;
						Mtx.ty = Rect.y - Rect.BitY * Mtx.d;
						Pen.beginBitmapFill(Source,Mtx);
						Pen.drawRect(Rect.x,Rect.y,Rect.FillWidth,Rect.FillHeight);
						Pen.endFill();
						idx++;
						Rect.DrawMatrix.identity();
					}
				}
			}
		}
		//private var _Enable:Boolean = true;
		
		/**
		 * 控件版本
		 **/
		protected var _version:uint = 0;
		public function get version():uint
		{
			return _version;
		}
		public function set version(Value:uint):void
		{
			_version = Value;
		}
		
		public function encode():ByteArray
		{
			var Data:ByteArray = new ByteArray();
			var Prototype:uint = Utils.GetControlPrototype(this);
			//1	Short	控件类型
			Data.writeByte(Prototype);
			var id:String = this.id;
			
			if(id == null || id == "")
			{
				id = "C" + int(Math.random() * 1000);
			}
			
			id = Tools.ReplaceAll(id," ","");
			Data.writeByte(id.length);
			Data.writeUTFBytes(id);
			
			//1	Short	控件版本
			Data.writeShort(version);
			Data.writeShort(_ActualWidth);
			Data.writeShort(_ActualHeight);
			//1	Short	X
			Data.writeShort(x);	//外壳的X
			//1	Short	Y
			Data.writeShort(y);	//外壳的Y
			
			//2012-11-09新增 ToolTip数据支持
			if(null != _ToolTip && _ToolTip.length > 0)
			{
				Data.writeByte(1);
				var Len:int = Tools.StringActualLength(_ToolTip);
				Data.writeShort(Len);
				Data.writeUTFBytes(_ToolTip);
			}
			else
			{
				Data.writeByte(0);
			}
			
			if(null != _data && _data.length > 0)
			{
				Data.writeByte(1);
				Data.writeUTF(_data);
			}
			else
			{
				Data.writeByte(0);
			}
			
			Data.writeByte(int(_styleLinked));
			if(_styleLinked)
			{
				//链接作用域
				Data.writeByte(_linkStyleScope);
				//链接外部样式
				Data.writeByte(_styleLinkId.length);
				Data.writeUTFBytes(_styleLinkId);
			}
			else
			{
				var StyleData:ByteArray = Style.encode();
				Data.writeBytes(StyleData,0,StyleData.length);
			}
			
			SpecialEncode(Data);
			return Data;
		}
		
		public function isValidPixel():Boolean
		{
			if(_Style.BackgroundImage)
			{
				var pixel:uint = _Style.BackgroundImage.getPixel32(mouseX,mouseY);
				if(pixel > 0)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function decode(Data:ByteArray):void
		{
			var Len:int = Data.readByte();
			id = Data.readUTFBytes(Len);
			version = Data.readShort();
			_ActualWidth = Data.readShort();
			_ActualHeight = Data.readShort();
			x = Data.readShort();
			y = Data.readShort();
			
			//2012-11-09ToolTip数据处理
			if(Data.readByte() == 1)
			{
				Len = Data.readShort();
				ToolTip = Data.readUTFBytes(Len);
			}
			
			if(Data.readByte() == 1)
			{
				_data = Data.readUTF();
			}
			
			_styleLinked = Boolean(Data.readByte());
			if(_styleLinked)
			{
				_linkStyleScope = Data.readByte();
				Len = Data.readByte();
				_styleLinkId = Data.readUTFBytes(Len);
			}
			else
			{
				_Style.decode(Data);
			}
			SpecialDecode(Data);
			
			if(_styleLinked && _linkStyleScope == UIStyleLinkEmu.SCOPE_GLOBAL)
			{
				//全局样式链接
				var style:UIStyleMod = UIStyleManager.instance.findStyleById(_styleLinkId);
				if(style)
				{
					_linkStyle = style;
					Style = style.style;
					
				}
			}
			
			if(!Style.ImagePack)
			{
				var asset:AssetImage = PixelAssetManager.instance.FindAssetById(Style.BackgroundImageId) as AssetImage;
				if(asset)
				{
					_Style.BackgroundImage = asset.image;
				}
			}
		}
		
		protected function SpecialDecode(data:ByteArray):void
		{
			
		}
		protected function SpecialEncode(data:ByteArray):void
		{
			
		}
		
		/**
		 * 注册资源完成通知的回调函数
		 * 
		 * 
		 **/
		public function assetComplete(id:String,asset:IAsset):void
//		{}
//		public function AssetComleteNotify(id:String,Asset:Object):void
		{
			if(asset is IAssetImage)
			{
				this.BackgroundImage = IAssetImage(asset).image;
				PixelAssetManager.instance.removeAssetHook(BackgroundImageId,this);
			}
		}
		
		private var _id:String = "";
		public function get id():String
		{
			return _id;
		}
		public function set id(Value:String):void
		{
			_id = Value;
		}
		
		override public function set width(value:Number):void
		{
			//super.width = value;
			//_Style.Width = value;
			
			_ActualWidth = value;
			if(_Style.Scale9Grid && _Style.BackgroundImage)
			{
				if(!_Scale9Grid)
				{
					_Scale9Grid = new Scale9GridBitmap(_Style.BackgroundImage);
				}
				_Scale9Grid.width = _ActualWidth;
			}
			StyleUpdate();
		}
		
		protected function get ContentWidth():Number
		{
			return (width - _Style.BorderThinkness * 2);
//			return (width - _Style.BorderThinkness);
		}
		protected function get ContentHeight():Number
		{
			return (height - _Style.BorderThinkness * 2);
//			return (height - _Style.BorderThinkness);
		}
		
		public function get RealWidth():Number
		{
			return super.width;
		}
		public function get RealHeight():Number
		{
			return super.height;
		}
		
		override public function get width():Number
		{
			//return _Style.Width;
			return _ActualWidth;
		}
		override public function set height(value:Number):void
		{
			//super.height = value;
			//_Style.Height = value;
			_ActualHeight = value;
			if(_Style.Scale9Grid && _Style.BackgroundImage)
			{
				if(!_Scale9Grid)
				{
					_Scale9Grid = new Scale9GridBitmap(_Style.BackgroundImage);
				}
				_Scale9Grid.height = _ActualHeight;
			}
			StyleUpdate();
		}
		override public function get height():Number
		{
			//return _Style.Height;
			return _ActualHeight;
		}
		
		private var _enabled:Boolean = true;		
		/**
		 * 
		 * 当前控件是否可用
		 **/
		public function enabled(value:Boolean,gloom:Boolean = false):void
		{
			if(value != _enabled)
			{
				this.mouseEnabled = this.mouseChildren = _enabled = value;
				if(!_enabled)
				{
					//this.mouseChildren = false;
					//this.mouseEnabled = false;
					if(gloom)
					{
						BitmapTools.setGloom(this);
					}
				}
				else
				{
					this.filters = [];
				}
			}
		}
		public function get isEnabled():Boolean
		{
			return _enabled;
		}
		
		private var _linkStyle:UIStyleMod = null;
		private var _linkStyleScope:int = UIStyleLinkEmu.SCOPE_INLINE;
		
		/**
		 * 链接外部样式
		 * 
		 **/
		public function setLinkStyle(value:UIStyleMod,scope:int):void
		{
			if(value)
			{
				_linkStyle = value;
				_styleLinked = true;
				_styleLinkId = value.id;
				Style = value.style;
				_linkStyleScope = scope;
				StyleUpdate();
			}
		}
		
		public function get linkStyle():UIStyleMod
		{
			return _linkStyle;
		}
		
		/**
		 * 局部权限函数，检查是否样式链接
		 * 
		 **/
		public function get styleLinked():Boolean
		{
			return _styleLinked;
		}
		
		/**
		 * 链接样式ID
		 * 
		 **/
		public function get styleLinkId():String
		{
			return _styleLinkId;
		}
		
		/**
		 * 
		 * 链接样式作用域
		 **/
		public function get styleLinkScope():int
		{
			return _linkStyleScope;
		}
		
		/************************样式变更函数定义区************************/
		public function get Style():IVisualStyle
		{
			return _Style;
		}
		public function set Style(value:IVisualStyle):void
		{
			_Style = value;
			if(!_Style.ImagePack)
			{
				var Img:BitmapData = IAssetImage(PixelAssetManager.instance.FindAssetById(Style.BackgroundImageId)).image;
				if(Img)
				{
					this.BackgroundImage = Img;
				}
			}
			if(_Style.Scale9Grid)
			{
				if(null == _Scale9Grid)
				{
					_Scale9Grid = new Scale9GridBitmap(_Style.BackgroundImage);
					_Scale9Grid.Scale9Grid(_Style.Scale9GridLeft,_Style.Scale9GridTop,_Style.Scale9GridRight,_Style.Scale9GridBottom);
					_Scale9Grid.width = _ActualWidth;
					_Scale9Grid.height = _ActualHeight;
					
				}
			}
			
			StyleUpdate();
		}
		
		public function set BorderColor(Value:uint):void
		{
			_Style.BorderColor = Value;
			StyleUpdate();
		}
		public function get BorderColor():uint
		{
			return _Style.BorderColor;
		}
		public function set BorderThinkness(Value:int):void
		{
			_Style.BorderThinkness = Value;
			StyleUpdate();
		}
		public function get BorderThinkness():int
		{
			return _Style.BorderThinkness;
		}
		public function set BorderAlpha(Value:Number):void
		{
			_Style.BorderAlpha = Value;
			StyleUpdate();
		}
		public function get BorderAlpha():Number
		{
			return _Style.BorderAlpha;
		}
//		public function set BorderCorner(Value:int):void
//		{
//			_Style.BorderCorner = Value;
//			StyleUpdate();
//		}
		public function set Radius(Value:int):void
		{
			_Style.Radius = Value;
			StyleUpdate();
		}
		public function set BackgroundColor(Value:uint):void
		{
			_Style.BackgroundColor = Value;
			StyleUpdate();
		}
		public function get BackgroundColor():uint
		{
			return _Style.BackgroundColor;
		}
		public function set BackgroundAlpha(Value:Number):void
		{
			_Style.BackgroundAlpha = Value;
			StyleUpdate();
		}
		public function get BackgroundAlpha():Number
		{
			return _Style.BackgroundAlpha;
		}
		public function set BackgroundImage(image:BitmapData):void
		{
			if(image)
			{
				_Style.BackgroundImage = image;
				width = image.width;
				height = image.height;
				StyleUpdate();
			}
		}
		public function get backgroundImage():BitmapData
		{
			return _Style.BackgroundImage;
		}
		
		public function set BackgroundImageId(Value:String):void
		{
			_Style.BackgroundImageId = Value;
			StyleUpdate();
		}
		public function get BackgroundImageId():String
		{
			return _Style.BackgroundImageId;
		}
		public function set BackgroundImageFill(Value:int):void
		{
			_Style.ImageFillType = Value;
			StyleUpdate();
		}
		public function get BackgroundImageFill():int
		{
			return _Style.ImageFillType;
		}
		public function set Scale9Grid(Value:Boolean):void
		{
			_Style.Scale9Grid = Value;
			StyleUpdate();
		}
		public function set Scale9GridLeft(Value:int):void
		{
			_Style.Scale9GridLeft = Value;
			StyleUpdate();
		}
		public function get Scale9GridLeft():int
		{
			return _Style.Scale9GridLeft;
		}
		public function set Scale9GridTop(Value:int):void
		{
			_Style.Scale9GridTop = Value;
			StyleUpdate();
		}
		public function get Scale9GridTop():int
		{
			return _Style.Scale9GridTop;
		}
		public function set Scale9GridRight(Value:int):void
		{
			_Style.Scale9GridRight = Value;
			StyleUpdate();
		}
		public function get Scale9GridRight():int
		{
			return _Style.Scale9GridRight;
		}
		public function set Scale9GridBottom(Value:int):void
		{
			_Style.Scale9GridBottom = Value;
			StyleUpdate();
		}
		public function get Scale9GridBottom():int
		{
			return _Style.Scale9GridBottom;
		}
		
		public function set Scale9GridAll(value:int):void
		{
			_Style.Scale9GridBottom = _Style.Scale9GridLeft = _Style.Scale9GridRight = _Style.Scale9GridTop = value;
		}
		public function set LeftTopCorner(Value:int):void
		{
			_Style.LeftTopCorner = Value;
			StyleUpdate();
		}
		public function set LeftBottomCorner(Value:int):void
		{
			_Style.LeftBottomCorner = Value;
			StyleUpdate();
		}
		public function set RightTopCorner(Value:int):void
		{
			_Style.RightTopCorner = Value;
			StyleUpdate();
		}
		public function set RightBottomCorner(Value:int):void
		{
			_Style.RightBottomCorner = Value;
			StyleUpdate();
		}
		
		public function set ImagePack(Value:Boolean):void
		{
			_Style.ImagePack = Value;
		}
		public function get ImagePack():Boolean
		{
			return _Style.ImagePack;
		}
		
		protected var _data:String = "";
		public function set data(value:String):void
		{
			_data = value;
		}
		public function get data():String
		{
			return _data;

		}
		
		public function update():void
		{}
		
		private var _prototype:Class = null;
		private var _prototypeSource:ByteArray = null;
		/**
		 * 克隆当前组件
		 * 
		 **/
		public function clone():IUIControl
		{
			if(!_prototype || !_prototypeSource)
			{
				_prototype = Utils.GetPrototype(this);
				_prototypeSource = this.encode();
			}
			
			//跳过类型
			_prototypeSource.position = 1;
			var clone:IUIControl = new _prototype() as IUIControl;
			clone.decode(_prototypeSource);
			return clone;
		}
	}
}