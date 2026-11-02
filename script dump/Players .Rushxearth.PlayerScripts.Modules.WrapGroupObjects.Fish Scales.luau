local _ = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.Update(_, _) -- line: 21
end

function t._Evaluate(_, arg4) -- line: 29
    local floorValue_1 = math.floor(DateTime.now().UnixTimestamp / 86400)
    local v3 = Random.new(floorValue_1):NextNumber(0, 0.92)

    if arg4:IsA("BasePart") then
        local _, v5, v6 = arg4.Color:ToHSV()
        arg4.Color = Color3.fromHSV(v3, v5, v6)

        return
    end

    if arg4:IsA("ParticleEmitter") or arg4:IsA("Beam") or arg4:IsA("Trail") then
        local _, v10, v11 = arg4.Color.Keypoints[1].Value:ToHSV()
        arg4.Color = ColorSequence.new((Color3.fromHSV(v3, v10, v11)))

        return
    end

    if arg4:IsA("RopeConstraint") or arg4:IsA("RodConstraint") then
        local _, v16, v17 = arg4.Color.Color:ToHSV()
        arg4.Color = BrickColor.new((Color3.fromHSV(v3, v16, v17)))
    end
end

function t._Setup(arg5) -- line: 48
    arg5:_Evaluate(arg5.Object)

    for _, val in arg5.ExtraObjects do
        arg5:_Evaluate(val)
    end
end

function t._Init(arg6) -- line: 55
    arg6:_Setup()
end

return t
