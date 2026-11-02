local Emote_m = require(game:GetService("ReplicatedStorage").Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(nil, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Emote_m (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://71250144811352")
end

function t._Recolor(arg2) -- line: 32
    for _, descendant in pairs(arg2._humanoid.Parent:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 0.99 then
            for _, val in pairs(script.Textures:GetChildren()) do
                val:Clone().Parent = descendant
            end
        end
    end
end

function t._Init(arg3) -- line: 42
    task.spawn(arg3._Recolor, arg3)
end

return t
