package pixel.skeleton
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import pixel.skeleton.error.PixelSkeletonError;
	import pixel.skeleton.inf.INode;
	import pixel.skeleton.inf.IPixelAction;
	import pixel.skeleton.inf.IPixelActionFrameKey;
	import pixel.skeleton.inf.IPixelBone;
	import pixel.skeleton.inf.IPixelBoneSkin;
	import pixel.skeleton.inf.IPixelSkeleton;
	import pixel.utility.IUpdate;

	public class PixelSkeleton extends Node implements IPixelSkeleton
	{
		//包含骨骼
		private var _bones:Vector.<IPixelBone> = null;
		public function get bones():Vector.<IPixelBone>
		{
			return _bones;
		}
		private var _bonesDict:Dictionary = null;
		//动作
		private var _actions:Vector.<IPixelAction> = null;
		//皮肤
		private var _skins:Vector.<IPixelBoneSkin> = null;
		private var _skinDict:Dictionary = null;
		
		private var _action:IPixelAction = null;
		
		private var _view:Bitmap = null;
		
		private var _viewSource:BitmapData = null;
		
		private var _avatar:Sprite = null;
		public function PixelSkeleton()
		{
			_view = new Bitmap();
			_avatar = new Sprite();
		}
		
		public function addSkin(value:IPixelBoneSkin):void
		{
			if(!_skins)
			{
				_skins = new Vector.<IPixelBoneSkin>();
			}
			_skins.push(value);
		}
		
		public function addAction(value:IPixelAction):void
		{
			if(!_actions)
			{
				_actions = new Vector.<IPixelAction>();
			}
			_actions.push(value);
		}
		
		/**
		 * 切换到指定动作，并且定格在指定帧
		 * 
		 * @param		name		动作名称
		 * @param		frameIndex	指定帧下标
		 * 
		 **/
		public function changeAction(name:String,frameIndex:int = 0):void
		{
			_action = findActionByName(name);
			setActionFrameByIndex(frameIndex);
		}
		
		/**
		 * 播放动作，actionName如果为空则播放当前动作
		 * 
		 * @param		actionName		播放动作名称
		 * 
		 **/
		public function play(actionName:String = null):void
		{
			if(actionName)
			{
				_action = findActionByName(actionName);
			}
			if(!_action)
			{
				throw new PixelSkeletonError(PixelSkeletonError.ERROR_ACTIONNAME);
			}
			//获取第一个关键帧，将当前骨骼的属性初始化到第一帧状态
			setActionFrameByIndex(0);
			
			//获取动作所有关键帧数据
			_frames = _action.frames;
			//_playFrameCount = _frames.length;
			_currentFrameIndex = 0;
			_playFrameCount = 0;
			//将当前骨架注册到骨骼播放管理器
			PixelSkeletonPlayer.instance.register(this);
		}
		
		/**
		 * 将当前动作所关联的骨骼跳到某一帧
		 * 
		 **/
		protected function setActionFrameByIndex(index:int):void
		{
			if(_action)
			{
//				while(_avatar.numChildren > 0)
//				{
//					_avatar.removeChildAt(0);
//				}
				_frame = _action.findFrameByIndex(index);
				var args:Vector.<String> = _frame.frameArgs;
				var loop:int = args.length / 3;
				var offset:int = 0;
				var boneName:String = "";
				var paramName:String = "";
				var paramValue:String = "";
				for (var idx:int = 0; idx<loop; idx++)
				{
					boneName = args[offset];
					offset++;
					paramName = args[offset];
					offset++;
					paramValue = args[offset];
					var bone:IPixelBone = findBondByName(boneName);
					bone.view[paramName] = Number(paramValue);
					
					_avatar.addChild(bone.view);
				}
			}
		}
		
		/**
		 **/
		public function findActionByName(name:String):IPixelAction
		{
			for each(var act:IPixelAction in _actions)
			{
				return act;
			}
			return null;
		}
		
		/**
		 * 名称查找骨骼
		 **/
		public function findBondByName(name:String,reserve:Boolean = false):IPixelBone
		{
			if(!_bonesDict)
			{
				_bonesDict = new Dictionary();
			}
			if(name in _bonesDict)
			{
				return _bonesDict[name];
			}
			else
			{
				return findBoneFromArray(_bones,name,reserve);
			}
			return null;
		}
		
		protected function findBoneFromArray(bones:Vector.<IPixelBone>,name:String,reserve:Boolean = false):IPixelBone
		{
			var result:IPixelBone = null;
			for each(var bone:IPixelBone in bones)
			{
				if(bone.name == name)
				{
					_bonesDict[name] = bone;
					return bone as IPixelBone;
				}
				else
				{
					if(reserve && bone.children)
					{
						result = findBoneFromArray(bone.children,name,reserve);
						if(result)
						{
							return result;
						}
					}
				}
				
			}
			return null;
		}
		
		protected function findSkinByName(name:String):IPixelBoneSkin
		{
			if(!_skinDict)
			{
				_skinDict = new Dictionary();
			}
			
			if(name in _skinDict)
			{
				return _skinDict[name];
			}
			
			for each(var skin:IPixelBoneSkin in _skins)
			{
				if(skin.name == name)
				{
					_skinDict[name] = skin;
					return skin;
				}
			}
			return null;
		}
		
		private var _repeat:Boolean = false;
		private var _yoyo:Boolean = false;
		private var _frames:Vector.<IPixelActionFrameKey> = null;
		private var _playFrameCount:int = 0;
		private var _currentFrameIndex:int = 0;
		private var _frame:IPixelActionFrameKey = null;
		private var _frameClip:PixelActionFrameClip = null;
		private var _frameClipCache:Dictionary = new Dictionary();
		public function update():void
		{
			if(_action)
			{
				var args:Vector.<String> = _frame.frameArgs;
				var offset:int = 0;
				var boneName:String = "";
				var paramName:String = "";
				var paramValue:String = "";
				var bone:IPixelBone = null;
				var value:Number = 0;
				var skin:IPixelBoneSkin = null;
				var view:DisplayObject = null;
				if(_playFrameCount == _frame.frameIndex)
				{
					//当前播放帧已经到达当前关键帧末尾,进行下一关键帧的计算和播放
					_currentFrameIndex++;
					if(_currentFrameIndex == _frames.length)
					{
						//所有关键帧已播放完毕，结束动作播放
						PixelSkeletonPlayer.instance.remove(this);
						return;
					}
					else
					{
						_frame = _frames[_currentFrameIndex];
						if(_currentFrameIndex in _frameClipCache)
						{
							_frameClip = _frameClipCache[_currentFrameIndex];
						}
						else
						{
							_frameClip = new PixelActionFrameClip(_frame.frameIndex);
							
							//关键帧数据
							args = _frame.frameArgs;
							offset = 0;
							//当前关键帧减去当前已经播放到的关键帧=下一个关键帧播放的帧数
							var totalCount:int = _frame.frameIndex - _playFrameCount;
							var clipArgs:Vector.<String> = new Vector.<String>();
							while(offset < args.length)
							{
								boneName = args[offset];
								offset++;
								paramName = args[offset];
								offset++;
								paramValue = args[offset];
								offset++;
								value = Number(paramValue);
								bone = findBondByName(boneName);
								if(bone)
								{
									value = value - (Number(bone.view[paramName]));
									value = Number((value / totalCount).toFixed(2));
									clipArgs.push(boneName);
									clipArgs.push(paramName);
									clipArgs.push(String(value));
								}
							}
							_frameClip.params = clipArgs;
						}
					}
				}
				args = _frameClip.params;
				offset = 0;
				while(offset < args.length)
				{
					boneName = args[offset];
					offset++;
					paramName = args[offset];
					offset++;
					value = Number(args[offset]);
					offset++;
					
					bone = findBondByName(boneName);
					if(bone)
					{
						if(!bone.isBind())
						{
							skin = findSkinByName(bone.skin);
							bone.bind(skin);
						}
						
						view = bone.view;
						if(view && !_avatar.contains(view))
						{
							_avatar.addChild(view);
						}
						
						bone.view[paramName] += value;
					}
				}
				_playFrameCount++;
			}
		}
		
		/**
		 * 添加骨骼
		 * 
		 **/
		public function addBone(value:IPixelBone):void
		{
			if(!_bones)
			{
				_bones = new Vector.<IPixelBone>();
			}
			if(value.skin)
			{
				var skin:IPixelBoneSkin = this.findSkinByName(value.skin);
				if(skin)
				{
					value.bind(skin);
				}
			}
			_bones.push(value);
		}

		public function get skins():Vector.<IPixelBoneSkin>
		{
			return _skins;
		}
		public function get actions():Vector.<IPixelAction>
		{
			return _actions;
		}
		
		public function get view():DisplayObject
		{
			//return _view;
			return _avatar;
		}
		
		public function dispose():void
		{}
	}
}