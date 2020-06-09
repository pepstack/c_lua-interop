-- @file: requires.lua
--    定义所有需要包含的 LUA 脚本!
--
-- @create: 2018-10-26
-- @update: 2018-10-26

-- 定义脚本路径
-- lua 脚本的路径都是存放在: package.path
package.path = package.path .. ";./?.lua;../bin/?.lua"

-- 必须引入安全调用模块: __trycall.lua
require("__trycall")


---[[
-- 加载外部脚本文件, 用户根据需要配置加载哪些 LUA 模块:

require("path-filter")
require("event-task")
require("cjson-filter")

--]]
