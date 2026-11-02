local TweenService = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local color = Color3.fromRGB(134, 255, 180)
local color_1 = Color3.fromRGB(89, 171, 123)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._started = 0
    t_1._lightnings = {}
    t_1._fade_parts = {}
    t_1._gradient = {}
    t_1._gradient_2 = {}
    t_1._next_strike = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 32
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] tweenInfo (copy)
    --  [3] color (copy)
    --  [4] color_1 (copy)

    arg1._started += arg2
    local Started = arg1._started
    local v2

    for _, val in arg1._gradient do
        v2 = Started / 2.25 % val.StudsPerTileU
        v2 = if val.Face == Enum.NormalId.Top then -v2 else if val.Face ~= Enum.NormalId.Front then v2 else -v2
        val.OffsetStudsU = v2
    end

    for _, val_1 in arg1._gradient_2 do
        v2 = -(Started / 2.25) % val_1.StudsPerTileU
        v2 = if val_1.Face == Enum.NormalId.Top then -v2 else if val_1.Face ~= Enum.NormalId.Front then v2 else -v2
        val_1.OffsetStudsU = v2
    end

    if Started < arg1._next_strike then
        return
    end

    arg1._next_strike = Started + Random.new():NextNumber(0.6, 1.7)

    for _, val_2 in arg1._lightnings do
        val_2.Transparency = 0.01
        local v3 = TweenService:Create(val_2, tweenInfo, { Transparency = 1 })
        v3:Play()
        table.insert(arg1._tweens, v3)
    end

    for _, val_3 in arg1._fade_parts do
        val_3.Color = color
        local v4 = TweenService:Create(val_3, tweenInfo, { Color = color_1 })
        v4:Play()
        table.insert(arg1._tweens, v4)
    end
end

function t._Setup(arg3) -- line: 76
    if
        arg3.Object:IsA("BasePart")
        and arg3.Object:FindFirstChild("Lightning")
        and arg3.Object:FindFirstChild("Gradient2")
    then
        table.insert(arg3._fade_parts, arg3.Object)
    end

    for _, val_4 in pairs(arg3.ExtraObjects) do
        if val_4.Name == "Lightning" then
            table.insert(arg3._lightnings, val_4)
        elseif val_4:IsA("Texture") and val_4.Name == "Gradient" then
            table.insert(arg3._gradient, val_4)
        elseif val_4:IsA("Texture") and val_4.Name == "Gradient2" then
            table.insert(arg3._gradient_2, val_4)
        end
    end
end

function t._Init(arg4) -- line: 91
    arg4:_Setup()
end

return t
