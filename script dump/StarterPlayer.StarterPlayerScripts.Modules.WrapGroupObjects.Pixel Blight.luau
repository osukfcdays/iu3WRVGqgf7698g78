local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Brighten(_, arg2) -- line: 26
    local v2, v3, v4 = arg2:ToHSV()

    return v4 < (if v3 > 0.5 then 0.1 else 0.35) and arg2 or Color3.fromHSV(
        v2,
        v3,
        (math.max(0.75, v4))
    )
end

function t._Setup(arg3) -- line: 33
    if arg3.Object:IsA("BasePart") then
        arg3.Object.Color = arg3:_Brighten(arg3.Object.Color)

        return
    end

    if arg3.Object:IsA("Beam") or arg3.Object:IsA("Trail") or arg3.Object:IsA("ParticleEmitter") then
        local t_2 = {}

        for _, val in pairs(arg3.Object.Color.Keypoints) do
            table.insert(t_2, ColorSequenceKeypoint.new(val.Time, arg3:_Brighten(val.Value)))
        end

        arg3.Object.Color = ColorSequence.new(t_2)
    end
end

function t._Init(arg4) -- line: 47
    arg4:_Setup()
end

return t
