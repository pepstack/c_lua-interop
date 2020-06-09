local key=KEYS[1]
local list=redis.call("lrange", key, 0, -1)
return list
