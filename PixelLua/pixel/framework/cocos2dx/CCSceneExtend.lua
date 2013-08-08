
CCSceneExtend = {
}
CCSceneExtend.__index = CCSceneExtend

function CCSceneExtend:onEnter()
	--print("base onEnter")
end

function CCSceneExtend:onEnterTransitionFinish()
end

function CCSceneExtend:onExitTransitionStart()
end

function CCSceneExtend:onCleanup()
	--print("base onCleanup")
end

function CCSceneExtend:onExit()
	--print("base onExit")
end

function CCSceneExtend:registerScriptEvent(handler)
	if handler then
		self:registerScriptHandler(handler)
	else
		local function defaultHandler(event)
			if event == "enter" then
            	self:onEnter()
	        elseif event == "enterTransitionFinish" then
	            self:onEnterTransitionFinish()
	        elseif event == "exitTransitionStart" then
	            self:onExitTransitionStart()
	        elseif event == "cleanup" then
	            self:onCleanup()
	        elseif event == "exit" then
	            self:onExit()
				--CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
	        end
		end
		self:registerScriptHandler(defaultHandler)
	end
end

function CCSceneExtend:removeScriptEvent()
	self:unregisterScriptHandler()
end

function CCSceneExtend.new()
	return CCSceneExtend.extend(CCScene:create())
end

function CCSceneExtend.extend(obj)
	local peer = tolua.getpeer(obj)
	if not peer then
		peer = {}
		tolua.setpeer(obj,peer)
	end
	setmetatable(peer,CCSceneExtend)
	return obj
end

return CCSceneExtend