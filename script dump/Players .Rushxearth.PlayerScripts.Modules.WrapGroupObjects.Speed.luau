local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._moving_textures = {}
    t_1._shift = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 26
    arg1._shift = (arg1._shift + arg2 * (math.sin(tick() * 1) ^ 20 * 0.75 + 0.25)) % 0.2

    for key, val in pairs(arg1._moving_textures) do
        key.OffsetStudsU = arg1._shift * val
    end
end

function t._Setup(arg3) -- line: 40
    for _, val_1 in pairs(arg3.ExtraObjects) do
        local MovingTextures = arg3._moving_textures
        local v2 = if val_1.Name ~= "Left" then -1 else 1
        MovingTextures[val_1] = v2
    end
end

function t._Init(arg4) -- line: 46
    arg4:_Setup()
end

return t
