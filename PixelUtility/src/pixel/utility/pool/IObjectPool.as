package pixel.utility.pool
{
	/**
	 * 对象实例池管理接口
	 * 
	 * 
	 **/
	public interface IObjectPool
	{
		/**
		 * 注册对象池
		 * 
		 * @param	prototype	要池化对象的原型class
		 * @param	idleSize	闲置对象大小，超过闲置数量并且超过最小池化数量的对象将被释放
		 * @param	maxSize		对象池最大空间
		 **/
		function registerPool(prototype:Class,idleSize:int,maxSize:int = 0):void;
		
		/**
		 * 取消注册对象池
		 * 
		 * @param	prototype	对象原型class
		 **/
		function removePool(prototype:Class):void;
		
		/**
		 * 获取对象实例
		 * 
		 * @param	prototype	对象原型
		 **/
		function getInstance(prototype:Class):IPoolable;
		
		/**
		 * 
		 * 
		 **/
		function hasPool(prototype:Class):Boolean;
	}
}