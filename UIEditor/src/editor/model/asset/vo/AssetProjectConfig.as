package editor.model.asset.vo
{
	public class AssetProjectConfig
	{
		private var _projects:Array = [];
		public function addProject(value:String):void
		{
			_projects.push(value);	
		}
		
		public function get projects():Array
		{
			return _projects;
		}
		
		public function AssetProjectConfig()
		{
		}
		
		public function decodeByJson(value:String):void
		{
			var obj:Object = JSON.parse(value);
			if(obj.projects)
			{
				for each(var v:String in obj.projects)
				{
					_projects.push(v);
				}
			}
		}
		
		public function toJson():String
		{
			return JSON.stringify(this);
		}
	}
}