local BattleAxe_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Battle Axe"]
)
local t = setmetatable({}, BattleAxe_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BattleAxe_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BattleAxe_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Setup(arg1) -- line: 26
    local randomValue = math.random(1, 3)

    for index = 1, 3 do
        if index ~= randomValue then
            local v2 = arg1.ItemModel.Body["Sign" .. index]
            task.defer(v2.Destroy, v2)
        end
    end
end

function t._Init(arg2) -- line: 37
    arg2:_Setup()
end

return t
