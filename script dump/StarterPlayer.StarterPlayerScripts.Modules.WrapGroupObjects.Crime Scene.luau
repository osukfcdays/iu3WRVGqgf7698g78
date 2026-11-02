local TweenService = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local tweenInfo = TweenInfo.new(
    1,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.InOut,
    -1,
    true
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._tape1 = {}
    t_1._tape2 = {}
    t_1._glowred = {}
    t_1._glowblue = {}
    t_1._vfx = {}
    t_1._elapsed = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 30
    arg1._elapsed += arg2
    local serverTimestamp = workspace:GetServerTimeNow()

    for _, val in pairs(arg1._tape1) do
        local v2 = serverTimestamp / 5
        val.OffsetStudsU, val.OffsetStudsV = -(v2 % val.StudsPerTileU), v2 % val.StudsPerTileV
    end

    for _, val_1 in pairs(arg1._tape2) do
        local v3 = serverTimestamp / 5
        val_1.OffsetStudsU, val_1.OffsetStudsV = v3 % val_1.StudsPerTileU + 0.5, v3 % val_1.StudsPerTileV
    end

    for _, val_2 in pairs(arg1._vfx) do
        local v4 = arg1._elapsed % 2
        local v5 = v4
        v5 = if not (v5 > 1) then v5 else 2 - v4
        val_2.Color = ColorSequence.new(
            Color3.fromRGB(50, 62, 255):Lerp(Color3.fromRGB(255, 47, 47), v5)
        )
    end
end

function t._Setup(arg3) -- line: 66
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] tweenInfo (copy)

    for _, val_3 in pairs(arg3.ExtraObjects) do
        if val_3.Name == "PoliceTape1" then
            table.insert(arg3._tape1, val_3)
        elseif val_3.Name == "PoliceTape2" then
            table.insert(arg3._tape2, val_3)
        elseif val_3.Name == "GlowRed" then
            table.insert(arg3._glowred, val_3)
        elseif val_3.Name == "GlowBlue" then
            table.insert(arg3._glowblue, val_3)
        elseif val_3:IsA("ParticleEmitter") or val_3:IsA("Beam") or val_3:IsA("Trail") then
            table.insert(arg3._vfx, val_3)
        end
    end

    if arg3.Object:IsA("ParticleEmitter") or arg3.Object:IsA("Beam") or arg3.Object:IsA("Trail") then
        table.insert(arg3._vfx, arg3.Object)
    end

    arg3._elapsed = workspace:GetServerTimeNow()

    for _, val_4 in pairs(arg3._glowred) do
        local v8 = TweenService:Create(val_4, tweenInfo, { Color3 = Color3.fromRGB(50, 62, 225) })
        v8:Play()
        table.insert(arg3._tweens, v8)
    end

    for _, val_5 in pairs(arg3._glowblue) do
        local v11 = TweenService:Create(val_5, tweenInfo, { Color3 = Color3.fromRGB(225, 47, 47) })
        v11:Play()
        table.insert(arg3._tweens, v11)
    end
end

function t._Init(arg4) -- line: 102
    arg4:_Setup()
end

return t
