local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local Wildcat_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Wildcat)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc.ShadowPoofEffect.Attachment
local gradient = ColorSequence.new(Color3.fromRGB(255, 255, 255))
local t = setmetatable({}, Wildcat_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] Wildcat_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Wildcat_m.new(...), t)
    t_1._state2_primary_part = t_1.ItemModel:WaitForChild("ReloadWildcat"):WaitForChild(
        "ReloadWildcatPrimary"
    )
    t_1._state1_primary_part = t_1.ItemModel:WaitForChild("Body"):WaitForChild("BodyPrimary")
    t_1._reparented_attachments = {
        t_1._state1_primary_part:WaitForChild("_aim_lookat"),
        t_1._state1_primary_part:WaitForChild("_aim_position"),
        t_1._state1_primary_part:WaitForChild("_muzzle")
    }
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 31
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.PlayShadowPoofParticles(arg2, arg3, arg4) -- line: 35
    -- upvalues:
    --  [1] Attachment (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] WrapController_m (copy)

    local v3 = if arg3 ~= 1 then arg2._state2_primary_part else arg2._state1_primary_part
    local v4 = Attachment:Clone()

    if arg4 then
        v4.Parent = v3
    else
        v4.Parent = arg2.Model.HumanoidRootPart
        v4.WorldCFrame = v3.CFrame * Attachment.CFrame
    end

    BetterDebris_m:AddItem(v4, 5)
    Utility_m:PlayParticles(v4)
    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(v4),
        arg2.ClientItem:GetWrap(),
        true
    )
end

function t._UpdateAttachmentParents(arg5) -- line: 55
    local v8 = if arg5.ClientItem:Get("NumReloadsSoFar") % 2 + 1 == 1 then arg5._state1_primary_part else arg5._state2_primary_part

    for _, val in pairs(arg5._reparented_attachments) do
        val.Parent = v8
    end
end

function t._Init(arg6) -- line: 64
    arg6.ClientItem:GetDataChangedSignal("NumReloadsSoFar"):Connect(function() -- line: 65
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateAttachmentParents()
    end)
    task.defer(arg6._UpdateAttachmentParents, arg6)
end

return t
