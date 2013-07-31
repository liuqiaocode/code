
require "pixel/framework/init"

function print(msg)
	CCLuaLog(msg)
end

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

function onNotify(t,params)
	if t == pixel.notification.notifyType.controller.C_SCENE_CHANGE then

		local scene = require(params).new()
		if scene then
			print(type(scene))
			if CCDirector:sharedDirector():getRunningScene() then

				CCDirector:sharedDirector():replaceScene(scene)
			else
				CCDirector:sharedDirector():runWithScene(scene)
			end
		end
		--package.loaded[params] = nil
	end
end

function main()
	pixel.notification:addNotifyListener(pixel.notification.notifyType.controller.C_SCENE_CHANGE,onNotify)
	pixel.notification:sendNotify(pixel.notification.notifyType.controller.C_SCENE_CHANGE,"scene1")
	
end

xpcall(main, __G__TRACKBACK__)