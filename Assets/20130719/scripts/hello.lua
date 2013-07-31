
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
	
	local sp = CCSprite:create("1.png")
	local layer = CCLayer:create()
	layer:addChild(sp)
	scene:addChild(layer)
	CCDirector:sharedDirector():runWithScene(scene)
	local v = getNumber()
	print("1234!!" .. v)
	
	local v1,v2 = getNumber2()
	
	--debug("[" .. v1 .. "][" .. v2 .. "]")
	debug("testtest")
end

xpcall(aaa, __G__TRACKBACK__)