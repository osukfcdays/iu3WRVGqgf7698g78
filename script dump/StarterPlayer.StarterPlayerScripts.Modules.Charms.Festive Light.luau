local Charm_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.Charm)
local t = { Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 176, 0), Color3.fromRGB(0, 255, 0) }
local t_1 = setmetatable({}, Charm_m)
t_1.__index = t_1

function t_1.new(...) -- line: 11
    -- upvalues:
    --  [1] Charm_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Charm_m.new(...), t_1)
    t_2._light_color_index = 0
    t_2._light_part = t_2.Model:WaitForChild("Extra"):WaitForChild("Light")
    t_2:_Init()

    return t_2
end

function t_1.Update(arg1, arg2) -- line: 26
    -- upvalues:
    --  [1] Charm_m (copy)
    --  [2] t (copy)

    Charm_m.Update(arg1, arg2)
    local v2 = math.floor(tick() * 1) % #t

    if v2 == arg1._light_color_index then
        return
    end

    arg1._light_color_index = v2
    arg1._light_part.Color = t[arg1._light_color_index + 1]
end

function t_1._Init(_) -- line: 43
end

return t_1
