local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = require(ReplicatedStorage.Modules.CosmeticLibrary)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = {
    { "RightUpperArm", "RightLowerArm", "RightHand" },
    { "LeftUpperArm", "LeftLowerArm", "LeftHand" },
    { "RightUpperLeg", "RightLowerLeg", "RightFoot" },
    { "LeftUpperLeg", "LeftLowerLeg", "LeftFoot" },
    { "UpperTorso", "LowerTorso", "Head" }
}
local t_6 = setmetatable({}, Ragdoll_m)
t_6.__index = t_6

function t_6.new(...) -- line: 18
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t_6 (copy)

    local t_7 = setmetatable(Ragdoll_m.new(...), t_6)
    t_7:_Init()

    return t_7
end

function t_6.PlayServer(arg1, ...) -- line: 30
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    wait(#t * 0.2 + 1)
    arg1:_HideBody()
end

function t_6.PlayClient(arg2, ...) -- line: 38
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    Ragdoll_m.PlayClient(arg2, ...)

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            if not (val.Transparency >= 0.99) then
                val.Color = Color3.fromRGB(106, 73, 50)
                val.Material = Enum.Material.Slate

                if val.Name == "Head" then
                    script.Head:Clone().Parent = val
                elseif val.Name == "UpperTorso" then
                    script.UpperTorso:Clone().Parent = val
                elseif val.Name ~= "LowerTorso" then
                    for _, val_1 in pairs(script.Textures:GetChildren()) do
                        val_1:Clone().Parent = val
                    end
                end
            end
        elseif
            val:IsA("ParticleEmitter")
            or val:IsA("Beam")
            or val:IsA("Trail")
            or val:IsA("Decal")
            or val:IsA("Clothing")
            or val:IsA("Texture")
        then
            val:Destroy()
        end
    end

    if not arg2._is_humanoid then
        return
    end

    local t_8 = {}

    for key_2, _ in pairs(t) do
        table.insert(t_8, key_2)
    end

    wait(1)

    for _ = 1, #t_8 do
        for _, val_3 in pairs(t[table.remove(t_8, math.random(#t_8))]) do
            arg2._subject.Parent[val_3]:Destroy()
        end

        arg2:CreateSound(
            "rbxassetid://18128896162",
            1,
            1 + 0.1 * math.random(),
            nil,
            true,
            5
        )
        wait(0.2)
    end

    arg2:CreateSound(
        "rbxassetid://18128949754",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        10
    )
end

function t_6._Init(_) -- line: 95
end

return t_6
