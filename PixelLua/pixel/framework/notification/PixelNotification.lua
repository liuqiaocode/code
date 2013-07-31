
--[[

	消息中心脚本定义
]]

if not pixel or pixel.notification then
	return
end

pixel.notification = {
	notifications = {},
	
}

--[[
	通知类型常量定义
]]
pixel.notification.notifyType = {
	controller = {
		C_SCENE_CHANGE = "Control_Scene_Change"
	},
	view = {},
	model = {}
}

--[[
	添加通知监听
]]
function pixel.notification:addNotifyListener(type,callback)
	if not self.notifications[type] then
		self.notifications[type] = {}
	end
	table.insert(self.notifications[type],callback)
end

--[[
	删除通知监听
]]
function pixel.notification:removeNotifyListener(type,callback)
	if self.notifications[type] then
		for idx = 1,#self.notifications[type] do
			if self.notifications[type][idx] == callback then
				self.notifications[type][idx] = nil
				return
			end
		end
	end
end

--[[
	发送通知
]]
function pixel.notification:sendNotify(type,params)
	if self.notifications[type] then
		local invoke = nil
		local delete = {}
		for idx = 1,#self.notifications[type] do
			invoke = self.notifications[type][idx]
			if invoke then
				invoke(type,params)
			else
				table.insert(delete,idx)
			end
		end

		for i = 1,#delete do
			table.remove(self.notifications[type],delete[i])
		end
	end
end