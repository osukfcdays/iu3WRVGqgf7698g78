local BaseSpear_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseSpear
)
local t = setmetatable({}, BaseSpear_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseSpear_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseSpear_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Setup(arg1) -- line: 26
    for index = 1, math.huge do
        local Body = arg1.ItemModel:WaitForChild("Body"):FindFirstChild("MeshPart" .. index)

        if not Body then
            break
        end

        arg1:_RegisterAmmoVisual(Body, 1)
    end
end

function t._Init(arg2) -- line: 38
    arg2:_Setup()
end

return t
