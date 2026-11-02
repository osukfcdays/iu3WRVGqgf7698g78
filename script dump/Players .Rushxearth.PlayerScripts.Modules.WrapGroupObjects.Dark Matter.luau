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
    t_1._moving_textures = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 22
    for key, val in pairs(arg1._moving_textures) do
        key.OffsetStudsU = tick() * val.Speed * val.Direction.X % key.StudsPerTileU
        key.OffsetStudsV = tick() * val.Speed * val.Direction.Y % key.StudsPerTileV
    end
end

function t._Setup(arg3) -- line: 33
    for _, val_1 in pairs(arg3.ExtraObjects) do
        local Speed = val_1:GetAttribute("Speed")
        local Direction = val_1:GetAttribute("Direction")

        if Speed and Direction then
            arg3._moving_textures[val_1] = { Speed = Speed, Direction = Direction }
        end
    end
end

function t._Init(arg4) -- line: 46
    arg4:_Setup()
end

return t
