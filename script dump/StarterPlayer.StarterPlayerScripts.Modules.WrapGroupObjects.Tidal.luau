local _ = game:GetService("TweenService")
local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._waves = {}
    t_1._waves_foam = {}
    t_1._waves_shade1 = {}
    t_1._waves_shade2 = {}
    t_1._caustics1 = {}
    t_1._caustics2 = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 28
    -- upvalues:
    --  [1] t (copy)

    local serverTimestamp = workspace:GetServerTimeNow()
    local v2 = serverTimestamp / 7.5
    local clampedValue = math.clamp(math.sin(v2 * 24) / 3 + 0.5, 0, 1)
    local clampedValue_1 = math.clamp(math.sin((v2 + 3.5342917352885173) * 24) / 3 + 0.5, 0, 1)

    for _, val in pairs(arg1._waves) do
        t:_MoveTexture(
            val,
            0,
            0,
            0,
            serverTimestamp
        )
    end

    for _, val_1 in pairs(arg1._waves_foam) do
        t:_MoveTexture(
            val_1,
            0,
            0,
            0.05,
            serverTimestamp
        )
    end

    for _, val_2 in pairs(arg1._waves_shade1) do
        t:_MoveTexture(
            val_2,
            0.01,
            0.6,
            0,
            serverTimestamp
        )
    end

    for _, val_3 in pairs(arg1._waves_shade2) do
        t:_MoveTexture(
            val_3,
            0.035,
            0.9,
            0,
            serverTimestamp
        )
    end

    for _, val_4 in pairs(arg1._caustics1) do
        val_4.Transparency = clampedValue
    end

    for _, val_5 in pairs(arg1._caustics2) do
        val_5.Transparency = clampedValue_1
    end
end

function t._MoveTexture(
    _,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8
) -- line: 64
    arg7 -= 0.1
    local v3 = arg8 / 1.5
    local StudsPerTileV = arg4.StudsPerTileV
    arg4.OffsetStudsU = -(v3 / 10 - arg5) % arg4.StudsPerTileU
    arg4.OffsetStudsV = (math.sin(v3 - arg6) / 6 + 0.2) % StudsPerTileV + arg7
end

function t._Setup(arg9) -- line: 75
    for _, val_6 in pairs(arg9.ExtraObjects) do
        if val_6.Name == "Waves" or val_6.Name == "WavesCaustics" then
            table.insert(arg9._waves, val_6)
        elseif val_6.Name == "WavesFoam" then
            table.insert(arg9._waves_foam, val_6)
        elseif val_6.Name == "WavesShade1" then
            table.insert(arg9._waves_shade1, val_6)
        elseif val_6.Name == "WavesShade2" then
            table.insert(arg9._waves_shade2, val_6)
        elseif val_6.Name == "Caustics" then
            table.insert(arg9._caustics1, val_6)
        elseif val_6.Name == "Caustics2" then
            table.insert(arg9._caustics2, val_6)
        end
    end
end

function t._Init(arg10) -- line: 93
    arg10:_Setup()
end

return t
