--[[

pixel.framework.mvc

MVC模式初始化

]]
if not pixel or pixel.mvc then
	return 
end

pixel.mvc = {}

require "pixel.framework.mvc.MVCController"
require "pixel.framework.mvc.MVCView"
require "pixel.framework.mvc.MVCModel"