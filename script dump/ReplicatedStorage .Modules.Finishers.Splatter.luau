local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = {
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 215, 0),
    Color3.fromRGB(100, 255, 50),
    Color3.fromRGB(0, 190, 255),
    Color3.fromRGB(122, 56, 255)
}
local t_1 = { "rbxassetid://14796313307", "rbxassetid://14796313578" }
local t_2 = { "rbxassetid://14796313153", "rbxassetid://14796313025" }
local t_3 = setmetatable({}, Ragdoll_m)
t_3.__index = t_3

function t_3.new(...) -- line: 13
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t_3 (copy)

    local t_4 = setmetatable(Ragdoll_m.new(...), t_3)
    t_4:_Init()

    return t_4
end

function t_3.PlayClient(arg1, ...) -- line: 25
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)
    --  [3] Utility_m (copy)
    --  [4] t_1 (copy)
    --  [5] t_2 (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v3 = t[math.random(#t)]:ToHSV()

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Color = Color3.fromHSV((v3 + 0.1 * (math.random() - 0.5)) % 1, 1, 1)
            local t_5 = {}

            for _, val_1 in pairs(script.Particles:GetChildren()) do
                local v6 = val_1:Clone()
                v6.Color = ColorSequence.new(val.Color)
                v6.Parent = val
                table.insert(arg1._destroy_these, v6)
                table.insert(t_5, v6)
            end

            Utility_m:PlayParticles(t_5)
            arg1:CreateSound(
                t_1[math.random(#t_1)],
                1,
                1 + 0.2 * math.random(),
                nil,
                true,
                5
            )
            arg1:CreateSound(
                t_2[math.random(#t_2)],
                1,
                1 + 0.2 * math.random(),
                nil,
                true,
                5
            )
            wait(0.025 + 0.05 * math.random())
        end
    end
end

function t_3._Init(_) -- line: 60
end

return t_3
