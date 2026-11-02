local Ragdoll_m = require(game:GetService("ReplicatedStorage").Modules.Finishers.Ragdoll)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 20
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayClient(arg1, ...)

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            if val.Name ~= "Head" and not (val.Transparency >= 0.99) then
                local v3 = math.random() < 0.5 and true
                local v4 = v3 and Color3.fromRGB(247, 42, 55) or Color3.fromRGB(14, 150, 57)
                val.Color = v4
                val.Material = Enum.Material.SmoothPlastic
                v4 = if not v3 then "WrappingPaper" else "WrappingPearlescent"
                val.MaterialVariant = v4

                for _, val_1 in pairs(script.Textures:GetChildren()) do
                    val_1:Clone().Parent = val
                end
            end
        elseif val:IsA("ParticleEmitter") or val:IsA("Beam") or val:IsA("Trail") then
            val:Destroy()
        end
    end

    arg1:CreateSound(
        "rbxassetid://74885181688460",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 50
end

return t
