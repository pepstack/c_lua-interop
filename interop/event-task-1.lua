-- event-task.lua
--   任务执行脚本
-- version: 0.1
-- create: 2018-10-16
-- update: 2018-10-16

--[[
 设置 kafka 连接参数:
    "ha02.pepstack.com:9092,ha03.pepstack.com:9092,ha04.pepstack.com:9092,ha07.pepstack.com:9092,ha08.pepstack.com:9092"
--]]
function kafka_config(intab)
    local outab = {
        result = "ERROR",
        bootstrap_servers = "localhost:9092",
        socket_timeout_ms = "1000"
    }

    --[[
    local msg = table.concat({
            "event-task-1.lua"
            ,"::"
            ,"kafka_config("
            ,"kafkalib="
            ,intab.kafkalib
            ,")"
        })
    print(msg)
    --]]

    outab.result = "SUCCESS"
    return outab
end


-- {type|time|clientid|thread|sid|event|pathid|path|file|route}
--
function on_event_task(intab)
    local outab = {
        result = "ERROR",
        loglevel = "INFO",
        kafka_topic = table.concat({intab.clientid, "_", intab.pathid, "_test"}),
        kafka_partition = "0"
    }

    -- 指定输出的消息
    outab.message = table.concat({
        "{"
        ,intab.type
        ,"|"
        ,intab.time
        ,"|"
        ,intab.clientid
        ,"|"
        ,intab.thread
        ,"|"
        ,intab.sid
        ,"|"
        ,intab.event
        ,"|"
        ,intab.pathid
        ,"|"
        ,intab.path
        ,"|"
        ,intab.file
        ,"|"
        ,intab.route
        ,"}"
    })

    --[[ 调试输出
    print(outab.kafka_topic)
    print(outab.message)
    --]]

    --dump_my_jsonfile({
    --    jsonfile = intab.path .. intab.file,
    --    jsonoutfile = "/tmp/" .. intab.file .. ".csv"
    --})

    outab.result = "SUCCESS"
    return outab
end
