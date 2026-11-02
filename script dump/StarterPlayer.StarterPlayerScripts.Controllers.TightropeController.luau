local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local Tightrope_m = require(Players.LocalPlayer.PlayerScripts.Modules.Tightrope)
local t = {}
t.__index = t

function t._new() -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Tightropes = {}
    t_1:_Init()

    return t_1
end

function t.GetActiveTightrope(arg1) -- line: 24
    for _, val in pairs(arg1.Tightropes) do
        if val.Active then
            return val
        end
    end
end

function t.GetTightrope(arg2, arg3) -- line: 32
    for key_1, val_1 in pairs(arg2.Tightropes) do
        if val_1.Part == arg3 then
            return val_1, key_1
        end
    end
end

function t.JumpOff(arg4) -- line: 40
    for _, val_2 in pairs(arg4.Tightropes) do
        val_2:JumpOff()
    end
end

function t._ObjectAdded(arg5, arg6) -- line: 50
    -- upvalues:
    --  [1] Tightrope_m (copy)

    local v2 = Tightrope_m.new(arg5, arg6)
    table.insert(arg5.Tightropes, v2)
end

function t._ObjectRemoved(arg7, arg8) -- line: 55
    local v3, v4 = arg7:GetTightrope(arg8)

    if not v3 then
        return
    end

    v3:Destroy()
    table.remove(arg7.Tightropes, v4)
end

function t._HookLocalFighter(arg9) -- line: 66
    -- upvalues:
    --  [1] FighterController_m (copy)

    local v6 = FighterController_m:WaitForLocalFighter()

    local function entity_added(arg10) -- line: 69
        -- upvalues:
        --  [1] arg9 (copy)

        arg10.AirborneChanged:Connect(function() -- line: 70
            -- upvalues:
            --  [1] arg10 (copy)
            --  [2] arg9 (ref)

            if arg10:IsAirborne() then
                arg9:JumpOff()
            end
        end)
        arg10:GetDataChangedSignal("IsFrozen"):Connect(function() -- line: 76
            -- upvalues:
            --  [1] arg10 (copy)
            --  [2] arg9 (ref)

            if arg10:Get("IsFrozen") then
                arg9:JumpOff()
            end
        end)
    end

    v6.EntityAdded:Connect(entity_added)

    if v6.Entity then
        entity_added(v6.Entity)
    end
end

function t._Init(arg11) -- line: 90
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("Tightrope"):Connect(function(arg12) -- line: 91
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_ObjectAdded(arg12)
    end)
    CollectionService:GetInstanceRemovedSignal("Tightrope"):Connect(function(arg13) -- line: 95
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_ObjectRemoved(arg13)
    end)

    for _, val_3 in pairs(CollectionService:GetTagged("Tightrope")) do
        task.defer(arg11._ObjectAdded, arg11, val_3)
    end

    task.defer(arg11._HookLocalFighter, arg11)
end

return t._new()
