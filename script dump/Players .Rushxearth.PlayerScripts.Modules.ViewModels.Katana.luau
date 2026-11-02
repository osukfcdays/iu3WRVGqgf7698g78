local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("WrapController")
)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local DeflectActiveEffects = Players.LocalPlayer.PlayerScripts.Assets.Misc.DeflectActiveEffects
local DeflectHitEffects = Players.LocalPlayer.PlayerScripts.Assets.Misc.DeflectHitEffects
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._deflect_hit_attachment = nil
    t_1._deflect_active_attachment = nil
    t_1._deflect_active_attachment_not_local = nil
    t_1:_Init()

    return t_1
end

function t.PlayDeflectActiveParticles(arg1) -- line: 30
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:PlayParticles(arg1._deflect_active_attachment)

    if not arg1.ClientItem.ClientFighter:Get("IsSpectating") then
        local DeflectActiveAttachmentNotLocal = arg1._deflect_active_attachment_not_local
        DeflectActiveAttachmentNotLocal.Parent = arg1.ClientItem.ClientFighter.Entity and arg1.ClientItem.ClientFighter.Entity.RootPart or nil
        Utility_m:PlayParticles(arg1._deflect_active_attachment_not_local)
    end
end

function t.PlayDeflectHitParticles(arg2) -- line: 39
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:PlayParticles(arg2._deflect_hit_attachment)
end

function t.PlayDeflectHitSounds(arg3) -- line: 43
    arg3:CreateSound(
        "rbxassetid://14776414133",
        1.25,
        1.5 + 0.5 * math.random(),
        true,
        5
    )
    arg3:CreateSound(
        "rbxassetid://14776437962",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t.ClearDeflectActiveParticles(arg4) -- line: 48
    for _, descendant in pairs(arg4._deflect_active_attachment_not_local:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant:Clear()
        end
    end
end

function t.Destroy(arg5) -- line: 56
    -- upvalues:
    --  [1] ClientViewModel_m (copy)

    arg5._deflect_active_attachment_not_local:Destroy()
    ClientViewModel_m.Destroy(arg5)
end

function t._Setup(arg6) -- line: 65
    -- upvalues:
    --  [1] DeflectHitEffects (copy)
    --  [2] DeflectActiveEffects (copy)
    --  [3] WrapController_m (copy)

    arg6._deflect_hit_attachment = arg6.ItemModel:FindFirstChild("_katana_deflect_hit", true)
    arg6._deflect_active_attachment = arg6.ItemModel:FindFirstChild("_katana_deflect_active", true)
    local t_2 = {}

    if arg6._deflect_hit_attachment then
        local v8 = pairs
        local v9 = DeflectHitEffects:FindFirstChild(arg6.Name) or DeflectHitEffects.Default

        for _, val in v8(v9.Attachment:GetChildren()) do
            local v10 = val:Clone()
            v10.Parent = arg6._deflect_hit_attachment
            table.insert(t_2, v10)
        end
    end

    if arg6._deflect_active_attachment then
        local v11 = DeflectActiveEffects:FindFirstChild(arg6.Name) or DeflectActiveEffects.Default

        for _, val_1 in pairs(v11.Attachment:GetChildren()) do
            local v13 = val_1:Clone()
            v13.Parent = arg6._deflect_active_attachment
            table.insert(t_2, v13)
        end

        arg6._deflect_active_attachment_not_local = Instance.new("Attachment")
        arg6._deflect_active_attachment_not_local.Name = "_katana_deflect_active_not_local"

        for _, val_2 in pairs(v11.NotLocal:GetChildren()) do
            local v15 = val_2:Clone()
            v15.Parent = arg6._deflect_active_attachment_not_local
            table.insert(t_2, v15)
        end
    end

    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(t_2),
        arg6.ClientItem:GetWrap(),
        true
    )
end

function t._Init(arg7) -- line: 101
    arg7:_Setup()
end

return t
