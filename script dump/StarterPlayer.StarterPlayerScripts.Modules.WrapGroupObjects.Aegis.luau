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
    t_1._sparkles1 = {}
    t_1._sparkles2 = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 23
    local v2 = workspace:GetServerTimeNow() / 4
    local clampedValue = math.clamp(math.sin(v2 * 24) / 3 + 0.5, 0, 1)
    local clampedValue_1 = math.clamp(math.sin((v2 + 3.5342917352885173) * 24) / 3 + 0.5, 0, 1)

    for _, val in pairs(arg1._sparkles1) do
        val.OffsetStudsV = v2 % val.StudsPerTileV
        val.Transparency = clampedValue
    end

    for _, val_1 in pairs(arg1._sparkles2) do
        val_1.OffsetStudsV = v2 % val_1.StudsPerTileV
        val_1.Transparency = clampedValue_1
    end
end

function t._Setup(arg3) -- line: 43
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "Sparkles" then
            table.insert(arg3._sparkles1, val_2)
        elseif val_2.Name == "Sparkles2" then
            table.insert(arg3._sparkles2, val_2)
        end
    end
end

function t._Init(arg4) -- line: 53
    arg4:_Setup()
end

return t
