CCScrollViewExtend = {}

CCScrollViewExtend.__index = CCScrollViewExtend
CCScrollViewExtend.constants = {
	LAYOUT_BASE = -1,
	LAYOUT_HORIZONTAL = 0,
	LAYOUT_VERTICAL = 1
}

function CCScrollViewExtend:extend(obj)
	local peer = tolua.getpeer(obj)
	if not peer then
		peer = {
			layout = 1,
			gap = 0,
			paddingLeft = 0,
			paddingTop = 0,
			paddingRight = 0,
			paddingBottom = 0
		}
		tolua.setpeer(obj,peer)
	end
	setmetatable(peer,CCScrollViewExtend)
	return obj
end

--[[
	设置布局
]]
function CCScrollViewExtend:setLayout(value)
	if value ~= self.layout then
		self.layout = value
		self:setDirection(value)
		self:updateLayout()
	end
end

function CCScrollViewExtend:updateLayout()

	local container = self:getContainer()
	local childs = container:getChildren()
	local idx = 1
	local child = nil
	local ox,oy = 0
	if container and childs  then
		local pos = 0
		local size = nil
		if self.layout == self.constants.LAYOUT_HORIZONTAL then
			--横向布局,遍历所有子对象进行位置处理
			for idx = 0,childs:count() - 1 do
				child = childs:objectAtIndex(idx)
				ox,oy = child:getPosition()
				size = child:getTextureRect()
				if idx == 0 then
					ox = pos + self.paddingLeft
				else
					ox = pos + self.gap
				end
				
				pos = ox + size:getMaxX()
				child:setPosition(ccp(ox,oy))
			end

		elseif self.layout == self.constants.LAYOUT_VERTICAL then
			--纵向布局
			--横向布局,遍历所有子对象进行位置处理
			for idx = 0,childs:count() - 1 do
				child = childs:objectAtIndex(idx)
				ox,oy = child:getPosition()
				size = child:getTextureRect()
				if idx == 0 then
					oy = pos + self.paddingTop
				else
					oy = pos + self.gap
				end
				
				pos = oy + size:getMaxY()
				child:setPosition(ccp(ox,oy))
			end
		else
		end
	end
end

return CCScrollViewExtend