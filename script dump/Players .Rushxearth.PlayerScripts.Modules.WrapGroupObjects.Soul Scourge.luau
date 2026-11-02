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
    t_1._textures1 = {}
    t_1._textures2 = {}
    t_1._random = Random.new()
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 29
    local v2 = workspace:GetServerTimeNow() / 4

    for _, val in pairs(arg1._textures1) do
        val.OffsetStudsV = v2 % 0.6
        val.OffsetStudsU = math.sin(v2 * 10) / 14 + arg1._random:NextNumber(-0.01, 0.01)
    end

    for _, val_1 in pairs(arg1._textures2) do
        val_1.OffsetStudsU = v2 % 0.7
        val_1.OffsetStudsV = v2 % 0.5
    end
end

function t._Setup(arg3) -- line: 47
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "Souls" then
            table.insert(arg3._textures1, val_2)
        elseif val_2.Name == "Clouds2" then
            table.insert(arg3._textures2, val_2)
        end
    end
end

function t._Init(arg4) -- line: 57
    arg4:_Setup()
end

return t
