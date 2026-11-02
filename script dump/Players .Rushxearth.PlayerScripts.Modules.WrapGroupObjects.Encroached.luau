local TweenService = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local tweenInfo = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._glyphs = { {}, {} }
    t_1._elapsed = 0
    t_1._elapsed2 = 0
    t_1._number_value = Instance.new("NumberValue")
    t_1._jitter_u = 0
    t_1._jitter_v = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 30
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] tweenInfo (copy)

    arg1._elapsed += arg2 / 5
    arg1._elapsed2 += arg2

    if arg1._elapsed2 >= 2 then
        arg1._elapsed2 = 0
        arg1._number_value.Value = 0.05
        local v2 = TweenService:Create(arg1._number_value, tweenInfo, { Value = 0 })
        v2:Play()
        table.insert(arg1._tweens, v2)
    end

    for _, val in pairs(arg1._glyphs[1]) do
        val.OffsetStudsU = -(arg1._elapsed % val.StudsPerTileU) + arg1._jitter_u
        val.OffsetStudsV = -(arg1._elapsed % val.StudsPerTileV) + arg1._jitter_v
        val.Transparency = 0.55 + arg1._number_value.Value * 2
    end

    for _, val_1 in pairs(arg1._glyphs[2]) do
        val_1.OffsetStudsU = arg1._elapsed % val_1.StudsPerTileU + arg1._jitter_u
        val_1.OffsetStudsV = arg1._elapsed % val_1.StudsPerTileV + arg1._jitter_v
        val_1.Transparency = 0.55 + arg1._number_value.Value * 2
    end
end

function t.Destroy(arg3) -- line: 55
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)

    arg3._number_value:Destroy()
    WrapGroupObject_m.Destroy(arg3)
end

function t._Setup(arg4) -- line: 64
    for _, val_2 in pairs(arg4.ExtraObjects) do
        if val_2.Name == "Glyphs1" then
            table.insert(arg4._glyphs[1], val_2)
        elseif val_2.Name == "Glyphs2" then
            table.insert(arg4._glyphs[2], val_2)
        end
    end
end

function t._Init(arg5) -- line: 74
    arg5._number_value:GetPropertyChangedSignal("Value"):Connect(function() -- line: 75
        -- upvalues:
        --  [1] arg5 (copy)

        arg5._jitter_u = Random.new():NextNumber(
            -arg5._number_value.Value,
            arg5._number_value.Value
        )
        arg5._jitter_v = Random.new():NextNumber(
            -arg5._number_value.Value,
            arg5._number_value.Value
        )
    end)
    arg5:_Setup()
end

return t
