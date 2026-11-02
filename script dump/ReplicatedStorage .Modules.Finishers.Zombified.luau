local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local t = { Color = Color3.fromRGB(45, 117, 0) }
local t_1 = {
    "rbxassetid://76551122205423",
    "rbxassetid://121329175458153",
    "rbxassetid://86178802108357"
}
local t_2 = setmetatable({}, Ragdoll_m)
t_2.__index = t_2

function t_2.new(...) -- line: 14
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t_2 (copy)

    local t_3 = setmetatable(Ragdoll_m.new(...), t_2)
    t_3:_Init()

    return t_3
end

function t_2.PlayServer(arg1, ...) -- line: 26
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    v2.Anchored = true
    wait(9.9)
    v2.Anchored = false
    Ragdoll_m.PlayServer(arg1, ...)
end

function t_2.PlayClient(arg2) -- line: 38
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] tweenInfo (copy)
    --  [3] t (copy)
    --  [4] Utility_m (copy)
    --  [5] t_1 (copy)

    for _, val in pairs(arg2:_GetObjects()) do
        if val:IsA("BasePart") then
            TweenService:Create(val, tweenInfo, t):Play()
        end
    end

    if arg2._is_humanoid then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://84937348544434"
        local Success, v4 = pcall(arg2._subject.LoadAnimation, arg2._subject, Animation)

        if Success then
            v4:Play(0)
        end
    end

    arg2:CreateSound(
        "rbxassetid://113907213192044",
        1.5,
        1,
        nil,
        true,
        15
    )
    arg2:CreateSound(
        "rbxassetid://103180063975943",
        0.25,
        0.5 + 0.1 * math.random(),
        nil,
        true,
        15
    )
    arg2:CreateSound(
        "rbxassetid://84523504613156",
        1,
        1,
        nil,
        true,
        15
    )
    wait(0.8)
    arg2:CreateSound(
        "rbxassetid://99312045046993",
        1,
        1,
        nil,
        true,
        15
    )
    wait(0.8)
    arg2:CreateSound(
        "rbxassetid://109142509049932",
        1,
        1,
        nil,
        true,
        15
    )
    wait(2.4)
    local v6 = Utility_m:CloneTable(t_1)

    for _ = 1, #t_1 do
        arg2:CreateSound(
            table.remove(v6, math.random(#v6)),
            0.5,
            0.5 + 0.1 * math.random(),
            nil,
            true,
            5
        )
        wait(5.7 / #t_1)
    end

    arg2:CreateSound(
        "rbxassetid://126800102156089",
        0.5,
        0.75,
        nil,
        true,
        5
    )
end

function t_2._Init(_) -- line: 87
end

return t_2
