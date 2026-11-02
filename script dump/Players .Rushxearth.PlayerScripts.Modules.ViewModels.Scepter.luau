local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ScepterExplosionParticles"
):WaitForChild("Attachment")
local Attachment_1 = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ScepterTransformParticles"
):WaitForChild("Attachment")
local Attachment_2 = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ScepterCastParticles"
):WaitForChild("Attachment")
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._cast_attachment = t_1.ItemModel:FindFirstChild("_scepter_cast", true)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(_, arg2, arg3) -- line: 29
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] Attachment (copy)

    local Part = Instance.new("Part")
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Anchored = true
    Part.CanTouch = false
    Part.Transparency = 1
    Part.CFrame = CFrame.new(arg2)
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 5)
    Utility_m:CreateSound(
        "rbxassetid://104637136404553",
        1,
        2 + 0.5 * math.random(),
        Part,
        true,
        10
    )
    local v5 = Attachment:Clone()

    for _, child in pairs(v5:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 4)
        end
    end

    v5.PointLight.Range = arg3 * 2
    v5.Parent = Part
    Utility_m:PlayParticles(v5)
end

function t.PlayCastParticles(arg4, arg5, arg6) -- line: 56
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Attachment_2 (copy)
    --  [3] Utility_m (copy)

    local v8 = arg4._cast_attachment

    if arg5 then
        local Part_1 = Instance.new("Part")
        Part_1.CanCollide = false
        Part_1.CanQuery = false
        Part_1.CanTouch = false
        Part_1.Anchored = true
        Part_1.Transparency = 1
        Part_1.CFrame = CFrame.new(arg5)
        Part_1.Parent = workspace
        BetterDebris_m:AddItem(Part_1, 5)
        v8 = Part_1
    end

    local v9 = Attachment_2:Clone()
    v9.Parent = v8
    BetterDebris_m:AddItem(v9, 5)

    if arg6 then
        for _, val in pairs(v9:GetDescendants()) do
            if val:IsA("ParticleEmitter") then
                Utility_m:ScaleParticleEmitter(val, arg6)
            end
        end
    end

    Utility_m:PlayParticles(v9)
end

function t.TransformProjectile(_, arg8, arg9) -- line: 88
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Attachment_1 (copy)

    if not arg8 or not arg9 then
        return
    end

    Utility_m:CreateSound(
        "rbxassetid://81429998577064",
        1,
        1.5 + 0.5 * math.random(),
        arg8,
        true,
        10
    )
    arg9.Part.Normal:Destroy()

    for _, descendant in pairs(arg9.Part.Transformed:GetDescendants()) do
        if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true
        end
    end

    local v14 = Attachment_1:Clone()
    v14.Parent = arg9.Part
    Utility_m:PlayParticles(v14)
end

function t._Init(arg10) -- line: 112
    task.defer(function() -- line: 113
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.ClientItem.ProjectileShot:Connect(function() -- line: 114
            -- upvalues:
            --  [1] arg10 (ref)

            arg10:PlayCastParticles()
        end)
    end)
end

return t
