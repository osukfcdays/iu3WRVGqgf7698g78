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
    t_1._clouds1 = {}
    t_1._clouds2 = {}
    t_1._snow1 = {}
    t_1._snow2 = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 25
    local serverTimestamp = workspace:GetServerTimeNow()

    for _, val in pairs(arg1._clouds1) do
        val.OffsetStudsU = val.StudsPerTileU - serverTimestamp / 2 % val.StudsPerTileU
        val.OffsetStudsV = val.StudsPerTileV - serverTimestamp % val.StudsPerTileV
    end

    for _, val_1 in pairs(arg1._clouds2) do
        val_1.OffsetStudsU = serverTimestamp / 2 % val_1.StudsPerTileU
        val_1.OffsetStudsV = val_1.StudsPerTileV - serverTimestamp % val_1.StudsPerTileV
    end

    for _, val_2 in pairs(arg1._snow1) do
        val_2.OffsetStudsU = val_2.StudsPerTileU - serverTimestamp % val_2.StudsPerTileU
        val_2.OffsetStudsV = val_2.StudsPerTileV - serverTimestamp / 2 % val_2.StudsPerTileV
    end

    for _, val_3 in pairs(arg1._snow2) do
        val_3.OffsetStudsU = serverTimestamp % val_3.StudsPerTileU
        val_3.OffsetStudsV = val_3.StudsPerTileV - serverTimestamp / 2 % val_3.StudsPerTileV
    end
end

function t._Setup(arg3) -- line: 53
    for _, val_4 in pairs(arg3.ExtraObjects) do
        if val_4.Name == "Clouds1" then
            table.insert(arg3._clouds1, val_4)
        elseif val_4.Name == "Clouds2" then
            table.insert(arg3._clouds2, val_4)
        elseif val_4.Name == "Snow1" then
            table.insert(arg3._snow1, val_4)
        elseif val_4.Name == "Snow2" then
            table.insert(arg3._snow2, val_4)
        end
    end
end

function t._Init(arg4) -- line: 67
    arg4:_Setup()
end

return t
