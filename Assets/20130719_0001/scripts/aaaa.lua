
function print(msg)
	CCLuaLog(msg)
end

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function aaa()
	
	local scene = CCScene:create()
	
	local sp = CCSprite:create("aaaa.png")
	local layer = CCLayer:create()
	layer:addChild(sp)
	scene:addChild(layer)
	CCDirector:sharedDirector():runWithScene(scene)
end

xpcall(aaa, __G__TRACKBACK__)