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
    t_1._shatter1 = {}
    t_1._shatter2 = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 28
    local v2 = math.sin(workspace:GetServerTimeNow() * 1.5) / 7 + 0.75
    local _ = workspace:GetServerTimeNow() * 1.5

    for _, val in pairs(arg1._shatter1) do
        val.StudsPerTileU = v2 + 1.574 + Random.new():NextNumber(-0.02, 0.02)
        val.StudsPerTileV = v2 + 1.574 + Random.new():NextNumber(-0.02, 0.02)
    end

    for _, val_1 in pairs(arg1._shatter2) do
        val_1.StudsPerTileU = v2 / 1.75 + 2.5 + Random.new():NextNumber(-0.01, 0.01)
        val_1.StudsPerTileV = v2 / 1.75 + 2.5 + Random.new():NextNumber(-0.01, 0.01)
    end
end

function t._Setup(arg3) -- line: 46
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "Shatter" then
            table.insert(arg3._shatter1, val_2)
        elseif val_2.Name == "Shatter2" then
            table.insert(arg3._shatter2, val_2)
        end
    end
end

function t._Init(arg4) -- line: 56
    arg4:_Setup()
end

return t
