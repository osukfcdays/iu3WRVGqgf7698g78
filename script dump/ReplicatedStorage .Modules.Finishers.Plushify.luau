local Ragdoll_m = require(game:GetService("ReplicatedStorage").Modules.Finishers.Ragdoll)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)

    if not arg1._is_humanoid then
        return
    end

    arg1._subject.Parent:ScaleTo(arg1._subject.Parent:GetScale() * 0.75)
    local v3 = arg1._is_humanoid

    if v3 then
        v3 = arg1._subject.Parent:FindFirstChild("Head")
    end

    if not v3 then
        return
    end

    v3.Size *= 2
    local v4 = pairs
    local _ = arg1._subject.Parent:GetScale()

    for _, val in v4(v3.Parent:GetChildren()) do
        if val:IsA("Accessory") then
            for _, val_1 in pairs(val:GetChildren()) do
                if val_1:IsA("BasePart") then
                    val_1.Size *= 2
                end
            end
        end
    end
end

function t.PlayClient(arg2, ...) -- line: 55
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    arg2:CreateSound(
        "rbxassetid://83739663458999",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 64
end

return t
