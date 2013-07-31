local scene = CCSceneExtend.extend(CCScene:create())

function scene.new()
	local node = CCSceneExtend.extend(CCScene:create())
	local layer = CCLayer:create()
	local icon = CCSprite:create("menu2.png")
	layer:addChild(icon)
	node:addChild(layer)
	local function onTouch(type,x,y)
		print("touch touch2")
		pixel.notification:sendNotify(pixel.notification.notifyType.controller.C_SCENE_CHANGE,"scene1")
	end
	layer:registerScriptTouchHandler(onTouch,false)
	layer:setTouchEnabled(true)
	return node
end

return scene