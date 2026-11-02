local v1 = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local _ = game:GetService("HttpService")
local _ = game:GetService("Lighting")
local Players = game:GetService("Players")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local Ragdoll_m = require(v1.Modules.Finishers.Ragdoll)
local Utility_m = require(v1.Modules.Utility)
v1 = CONSTANTS_m.IS_CLIENT

if v1 then
    v1 = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
end

local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, arg2) -- line: 27
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] v1 (copy)
    --  [3] Utility_m (copy)
    --  [4] TweenService (copy)

    Ragdoll_m.PlayClient(arg1, arg2)

    if not arg2 then
        local v3 = v1:GetFighter(arg1._eliminator)

        if not v3 or not v3:Get("IsSpectating") then
            return
        end
    end

    arg1:CreateSound(
        "rbxassetid://127879822444105",
        1.25,
        0.95 + 0.1 * math.random(),
        script,
        true,
        10
    )
    arg1:CreateSound(
        "rbxassetid://118355855043527",
        0.875,
        0.98 + 0.04 * math.random(),
        script,
        true,
        10
    )
    local v6 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local Part = Instance.new("Part")
    Part.CFrame = CFrame.new(v6.Position)
    Part.Size = Vector3.new(1, 1, 1)
    Part.Transparency = 1
    Part.CastShadow = false
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Anchored = true
    Part.Parent = v6
    table.insert(arg1._destroy_these, Part)
    local v6 = math.random() < 0.5 and true
    local v7 = script.BillboardGui:Clone()
    v7.Value.Text = if v6 then "NAUGHTY." else "NICE!"
    local Value_1 = v7.Value
    Value_1.TextColor3 = v6 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 50)
    local UIStroke = v7.Value.UIStroke
    UIStroke.Color = v6 and Color3.fromRGB(127, 25, 25) or Color3.fromRGB(50, 127, 25)
    v7.Value.UIStroke.Transparency = 0
    v7.Parent = Part
    table.insert(arg1._destroy_these, v7)
    local Value_2 = v7.Value
    local v9 = if v6 then 1 else -1
    Utility_m:RenderstepForLoop(0, 100, 3, function(arg3) -- line: 66
        -- upvalues:
        --  [1] TweenService (ref)
        --  [2] Value_2 (copy)
        --  [3] v9 (copy)

        local v10 = arg3 / 100
        local v11 = TweenService:GetValue(v10, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        local v12 = TweenService:GetValue(v10, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local v13 = 1 - 0.5 * v12
        Value_2.Position = UDim2.new(0.5 + 0.125 * v11 * v9, 0, 0.5 + 0.125 * v12, 0)
        Value_2.Size = UDim2.new(1 * v13, 0, 0.075 * v13, 0)
        Value_2.Rotation = v10 ^ 4 * 260 * v9
    end)
    v7:Destroy()
end

function t._Init(_) -- line: 84
end

return t
