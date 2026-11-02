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
    t_1._started = 0
    t_1._clouds = {}
    t_1._slow_clouds = {}
    t_1._rain_1 = {}
    t_1._rain_2 = {}
    t_1._moon_glow = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 27
    arg1._started += arg2
    local Started = arg1._started
    local v2 = -Started / 10
    local v3 = Started / 1.5
    local v4 = Started * 1.5

    for _, val in arg1._clouds do
        val.OffsetStudsU = v2 / 2 % val.StudsPerTileU
    end

    for _, val_1 in arg1._slow_clouds do
        val_1.OffsetStudsU = v2 / 3.141592653589793 % val_1.StudsPerTileU
    end

    for _, val_2 in arg1._rain_1 do
        val_2.OffsetStudsU = val_2.StudsPerTileU - v3 % val_2.StudsPerTileU
        val_2.OffsetStudsV = val_2.StudsPerTileV - v3 * 2 % val_2.StudsPerTileV
    end

    for _, val_3 in arg1._rain_2 do
        val_3.OffsetStudsU = v3 % val_3.StudsPerTileU
        val_3.OffsetStudsV = val_3.StudsPerTileV - v3 * 2 % val_3.StudsPerTileV
    end

    local v5 = math.sin(v4 * 2) / 2 + 0.5

    for _, val_4 in arg1._moon_glow do
        val_4.Transparency = math.lerp(0.482, 0.262, v5)
    end
end

function t._Setup(arg3) -- line: 64
    for _, val_5 in pairs(arg3.ExtraObjects) do
        if val_5:IsA("Texture") and val_5.Name == "Clouds" then
            table.insert(arg3._clouds, val_5)
        elseif val_5:IsA("Texture") and val_5.Name == "SlowClouds" then
            table.insert(arg3._slow_clouds, val_5)
        elseif val_5:IsA("Texture") and val_5.Name == "Rain1" then
            table.insert(arg3._rain_1, val_5)
        elseif val_5:IsA("Texture") and val_5.Name == "Rain2" then
            table.insert(arg3._rain_2, val_5)
        elseif val_5:IsA("Texture") and val_5.Name == "MoonGlow" then
            table.insert(arg3._moon_glow, val_5)
        end
    end
end

function t._Init(arg4) -- line: 80
    arg4:_Setup()
end

return t
