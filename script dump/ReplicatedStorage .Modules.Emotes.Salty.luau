local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(2.6, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://72081093559633")
    local t_2 = {}

    for _, child in pairs(script.Particles:GetChildren()) do
        local v3 = child:Clone()
        local v4 = arg1._humanoid.Parent

        if v4 then
            v4 = arg1._humanoid.Parent:FindFirstChild("LeftHand")
        end

        v3.Parent = v4
        table.insert(t_2, v3)
        table.insert(arg1._destroy_these, v3)
    end

    local _ = function(arg2) --[[ enable ]] -- line: 36
        -- upvalues:
        --  [1] t_2 (copy)

        for _, val in pairs(t_2) do
            val.Enabled = arg2
        end
    end

    for _, val_1 in pairs(t_2) do
        val_1.Enabled = false
    end

    wait(0.5)
    arg1:CreateSound(
        "rbxassetid://82749828642126",
        1,
        1,
        nil,
        true,
        5
    )
    wait(0.2)

    for _, val_2 in pairs(t_2) do
        val_2.Enabled = true
    end

    wait(0.6)

    for _, val_3 in pairs(t_2) do
        val_3.Enabled = false
    end
end

function t._Init(_) -- line: 55
end

return t
