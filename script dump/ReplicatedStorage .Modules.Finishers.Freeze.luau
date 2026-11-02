local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 21
    arg1:_AnchorModel(0)
end

function t.PlayClient(arg2) -- line: 25
    -- upvalues:
    --  [1] Utility_m (copy)

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Color = Color3.fromRGB(110, 241, 243)
            val.Material = Enum.Material.Glass
            val.MaterialVariant = ""
            val.Reflectance = 0.4
        elseif val:IsA("ParticleEmitter") or val:IsA("Beam") or val:IsA("Trail") then
            val:Destroy()
        end
    end

    local v3 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v4 = script.Particles.Appear:Clone()
    v4.Parent = v3
    table.insert(arg2._destroy_these, v4)
    Utility_m:PlayParticles(v4)
    arg2:CreateSound(
        "rbxassetid://93583856628897",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(3)
    arg2:CreateSound(
        "rbxassetid://132622182757236",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://122487606797793",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    v4:Destroy()

    for _, val_1 in pairs(arg2:_GetObjects(true)) do
        if val_1:IsA("BasePart") and val_1 ~= v3 then
            val_1:Destroy()
        end
    end

    local v9 = script.Particles.Emit:Clone()
    v9.Parent = v3
    table.insert(arg2._destroy_these, v9)
    Utility_m:PlayParticles(v9)
end

function t._Init(_) -- line: 69
end

return t
