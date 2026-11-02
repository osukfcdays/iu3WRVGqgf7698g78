local BaseRevolver_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRevolver
)
local t = setmetatable({}, BaseRevolver_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseRevolver_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRevolver_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Setup(arg1) -- line: 26
    for _, val in pairs({ "ReloadBullets", "Bullets" }) do
        local v2 = arg1.ItemModel:WaitForChild(val)

        for index = 1, 6 do
            local v3 = v2:WaitForChild(index)
            arg1:_RegisterAmmoVisual(val, v3:WaitForChild("Red"))
            arg1:_RegisterAmmoVisual(val, v3:WaitForChild("White"))
        end
    end
end

function t._Init(arg2) -- line: 39
    arg2:_Setup()
end

return t
