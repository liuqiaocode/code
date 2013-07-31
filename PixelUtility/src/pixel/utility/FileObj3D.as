package pixel.utility
{
	public class FileObj3D
	{
		//顶点
		private var _vertex:Vector.<Number> = null;
		public function get vertex():Vector.<Number>
		{
			return _vertex;
		}
		//UV
		private var _vertexUV:Vector.<Number> = null;
		public function get vertexUV():Vector.<Number>
		{
			return _vertexUV;
		}
		
		private var _uvIndex:Vector.<uint> = null;
		public function get uvIndex():Vector.<uint>
		{
			return _uvIndex;
		}
		//法线
		private var _normals:Vector.<Number> = null;
		//顶点索引
		//private var _vertexIndex:Vector.<FileObj3DVertexIndex> = null;
		private var _vertexIndex:Vector.<uint> = null;
		public function get vertexIndex():Vector.<uint>
		{
			return _vertexIndex;
		}
		
		private var _faceVertex:Vector.<Number> = null;
		public function get faceVertex():Vector.<Number>
		{
			if(!_faceVertex)
			{
				_faceVertex = new Vector.<Number>();
				var index:int = 0;
				for(var idx:int = 0; idx<_vertexIndex.length; idx++)
				{
					index = (_vertexIndex[idx] - 1) * 3;
					_faceVertex.push(_vertex[index]);
					_faceVertex.push(_vertex[index + 1]);
					_faceVertex.push(_vertex[index + 2]);
				}
			}
			return _faceVertex;
		}
		
		private var _vertexIndexGroup:Vector.<FileObj3DVertexIndexGroup> = null;
		public function FileObj3D()
		{
			_vertex = new Vector.<Number>();
			_vertexUV = new Vector.<Number>();
			_normals = new Vector.<Number>();
			_vertexIndex = new Vector.<uint>();
			_uvIndex = new Vector.<uint>();
			_vertexIndexGroup = new Vector.<FileObj3DVertexIndexGroup>();
		}
		
		private var _uv:Vector.<Number> = null;
		public function get uv():Vector.<Number>
		{
			if(!_uv)
			{
				_uv = new Vector.<Number>();
				var index:int = 0;
				for (var idx:int = 0; idx<_uvIndex.length; idx++)
				{
					index = (_uvIndex[idx] - 1) * 2;
					_uv.push(_vertexUV[index]);
					_uv.push(_vertexUV[index + 1]);
				}
			}
			return _uv;
		}
		
		public function addVertex(pos:Number):void
		{
			_vertex.push(pos);
		}
		
		public function addNormals(pos:Number):void
		{
			_normals.push(pos);
		}
		public function addVertexUV(pos:Number):void
		{
			_vertexUV.push(pos);
		}
		public function addUVIndex(value:uint):void
		{
			_uvIndex.push(value);
		}
		public function addVertexIndex(idx:uint):void
		{
			_vertexIndex.push(idx);
		}
		public function addVertexIndexGroup(group:FileObj3DVertexIndexGroup):void
		{
			_vertexIndexGroup.push(group);
		}
	}
}