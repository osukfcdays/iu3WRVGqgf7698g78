local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local t = {}
t.__index = t

function t._new() -- line: 7
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t._Parse(_, arg2) -- line: 25
    local t_2 = {}
    local v1 = ""

    for index = 1, #arg2 do
        local substring = string.sub(arg2, index, index)

        if substring == "," or index == #arg2 then
            if index == #arg2 then
                v1 ..= substring
            end

            table.insert(t_2, (tonumber(v1)))
            v1 = ""
        else
            v1 ..= substring
        end
    end

    return t_2
end

function t._ObjectAdded(arg3, arg4) -- line: 47
    -- upvalues:
    --  [1] Players (copy)

    if table.find(arg3:_Parse(arg4:GetAttribute("UserIDs")), Players.LocalPlayer.UserId) then
        return
    end

    task.defer(arg4.Destroy, arg4)
end

function t._Init(arg5) -- line: 55
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("UserIDsShow"):Connect(function(arg6) -- line: 56
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_ObjectAdded(arg6)
    end)

    for _, val in pairs(CollectionService:GetTagged("UserIDsShow")) do
        task.defer(arg5._ObjectAdded, arg5, val)
    end
end

return t._new()
