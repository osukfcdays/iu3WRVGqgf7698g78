local _ = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._gradient1 = {}
    t_1._gradient2 = {}
    t_1._solid = {}
    t_1._vfx = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 30
    local v2 = workspace:GetServerTimeNow() / 2
    local v3 = v2 / 4
    local v4 = (v3 - 0.1) % 1
    local v5 = (v3 + 0.1) % 1

    for _, val in pairs(arg1._gradient1) do
        val.OffsetStudsU = v2 % val.StudsPerTileU
    end

    for _, val_1 in pairs(arg1._gradient2) do
        val_1.OffsetStudsU = -(v2 % val_1.StudsPerTileU)
    end

    for _, val_2 in pairs(arg1._solid) do
        local color = Color3.fromHSV((v3 + val_2:GetAttribute("Offset")) % 1, 1, 1)
        val_2.Color3 = Color3.fromRGB(
            color.R * 255 * 1.5686274509803921,
            color.G * 255 * 1.5686274509803921,
            color.B * 255 * 1.5686274509803921
        )
    end

    for _, val_3 in pairs(arg1._vfx) do
        local t_2 = {}
        local New = ColorSequence.new
        t_2[1] = ColorSequenceKeypoint.new(0, Color3.fromHSV(v4, 1, 1))
        t_2[2] = ColorSequenceKeypoint.new(1, Color3.fromHSV(v5, 1, 1))
        val_3.Color = New(t_2)
    end
end

function t._GetOffset(_, arg4) -- line: 66
    local Size = arg4.Parent.Size

    return (Vector3.FromNormalId(arg4.Face) * Size).Magnitude / 4 / 2
end

function t._Setup(arg5) -- line: 76
    for _, val_4 in pairs(arg5.ExtraObjects) do
        if val_4.Name == "Gradient1" then
            table.insert(arg5._gradient1, val_4)
        elseif val_4.Name == "Gradient2" then
            table.insert(arg5._gradient2, val_4)
        elseif val_4.Name == "SolidBack" or val_4.Name == "SolidFront" then
            val_4:SetAttribute("Offset", arg5:_GetOffset(val_4))
            table.insert(arg5._solid, val_4)
        end
    end

    if arg5.Object:IsA("ParticleEmitter") or arg5.Object:IsA("Beam") or arg5.Object:IsA("Trail") then
        table.insert(arg5._vfx, arg5.Object)
    end
end

function t._Init(arg6) -- line: 93
    arg6:_Setup()
end

return t
