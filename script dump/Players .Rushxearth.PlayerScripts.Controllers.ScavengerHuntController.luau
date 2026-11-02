local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ScavengerHuntLibrary_m = require(ReplicatedStorage.Modules.ScavengerHuntLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local CollectEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.Functions.CollectEffect)
local t = {}
t.__index = t

function t._new() -- line: 14
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._collected = {}
    t_1:_Init()

    return t_1
end

function t._UpdateObject(arg1, arg2, arg3) -- line: 34
    -- upvalues:
    --  [1] ScavengerHuntLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] CollectEffect_m (copy)
    --  [4] CameraController_m (copy)
    --  [5] CONSTANTS_m (copy)

    if arg1._collected[arg2] then
        return
    end

    local ScavengerHuntName = arg2:GetAttribute("ScavengerHuntName")
    local v1 = ScavengerHuntLibrary_m.Info[ScavengerHuntName]
    local v2 = PlayerDataController_m:Get("ScavengerHunts")[ScavengerHuntName]

    if v2 and table.find(v2, arg2:GetAttribute("ObjectName")) then
        arg1._collected[arg2] = true
        task.defer(arg2.Destroy, arg2)

        if not arg3 then
            CollectEffect_m(arg2:GetPivot().Position, v1.Color, "rbxassetid://129198689909472")
        end

        return
    end

    v2 = true

    if CameraController_m:GetPublicState() ~= CameraController_m.CameraState.States.CustomFreecam then
        v2 = CONSTANTS_m.IS_PRIVATE_HUB_SERVER

        if v2 then
            v2 = not v1.AllowedInPrivateServers
        end
    end

    v1 = if not v2 then 0 else 1
    local v5 = pairs
    local _ = arg2:GetAttribute("ObjectName")

    for _, val in v5(arg2:GetDescendants()) do
        if val:IsA("BasePart") or val:IsA("ParticleEmitter") then
            val.LocalTransparencyModifier = v1
        end
    end
end

function t._UpdateAllObjects(arg4, arg5) -- line: 66
    -- upvalues:
    --  [1] CollectionService (copy)

    for _, val_1 in pairs(CollectionService:GetTagged("ScavengerHunt")) do
        task.defer(arg4._UpdateObject, arg4, val_1, arg5)
    end
end

function t._Init(arg6) -- line: 72
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CollectionService (copy)
    --  [3] CameraController_m (copy)

    PlayerDataController_m:GetDataChangedSignal("ScavengerHunts"):Connect(function() -- line: 73
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateAllObjects()
    end)
    CollectionService:GetInstanceAddedSignal("ScavengerHunt"):Connect(function(arg7) -- line: 77
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateObject(arg7, true)
    end)
    CameraController_m.CustomFreecamStateChanged:Connect(function() -- line: 81
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateAllObjects()
    end)
    arg6:_UpdateAllObjects(true)
end

return t._new()
