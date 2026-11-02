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
    t_1._moving_textures = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 27
    for key, val in pairs(arg1._moving_textures) do
        local v2 = (tick() * 0.01 + val) % 1
        local v3 = 0.05 + 1.075 * v2 ^ 2
        key.Transparency = math.sin(3.141592653589793 * v2 - 1.5707963267948966) ^ 20 * 0.75 + 0.25
        key.StudsPerTileU = v3
        key.StudsPerTileV = v3
    end
end

function t._Setup(arg3) -- line: 43
    for _, val_1 in pairs(arg3.ExtraObjects) do
        local MovingTextures = arg3._moving_textures
        local v4 = if val_1.Name ~= "Big" then 0 else 0.5
        MovingTextures[val_1] = v4
    end
end

function t._Init(arg4) -- line: 49
    arg4:_Setup()
end

return t
