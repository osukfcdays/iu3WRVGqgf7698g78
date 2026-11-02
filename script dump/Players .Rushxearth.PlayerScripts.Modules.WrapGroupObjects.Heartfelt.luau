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
    t_1._hearts1 = {}
    t_1._hearts2 = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 23
    local v2 = workspace:GetServerTimeNow() / 4

    for _, val in pairs(arg1._hearts1) do
        val.OffsetStudsV = v2 % val.StudsPerTileV
        val.OffsetStudsU = v2 / 3 % val.StudsPerTileU
    end

    for _, val_1 in pairs(arg1._hearts2) do
        val_1.OffsetStudsV = v2 / 2.5 % val_1.StudsPerTileV
        val_1.OffsetStudsU = v2 / 7 % val_1.StudsPerTileU
    end
end

function t._Setup(arg3) -- line: 41
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "Hearts" then
            table.insert(arg3._hearts1, val_2)
        elseif val_2.Name == "Hearts2" then
            table.insert(arg3._hearts2, val_2)
        end
    end
end

function t._Init(arg4) -- line: 51
    arg4:_Setup()
end

return t
