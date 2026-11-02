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
    t_1._textures1 = {}
    t_1._textures2 = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 23
    local v2 = workspace:GetServerTimeNow() / 8
    local clampedValue = math.clamp(math.sin(v2 * 24) / 2 + 0.25, 0, 1)
    local clampedValue_1 = math.clamp(math.sin((v2 + 3.5342917352885173) * 24) / 2 + 0.25, 0, 1)
    local v3 = (math.sin(v2) + 4) / 2

    for _, val in pairs(arg1._textures1) do
        val.StudsPerTileU = v3
        val.StudsPerTileV = v3
        val.Transparency = clampedValue
    end

    for _, val_1 in pairs(arg1._textures2) do
        val_1.StudsPerTileU = v3
        val_1.StudsPerTileV = v3
        val_1.Transparency = clampedValue_1
    end
end

function t._Setup(arg3) -- line: 46
    for _, val_2 in pairs(arg3.ExtraObjects) do
        if val_2.Name == "RedStars" or val_2.Name == "BlueStars2" then
            table.insert(arg3._textures1, val_2)
        elseif val_2.Name == "BlueStars" or val_2.Name == "RedStars2" then
            table.insert(arg3._textures2, val_2)
        end
    end
end

function t._Init(arg4) -- line: 56
    arg4:_Setup()
end

return t
