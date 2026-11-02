local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._last_remainder = nil
    t_1._textures = { {}, {}, {} }
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 25
    local v2 = math.floor(tick() * 1) % #arg1._textures + 1

    if v2 == arg1._last_remainder then
        return
    end

    arg1._last_remainder = v2

    for key, val in pairs(arg1._textures) do
        v2 = if key ~= arg1._last_remainder then 1 else 0

        for _, val_1 in pairs(val) do
            val_1.Transparency = v2
        end
    end
end

function t._Setup(arg3) -- line: 47
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "SolidRed" or val_2.Name == "RedLightsInner" then
            table.insert(arg3._textures[1], val_2)
        elseif val_2.Name == "SolidYellow" or val_2.Name == "YellowLightsInner" then
            table.insert(arg3._textures[2], val_2)
        elseif val_2.Name == "SolidGreen" or val_2.Name == "GreenLightsInner" then
            table.insert(arg3._textures[3], val_2)
        end
    end
end

function t._Init(arg4) -- line: 59
    arg4:_Setup()
end

return t
