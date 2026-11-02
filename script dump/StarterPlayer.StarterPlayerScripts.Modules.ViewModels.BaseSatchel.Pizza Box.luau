local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BaseSatchel_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseSatchel)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "PizzaExplosionEffect"
):WaitForChild("Attachment")
local t = setmetatable({}, BaseSatchel_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] BaseSatchel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseSatchel_m.new(...), t)
    t_1._registered_ammo_visuals = {}
    local v2 = t_1._charm_pivot_attachment

    if v2 then
        v2 = t_1._charm_pivot_attachment.Parent
    end

    t_1._charm_attachment_parent = v2
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(_, arg2, arg3) -- line: 28
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)
    --  [3] Attachment (copy)

    local Part = Instance.new("Part")
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Anchored = true
    Part.Transparency = 1
    Part.CFrame = CFrame.new(arg2)
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 5)
    Utility_m:CreateSound(
        "rbxassetid://13455969017",
        0.4,
        0.9 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://74472565321499",
        1.2,
        1 + 0.2 * math.random(),
        Part,
        true,
        10
    )
    local v7 = Attachment:Clone()

    for _, child in pairs(v7:GetChildren()) do
        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, arg3 / 8)
        end
    end

    v7.PointLight.Range = arg3 * 2
    v7.Parent = Part
    Utility_m:PlayParticles(v7)
end

function t._UpdateAmmoVisual(arg4) -- line: 59
    if arg4._destroyed then
        return
    end

    for key_1, val in pairs(arg4._registered_ammo_visuals) do
        local v10 = val <= arg4.ClientItem:Get("Ammo") and true
        arg4:_LocalTransparencyModifier(key_1, "AmmoVisual", if not v10 then 1 else 0)

        if val == 1 and arg4._charm_pivot_attachment then
            local CharmPivotAttachment = arg4._charm_pivot_attachment
            local v12 = v10 and arg4._charm_attachment_parent or nil
            CharmPivotAttachment.Parent = v12
        end
    end
end

function t._RegisterAmmoVisual(arg5, arg6, arg7) -- line: 75
    arg5._registered_ammo_visuals[arg6] = arg7
end

function t._Init(arg8) -- line: 79
    arg8.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 80
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateAmmoVisual()
    end)
    local MeshPart1 = arg8.ItemModel:WaitForChild("Slice 1"):WaitForChild("MeshPart1")
    arg8:_RegisterAmmoVisual(MeshPart1, 1)
    local MeshPart2 = arg8.ItemModel:WaitForChild("Slice 1"):WaitForChild("MeshPart2")
    arg8:_RegisterAmmoVisual(MeshPart2, 1)
    local MeshPart3 = arg8.ItemModel:WaitForChild("Slice 1"):WaitForChild("MeshPart3")
    arg8:_RegisterAmmoVisual(MeshPart3, 1)
    local MeshPart4 = arg8.ItemModel:WaitForChild("Slice 1"):WaitForChild("MeshPart4")
    arg8:_RegisterAmmoVisual(MeshPart4, 1)
    local MeshPart1_1 = arg8.ItemModel:WaitForChild("Slice 2"):WaitForChild("MeshPart1")
    arg8:_RegisterAmmoVisual(MeshPart1_1, 2)
    local MeshPart2_1 = arg8.ItemModel:WaitForChild("Slice 2"):WaitForChild("MeshPart2")
    arg8:_RegisterAmmoVisual(MeshPart2_1, 2)
    local MeshPart3_1 = arg8.ItemModel:WaitForChild("Slice 2"):WaitForChild("MeshPart3")
    arg8:_RegisterAmmoVisual(MeshPart3_1, 2)
    local MeshPart4_1 = arg8.ItemModel:WaitForChild("Slice 2"):WaitForChild("MeshPart4")
    arg8:_RegisterAmmoVisual(MeshPart4_1, 2)
    local MeshPart1_2 = arg8.ItemModel:WaitForChild("Slice 3"):WaitForChild("MeshPart1")
    arg8:_RegisterAmmoVisual(MeshPart1_2, 3)
    local MeshPart2_2 = arg8.ItemModel:WaitForChild("Slice 3"):WaitForChild("MeshPart2")
    arg8:_RegisterAmmoVisual(MeshPart2_2, 3)
    local MeshPart3_2 = arg8.ItemModel:WaitForChild("Slice 3"):WaitForChild("MeshPart3")
    arg8:_RegisterAmmoVisual(MeshPart3_2, 3)
    local MeshPart4_2 = arg8.ItemModel:WaitForChild("Slice 3"):WaitForChild("MeshPart4")
    arg8:_RegisterAmmoVisual(MeshPart4_2, 3)
end

return t
