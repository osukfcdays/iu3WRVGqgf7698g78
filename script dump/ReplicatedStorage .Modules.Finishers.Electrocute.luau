local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 24
    if arg1._is_humanoid then
        arg1._subject.RootPart.Anchored = true
    end

    wait(1.7999999999999998)

    if arg1._is_humanoid then
        arg1._subject.RootPart.Anchored = false
    end

    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t.PlayClient(arg2, ...) -- line: 39
    -- upvalues:
    --  [1] Utility_m (copy)

    local t_2 = {}

    for _, val in pairs(arg2:_GetObjects()) do
        if val:IsA("BasePart") and not (val.Transparency > 0) then
            local v5 = script[if val.Name == "Head" then "Head" else "Limb"]:Clone()
            v5.Size = val.Size
            v5.CFrame = val.CFrame
            v5.Parent = val
            table.insert(t_2, v5)
            table.insert(arg2._destroy_these, v5)
            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = val
            WeldConstraint.Part1 = v5
            WeldConstraint.Parent = v5

            if val.Name == "Head" then
                local v6 = script.Face:Clone()
                v6.CFrame = val.CFrame
                v6.Parent = val
                table.insert(t_2, v6.Decal)
                table.insert(arg2._destroy_these, v6)
                local WeldConstraint_1 = Instance.new("WeldConstraint")
                WeldConstraint_1.Part0 = val
                WeldConstraint_1.Part1 = v6
                WeldConstraint_1.Parent = v6
            end
        end
    end

    local v7 = arg2._is_humanoid

    if v7 then
        v7 = arg2._subject.Parent:FindFirstChild("face", true)
    end

    if v7 then
        v7:Destroy()
    end

    v7 = {}
    local t_3 = {}

    for _, val_1 in pairs(arg2:_GetObjects(true)) do
        if val_1:IsA("BasePart") or val_1:IsA("Decal") then
            t_3[val_1] = val_1.Transparency

            if val_1:IsA("BasePart") then
                local v9 = script.Particles.Enabled:Clone()
                v9.Parent = val_1
                table.insert(arg2._destroy_these, v9)
                table.insert(v7, v9)

                for _, val_2 in pairs(v9:GetChildren()) do
                    Utility_m:ScaleParticleEmitter(val_2, 0.5)
                end

                local v11 = script.Particles.Smoke:Clone()
                v11.Parent = val_1
                table.insert(arg2._destroy_these, v11)
            end
        end
    end

    arg2:CreateSound(
        "rbxassetid://79646963478511",
        0.75,
        1,
        nil,
        true,
        5
    )

    local _ = function(arg3) --[[ show_shock ]] -- line: 105
        -- upvalues:
        --  [1] t_3 (copy)
        --  [2] t_2 (copy)

        local v12

        for key_3, val_3 in pairs(t_3) do
            v12 = if not arg3 then val_3 else 1
            key_3.Transparency = v12
        end

        for _, val_4 in pairs(t_2) do
            v12 = if not arg3 then 1 else 0
            val_4.Transparency = v12
        end
    end

    for _ = 1, 15 do
        for key_5, _ in pairs(t_3) do
            key_5.Transparency = 1
        end

        for _, val_6 in pairs(t_2) do
            val_6.Transparency = 0
        end

        wait(0.08)

        for key_7, val_7 in pairs(t_3) do
            key_7.Transparency = val_7
        end

        for _, val_8 in pairs(t_2) do
            val_8.Transparency = 1
        end

        wait(0.04)
    end

    for _, val_9 in pairs(v7) do
        val_9:Destroy()
    end

    for _, val_10 in pairs(t_2) do
        val_10:Destroy()
    end

    for _, val_11 in pairs(arg2:_GetObjects(true)) do
        if val_11:IsA("BasePart") then
            val_11.Color = Color3.fromRGB(30, 30, 30)
            val_11.Material = Enum.Material.Grass
            val_11.Reflectance = 0
            val_11.MaterialVariant = ""

            if val_11:IsA("MeshPart") then
                val_11.TextureID = ""
            end
        elseif
            val_11:IsA("Beam")
            or val_11:IsA("Trail")
            or val_11:IsA("Texture")
            or val_11:IsA("Decal")
            or val_11:IsA("Clothing")
            or val_11:IsA("ShirtGraphic")
        then
            val_11:Destroy()
        end
    end
end

function t._Init(_) -- line: 153
end

return t
