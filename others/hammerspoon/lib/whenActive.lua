ApplicationWatcher = nil
ApplicationWatcherMap = {}
function ApplicationWatcherStart()
    if not ApplicationWatcher then
        ApplicationWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
            -- 监听应用程序的激活事件
            for _, entry in ipairs(ApplicationWatcherMap) do
                entry.fn(appName, eventType, appObject)
            end
        end)
    end
    ApplicationWatcher:start()
end

-- 末尾追加订阅
function ApplicationWatcherSubscribeAppend(key, fn)
    ApplicationWatcherUnSubscribe(key)
    table.insert(ApplicationWatcherMap, { key = key, fn = fn })
end

-- 优先订阅（插入开头）
function ApplicationWatcherSubscribeFirst(key, fn)
    ApplicationWatcherUnSubscribe(key)
    table.insert(ApplicationWatcherMap, 1, { key = key, fn = fn })
end

function ApplicationWatcherUnSubscribe(key)
    for i = #ApplicationWatcherMap, 1, -1 do
        if ApplicationWatcherMap[i].key == key then
            table.remove(ApplicationWatcherMap, i)
        end
    end
    if ApplicationWatcher and #ApplicationWatcherMap == 0 then
        ApplicationWatcher:stop()
        ApplicationWatcher = nil
    end
end

function ApplicationWatcherStatus(key)
    if not ApplicationWatcher then return false end
    for _, entry in ipairs(ApplicationWatcherMap) do
        if entry.key == key then return true end
    end
    return false
end

function ShowApplicationWatcherMap()
    local result = ""
    for i, entry in ipairs(ApplicationWatcherMap) do
        print(i, entry.key)
        result = result .. entry.key .. "\n"
    end
    return result
end
