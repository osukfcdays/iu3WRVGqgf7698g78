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
    t_1._gradient1 = {}
    t_1._gradient2 = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 23
    local v2 = workspace:GetServerTimeNow() / 4

    for _, val in pairs(arg1._gradient1) do
        local v3 = v2 / 2.5 % val.StudsPerTileU
        v3 = if val.Face == Enum.NormalId.Top then -v3 else if val.Face ~= Enum.NormalId.Front then v3 else -v3
        val.OffsetStudsU = v3
        val.OffsetStudsV = math.sin(v2 * 4) / 14
    end
end

function t._Setup(arg3) -- line: 42
    for _, val_1 in pairs(arg3.ExtraObjects) do
        if val_1.Name == "Gradient" then
            table.insert(arg3._gradient1, val_1)
        elseif val_1.Name == "Gradient2" then
            table.insert(arg3._gradient2, val_1)
        end
    end
end

function t._Init(arg4) -- line: 52
    arg4:_Setup()
end

return t
