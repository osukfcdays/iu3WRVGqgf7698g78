local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local t = setmetatable({}, ReplicatedClass_m)
t.__index = t

function t._new() -- line: 9
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ReplicatedClass_m.new(), t)
    t_1:_Init()

    return t_1
end

function t.GetFFlag(arg1, arg2) -- line: 21
    return arg1:Get(arg2)
end

function t.SetFFlag(arg3, arg4, arg5) -- line: 25
    arg3:SetReplicate(arg4, arg5)
end

function t.IsFreeWeaponsActive(arg6) -- line: 29
    -- upvalues:
    --  [1] ItemLibrary_m (copy)

    for key, _ in pairs(ItemLibrary_m.Statuses) do
        if arg6:GetFFlag("FreeToUse" .. key .. "Weapons") then
            return true
        end
    end
end

function t._Fetch(arg7) -- line: 41
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    for key_1, val_1 in pairs((ReplicatedStorage.Remotes.Misc.RequestFFlags:InvokeServer())) do
        arg7:SetFFlag(key_1, val_1)
    end
end

function t._Init(arg8) -- line: 49
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Misc.UpdateFFlag.OnClientEvent:Connect(function(...) -- line: 50
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:SetFFlag(...)
    end)
    task.defer(arg8._Fetch, arg8)
end

return t._new()
