--[[

	MVC视图定义
]]

if not pixel or not pixel.mvc or pixel.mvc.view then
	return
end

require "pixel/framework/notification/init"

pixel.mvc.view = {}

function pixel.mvc.view:addViewListener(type,callback)
	pixel.notification:addNotifyListener(type,callback)
end

function pixel.mvc.view:removeViewListener(type,callback)
	pixel.notification:removeNotifyListener(type,callback)
end

function pixel.mvc.view:sendViewNotify(type,params)
	pixel.notification:sendNotify(type,params)
end