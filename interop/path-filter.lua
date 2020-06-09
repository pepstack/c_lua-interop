-- path-filter.lua
--   目录过滤脚本
-- version: 0.1
-- create: 2018-10-16
-- update: 2018-12-18

-- https://github.com/pepstack/lua/blob/master/util/stringutil.lua
local function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
       table.insert(result, each)
    end
    return result
end


local sidtable = {
    A = {
        _1 = true,
        _2 = true
    },
    B = {
        _1 = true,
        _2 = false
    }
}

function string.starts(String, Start)
   return string.sub(String,1,string.len(Start))==Start
end

local function isAccept(file, sid)

    if string.starts(file, "beacon.data.dm.collect.") and (sid == '1' or sid == '2') then
        return true
    end
    
    fields = split(file, ".")

    if #fields > 5 then
        sidcfg = sidtable[ fields[5] ]
    
        if sidcfg ~= nil then
            return sidcfg[ "_" .. sid ]
        end
    end
    
    return false
end


-- on_sweep_pathid
-- 目录刷新过滤器
function on_sweep_pathid(intab)
    local outab = {
        intervalms = "1",
        result = "FAILED"
    }

    --[[
    local msg = table.concat({"path-filter-1.lua::on_sweep_pathid(",
        "sid=",          intab.sid,
        "; pathid=",     intab.pathid,
        "; count=",      intab.count,
        "; newdir=",     intab.newdir,
        "; intervalms=", intab.intervalms,
        "; sweepstart=", intab.sweepstart,
        "; sweepend=",   intab.sweepend,
        "; total=",      intab.total,
        "; path=",       intab.path,
        ")"
    })
    print(msg)
    --!]]

    if (intab.count == '0') then
        -- 第一次总是刷新
        outab.result = "SUCCESS"
    end

    if (intab.sid == '0') then
        -- 如果是本地, 不刷新
        outab.result = "FAILED"
    end

    -- TODO: 由用户自定义是否刷新
    -- 不刷新 result = "FAILED"

    if (intab.newdir ~= '0') then
        -- 对于新建目录事件总是刷新
        outab.result = "SUCCESS"
    end

    return outab
end


-- filter_path
-- 仅路径(path)过滤: 路径是绝对路径的全路径名, 以 '/' 结尾 !
function filter_path(intab)
    local outab = {
        result = "REJECT"
    }

    --[[
    local msg = table.concat({"path-filter-1.lua::filter_path(",
        "path=", intab.path,
        ";sid=", intab.sid,
        ")"
    })
    print(msg)
    --]]

    outab.result = "ACCEPT"
    return outab
end


-- filter_file
-- 路径(path)+文件名(file)过滤
function filter_file(intab)
    local outab = {
        result = "REJECT"
    }

    --[[
    local msg = table.concat({"path-filter-1.lua::filter_file(",
            "path=", intab.path,
            ";file=", intab.file,
            ";sid=", intab.sid,
            ";ctime=", intab.ctime,
            ";mtime=", intab.mtime,
            ";size=", intab.size,
            ")"
        })

    print(msg)
    --]]

    outab.result = "ACCEPT"

    --[[
    if isAccept(intab.file, intab.sid) then
        outab.result = "ACCEPT"
    end
    --]]

    return outab
end


-- inotify_watch_on_query
-- 询问是否添加路径监视
function inotify_watch_on_query(intab)
    local outab = {
        result = "ERROR"
    }

    --[[
    local msg = table.concat({"path-filter-1.lua::inotify_watch_on_query(",
            "wpath=", intab.wpath,
            ")"
        })

    print(msg)
    --]]

    outab.result = "SUCCESS"
    return outab
end


-- inotify_watch_on_ready
-- 添加路径监视成功
function inotify_watch_on_ready(intab)
    local outab = {
        result = "ERROR"
    }

    --[[
    local msg = table.concat({"path-filter-1.lua::inotify_watch_on_ready(",
            "wpath=", intab.wpath,
            ")"
        })

    print(msg)
    --]]

    outab.result = "SUCCESS"
    return outab
end


-- inotify_watch_on_error
-- 添加路径监视失败
function inotify_watch_on_error(intab)
    local outab = {
        result = "ERROR"
    }

    --[[
    local msg = table.concat({"path-filter-1.lua::inotify_watch_on_error(",
            "wpath=", intab.wpath,
            ")"
        })

    print(msg)
    --]]

    outab.result = "SUCCESS"
    return outab
end
