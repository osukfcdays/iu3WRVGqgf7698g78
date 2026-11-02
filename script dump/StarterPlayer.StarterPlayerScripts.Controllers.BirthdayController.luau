local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BirthdayLibrary_m = require(ReplicatedStorage.Modules.BirthdayLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t._new() -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t._ObjectAdded(_, arg2) -- line: 29
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] BirthdayLibrary_m (copy)
    --  [3] ReplicatedStorage (copy)

    arg2.Triggered:Connect(function() -- line: 30
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] BirthdayLibrary_m (ref)
        --  [3] ReplicatedStorage (ref)

        if not PlayerDataController_m:Get("BirthdaysWitnessed")[BirthdayLibrary_m.CURRENT_BIRTHDAY_STRING] then
            ReplicatedStorage.Remotes.Data.TakeCake:FireServer()
        end
    end)
end

function t._Init(arg3) -- line: 37
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("BirthdayCakePrompt"):Connect(function(arg4) -- line: 38
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_ObjectAdded(arg4)
    end)

    for _, val in pairs(CollectionService:GetTagged("BirthdayCakePrompt")) do
        task.defer(arg3._ObjectAdded, arg3, val)
    end
end

return t._new()
