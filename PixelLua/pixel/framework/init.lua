pixel = {}

package.path = string.format("%s;%s?.lua;%s?/init.lua", package.path, "./", "./")

require "pixel/framework/mvc/init"
require "pixel/framework/cocos2dx/init"