package  pixel.utility.pool
{
	public class ObjectPool
	{
		private static var _instance:IObjectPool = null;
		public function ObjectPool()
		{
		}
		
		public static function get instance():IObjectPool
		{
			if(!_instance)
			{
				_instance = new ObjectPoolImpl();
			}
			return _instance;
		}
	}
}
import pixel.utility.pool.IObjectPool;
import pixel.utility.pool.IPoolable;

import flash.utils.Dictionary;

class ObjectPoolImpl implements IObjectPool
{
	private var _poolCache:Dictionary = null;
	private var _poolQueue:Pool = null;
	
	public function ObjectPoolImpl()
	{
		_poolCache = new Dictionary();
	}
	
	/**
	 * 注册对象池
	 * 
	 * @param	prototype	要池化对象的原型class
	 * @param	idleSize	闲置对象大小，超过闲置数量并且超过最小池化数量的对象将被释放
	 * @param	maxSize		对象池最大空间
	 **/
	public function registerPool(prototype:Class,idleSize:int,maxSize:int = 0):void
	{
		if(!(prototype in _poolCache))
		{
			_poolCache[prototype] = new Pool(prototype,idleSize,maxSize);
		}
	}
	
	/**
	 * 取消注册对象池
	 * 
	 * @param	prototype	对象原型class
	 **/
	public function removePool(prototype:Class):void
	{
		if(hasPool(prototype))
		{
			delete _poolCache[prototype];
		}
	}
	
	/**
	 * 获取对象实例
	 * 
	 * @param	prototype	对象原型
	 **/
	public function getInstance(prototype:Class):IPoolable
	{
		if(hasPool(prototype))
		{
			return Pool(_poolCache[prototype]).getInstance() as IPoolable;
		}
		return null;
	}
	
	public function hasPool(prototype:Class):Boolean
	{
		return (prototype in _poolCache);
	}
}

class Pool
{
	private var _idleQueue:Vector.<Object> = null;
	private var _activeQueue:Vector.<Object> = null;
	private var _totalQueue:Vector.<Object> = null;
	
	private var _idleSize:int = 0;
	public function get idleSize():int
	{
		return _idleSize;
	}
	private var _maxSize:int = 0;
	public function get maxSize():int
	{
		return _maxSize;
	}
	
	public function get totalCount():int
	{
		return _totalQueue.length;
	}
	private var _prototype:Class = null;
	public function get prototype():Class
	{
		return _prototype;
	}
	
	public function Pool(proto:Class,idleSize:int,maxSize:int = 0)
	{
		_totalQueue = new Vector.<Object>();
		_activeQueue = new Vector.<Object>();
		_idleQueue = new Vector.<Object>();
		_prototype = proto;
		_idleSize = idleSize;
		_maxSize = maxSize;
	}
	
	/**
	 * 获取一个对象实例
	 * 
	 **/
	public function getInstance():Object
	{
		var value:Object = null;
		if(_idleQueue.length > 0)
		{
			//空闲等待队列返回
			value = _idleQueue.shift();
			_activeQueue.push(value);
			updatePool();
			return value;
		}
		
		if(maxSize > 0 && _totalQueue.length + 1 >= maxSize)
		{
			return null;
		}
		value = new _prototype() as Object;
		_activeQueue.push(value);
		_totalQueue.push(value);
		return value;
	}
	
	/**
	 * 对象回收
	 * 
	 * @param	instance	要回收的对象
	 **/
	public function recycleInstance(instance:Object):void
	{
		var idx:int = _activeQueue.indexOf(instance);
		var value:Object = null;
		if(idx >= 0)
		{
			value = _activeQueue[idx];
			value = _activeQueue.splice(idx,1);
			if(_idleQueue.length + 1 < _idleSize)
			{
				//等待池有空余空间
				_idleQueue.push(value);
			}
		}
	}
	
	/**
	 * 更新对象池
	 * 
	 **/
	private function updatePool():void
	{
		
	}
}