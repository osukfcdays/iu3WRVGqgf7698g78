local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.Utility)
local _ = require(ReplicatedStorage.Modules.Spring)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local SmokeCloud_m = require(Players.LocalPlayer.PlayerScripts.Modules.SmokeCloud)
local _ = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("SmokeClouds")
local SmokeClouds_1 = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("SmokeClouds")
local t = {}
t.__index = t

function t._new() -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._smoke_clouds = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 31
    -- upvalues:
    --  [1] SpectateController_m (copy)

    local t_2 = {}

    for key, val in pairs(arg1._smoke_clouds) do
        if val:IsDestroyed() then
            t_2[key] = true
        elseif SpectateController_m:IsRendered(val.EnvironmentID) then
            val:Update(arg2)
        end
    end

    for key_1, _ in pairs(t_2) do
        arg1._smoke_clouds[key_1] = nil
    end
end

function t._ObjectRemoved(arg3, arg4) -- line: 56
    local v1 = arg3._smoke_clouds[arg4]

    if not v1 then
        return
    end

    v1:Clear()
end

function t._ObjectAdded(arg5, arg6) -- line: 66
    -- upvalues:
    --  [1] SmokeClouds_1 (copy)
    --  [2] SmokeCloud_m (copy)

    if arg5._smoke_clouds[arg6] then
        arg5._smoke_clouds[arg6]:Destroy()
        arg5._smoke_clouds[arg6] = nil
    end

    local SmokeClouds_2 = arg5._smoke_clouds
    local v2 = SmokeClouds_1:FindFirstChild(arg6.Name) and require(SmokeClouds_1[arg6.Name]) or SmokeCloud_m
    SmokeClouds_2[arg6] = v2.new(arg6)
    arg5._smoke_clouds[arg6].Model.Parent = workspace
    arg5:Update(0)
end

function t._Init(arg7) -- line: 78
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceRemovedSignal("SmokeCloud"):Connect(function(arg8) -- line: 79
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectRemoved(arg8)
    end)
    CollectionService:GetInstanceAddedSignal("SmokeCloud"):Connect(function(arg9) -- line: 83
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_ObjectAdded(arg9)
    end)

    for _, val_2 in pairs(CollectionService:GetTagged("SmokeCloud")) do
        task.spawn(arg7._ObjectAdded, arg7, val_2)
    end
end

return t._new()
