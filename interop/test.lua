-- test.lua
-- http://www.lua.org/manual/5.3/manual.html
-- https://www.cnblogs.com/chenny7/p/3634529.html

-- 定义 lua 脚本的路径
package.path = package.path .. ";./?.lua;../bin/?.lua"

-- 定义 so 模块路径
package.cpath = package.cpath .. ";./?.so;../lib/lua/5.3/cjson.so;../libs/lib/lua/5.3/cjson.so"

-- 必须引入安全调用模块: trycall.lua
require("__trycall")



local function create_config_cjson ()
    -- 加载 cjson 模块:
    local cjson = require("cjson")

    -- 创建一个副本 (默认配置)
    local cjson2 = cjson.new()

    -- 设置重用 buffer (默认)
    cjson2.encode_keep_buffer(true)
     
    -- 最大解码层数 (默认 1000)
    cjson2.decode_max_depth(10)

    -- 遇到非法数字转为 null  (默认 false)
    cjson2.encode_invalid_numbers(null)

    -- 设置数字的精度 (默认 14)
    cjson2.encode_number_precision(10)

    return cjson2
end


local function process_json_line (line, js, outfd)
    local nw = 0

    local jstab = js.decode(line)

    local genid = jstab.gen_id
    local rekey = jstab.redis_key
    local rkval = jstab[rekey]
    
    if (rkval ~= nil) then
        if (type(rkval) == "string") then
            local jsobjects = js.decode(rkval)

            for k, v in pairs(jsobjects) do
                local msg = table.concat({genid, "|", v.obj, "|", v.t, "\n"})

                outfd:write(msg)

                -- 计算输出行数
                nw = nw + 1
            end
        else
            for k, v in pairs(rkval) do
                local msg = table.concat({genid, "|", v.obj, "|", v.t, "\n"})

                outfd:write(msg)

                -- 计算输出行数
                nw = nw + 1
            end
        end
    end

    return nw
end


-- http://valleu87.blog.163.com/blog/static/19670343220121111045390/
function dump_my_jsonfile(intab)
    -- 返回值
    local outab = {
        result = "ERROR"
    }

    -- 创建 cjson 模块
    local js = create_config_cjson()

    local flush_batch_msgs = 200

    local print_read_lines = 100000

    local jsonfile = intab.jsonfile
    local jsonoutfile = intab.jsonoutfile

    local tstart = os.time()

    print(string.format("start time : %d", tstart))

    print(string.format("input file : %s", jsonfile))
    print(string.format("output file: %s", jsonoutfile))

    -- 输出文件会被覆盖!!
    local outfd = io.open(jsonoutfile, "w")

    -- 行计数
    local lc = 0
    local lw = 0
    local nw = 0
    local nc = 0

    for line in io.lines(jsonfile) do
        -- 计算输入行数
        nc = nc + 1

        ---[[ 处理 json 行为 csv
        local jstab = js.decode(line)

        local genid = jstab.gen_id
        local rekey = jstab.redis_key

        if rekey then
            local objflag = "0"

            if (rekey == "activeobjects") then
                objflag = "1"
            elseif (rekey == "addobjects") then
                objflag = "2"
            end

            local rkval = jstab[rekey]

            -- { genid | objflag | objid | objtype }

            if (rkval ~= nil) then
                if (type(rkval) == "string") then
                    local jsobjects = js.decode(rkval)

                    for k, v in pairs(jsobjects) do
                        local msg = table.concat({genid, "|", objflag, "|", v.obj, "|", math.modf(v.t), "\n"})
                        outfd:write(msg)
                        nw = nw + 1
                    end
                else
                    for k, v in pairs(rkval) do
                        local msg = table.concat({genid, "|", objflag, "|", v.obj, "|", math.modf(v.t), "\n"})
                        outfd:write(msg)
                        nw = nw + 1
                    end
                end
            end

            if (nw >= flush_batch_msgs) then
                outfd:flush()
                lw = lw + nw
                nw = 0
            end

            ---[[
            if (nc >= print_read_lines) then
                lc = lc + nc
                nc = 0

                local els = os.time() - tstart + 1
                print(string.format("input %d lines done. (output %d lines. input speed=%d lps. output speed=%d lps.)",
                    lc, lw, math.modf(lc / els), math.modf(lw / els)))
            end
            --]]
        end
    end

    lc = lc + nc
    lw = lw + nw

    -- 提交写文件
    outfd:flush()

    -- 关闭写文件
    outfd:close()

    local els = os.time() - tstart + 1

    print(string.format("input %d lines done. (input speed=%d lps. output speed=%d lps.)", lc, math.modf(lc / els), math.modf(lw / els)))

    print("------------------- SUMMARY BEGIN -------------------")
    print("NOTES: speed = N lps. - N lines per second")
    print(string.format("elapsed seconds = %d", els))
    print(string.format("input lines     = %d", lc))
    print(string.format("output lines    = %d", lw))
    print(string.format("input speed     = %d lps.", math.modf(lc / els)))
    print(string.format("output speed    = %d lps.", math.modf(lw / els)))
    print("------------------- SUMMARY   END -------------------")

    -- 返回值
    outab.result = "SUCCESS"
    return outab
end


-- main function
--  
local out = __trycall("dump_my_jsonfile", {
        jsonfile = "/root/Downloads/shop01-rdb_6101.rdb.json",
        jsonoutfile = "/root/Downloads/shop01-rdb_6101.rdb.json.out"
    })

print("result=" .. out.result)
print("exception=" .. out.exception)
