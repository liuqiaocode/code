package pixel.ui.control
{
	import flash.display.DisplayObject;
	
	import pixel.ui.core.PixelUINS;
	
	use namespace PixelUINS;

	/**
	 * 支持分页逻辑控制容器
	 * 
	 **/
	public class UIPaginationPanel extends UIContainer
	{
		
		//数据集合
		private var _items:Vector.<Object> = null;
		
		/**
		 * 翻页数据
		 * 
		 **/
		public function set items(value:Array):void
		{
			_items = Vector.<Object>(value);
			//_currentPage = 0;
			pageUpdate();
			
		}
		
		/**
		 * 翻页数据
		 * 
		 **/
		public function set itemVec(value:Vector.<Object>):void
		{
			_items = value;
			if(_items)
			{
				//_currentPage = 0;
				pageUpdate();
			}
		}
		
		/**
		 * 返回当前管理的数据总数
		 * 
		 **/
		public function get totalItemCount():int
		{
			if(_items)
			{
				return _items.length;
			}
			return 0;
		}
		
		//子项类型
		private var _itemClass:Class = null;
		
		private var _itemChilds:Vector.<IUIPaginationItem> = new Vector.<IUIPaginationItem>();
		
		//最大页数
		private var _maxPageCount:int = 0;
		
		/**
		 * 当前最大页数
		 * 
		 **/
		public function get maxPageCount():int
		{
			return _maxPageCount;
		}
		
		//每页数量
		private var _pageCount:int = 0;
		
		//当前页数
		private var _currentPage:int = 0;
		
		/**
		 * 当前页数
		 * 
		 **/
		public function get currentPage():int
		{
			return _currentPage + 1;
		}
		
		private var _currentPageItems:Array = [];
		
		public function UIPaginationPanel()
		{
			super();
			width = 100;
			height = 100;
		}
		
		/**
		 * 分页参数初始化
		 * 
		 **/
		public function pagination(itemClass:Class,pageCount:int):void
		{
			_itemClass = itemClass;
			_pageCount = pageCount;
			
			if(_itemClass)
			{
				var item:IUIPaginationItem = null;
				//预创建每页显示的显示子项进行缓存
				while(_itemChilds.length < _pageCount)
				{
					item = new _itemClass() as IUIPaginationItem;
					_itemChilds.push(new _itemClass());
				}
			}
		}
		
		
		private function pageUpdate():void
		{
			_maxPageCount = _items.length <= _pageCount ? 1:(_items.length / _pageCount) + (_items.length % _pageCount > 0 ? 1:0);
			if(_currentPage >= _maxPageCount)
			{
				_currentPage = _maxPageCount - 1;
			}
			itemUpdate();
		}
		
		private function itemUpdate():void
		{
			var idx:int = 0;
			//初始化当前页的数据
			_currentPageItems.length = 0;
			var start:int = _currentPage * _pageCount;
			for(idx = 0; idx<_pageCount; idx++)
			{
				if(start + idx < _items.length)
				{
					_currentPageItems.push(_items[start + idx]);
				}
				else
				{
					break;
				}
			}
			
			var item:IUIPaginationItem = null;
			if(_currentPageItems.length > _children.length)
			{
				while(_pageCount > _children.length)
				{
					item = _itemChilds.shift();
					item.init();
					this.addChild(item as DisplayObject);
				}
			}
			
			if(_currentPageItems.length < _children.length)
			{
				
				while(_currentPageItems.length < _children.length)
				{
					item = _children[0];
					item.dispose();
					_itemChilds.push(_children[0]);
					this.removeChild(_children[0]);
				}
			}
			
			if(_currentPageItems.length == _children.length)
			{
				for(idx = 0; idx<_children.length; idx++)
				{
					item = _children[idx] as IUIPaginationItem;
					if(item)
					{
						item.item = _currentPageItems[idx];
					}
				}
			}
		}
		
		/**
		 * 翻到下一页
		 * 
		 **/
		public function nextPage():void
		{
			_currentPage++;
			if(_currentPage >= _maxPageCount)
			{
				_currentPage = _maxPageCount - 1;
			}
			else
			{
				itemUpdate();
			}
		}
		
		/**
		 * 翻到上一页
		 * 
		 **/
		public function prevPage():void
		{
			_currentPage--;
			if(_currentPage < 0)
			{
				_currentPage = 0;
			}
			else
			{
				itemUpdate();
			}
		}
	}
}