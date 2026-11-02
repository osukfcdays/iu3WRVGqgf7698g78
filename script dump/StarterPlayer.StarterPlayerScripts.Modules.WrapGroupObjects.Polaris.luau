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
    t_1._fire1 = {}
    t_1._fire2 = {}
    t_1._beams = {}
    t_1._sparks = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 25
    local v2 = workspace:GetServerTimeNow() / 4
    local clampedValue = math.clamp(math.sin(v2 * 12) / 3 + 0.5, 0, 1)
    local clampedValue_1 = math.clamp(math.sin((v2 + 3.5342917352885173) * 12) / 3 + 0.5, 0, 1)

    for _, val in pairs(arg1._fire1) do
        val.Transparency = clampedValue
    end

    for _, val_1 in pairs(arg1._fire2) do
        val_1.Transparency = clampedValue_1
    end

    for _, val_2 in pairs(arg1._beams) do
        val_2.Transparency = math.sin(v2 * 6) / 10 + 0.8
    end

    for _, val_3 in pairs(arg1._sparks) do
        val_3.OffsetStudsU = v2 / 4 % val_3.StudsPerTileU + math.sin(v2 * 9) / 64
        val_3.OffsetStudsV = v2 / 2 % val_3.StudsPerTileV
        val_3.Transparency = math.sin(v2 * 8) / 10 + 0.2
    end
end

function t._Setup(arg3) -- line: 53
    for _, val_4 in pairs(arg3.ExtraObjects) do
        if val_4.Name == "Fire1" then
            table.insert(arg3._fire1, val_4)
        elseif val_4.Name == "Fire2" then
            table.insert(arg3._fire1, val_4)
        elseif val_4.Name == "Beam" then
            table.insert(arg3._beams, val_4)
        elseif val_4.Name == "Sparks1" then
            table.insert(arg3._sparks, val_4)
        end
    end
end

function t._Init(arg4) -- line: 67
    arg4:_Setup()
end

return t
