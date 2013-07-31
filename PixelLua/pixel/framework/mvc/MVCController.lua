--[[
	
	MVC逻辑控制定义
]]

if not pixel or not pixel.mvc or pixel.mvc.controller then
	return
end

require "pixel/framework/notification/init"

pixel.mvc.controller = {}

function pixel.mvc.controller:addControlListener(type,callback)
	pixel.notification:addNotifyListener(type,callback)
end

function pixel.mvc.controller:removeControlListener(type,callback)
	pixel.notification:removeNotifyListener(type,callback)
end

function pixel.mvc.controller:sendControlNotify(type,params)
	pixel.notification:sendNotify(type,params)
end