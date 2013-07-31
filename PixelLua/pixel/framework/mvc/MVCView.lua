--[[

	MVC数据层定义
]]

if not pixel or not pixel.mvc or pixel.mvc.model then
	return
end

require "pixel/framework/notification/init"

pixel.mvc.model = {}

function pixel.mvc.model:addViewListener(type,callback)
	pixel.notification:addNotifyListener(type,callback)
end

function pixel.mvc.model:removeViewListener(type,callback)
	pixel.notification:removeNotifyListener(type,callback)
end

function pixel.mvc.model:sendViewNotify(type,params)
	pixel.notification:sendNotify(type,params)
end