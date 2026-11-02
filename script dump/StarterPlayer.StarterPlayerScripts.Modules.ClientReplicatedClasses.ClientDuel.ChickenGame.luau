local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientDuel = arg1
    t_1._cc = Instance.new("ColorCorrectionEffect")
    t_1._red_light_hash = 0
    t_1._jingle_sfx = nil
    t_1:_Init()

    return t_1
end

function t.RedLight(arg2, arg3, arg4) -- line: 28
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] RunService (copy)
    --  [3] Utility_m (copy)

    arg2._red_light_hash += 1
    local RedLightHash = arg2._red_light_hash
    arg2._cc.Contrast = 0
    arg2._cc.Saturation = 0
    arg2._cc.TintColor = Color3.fromRGB(255, 255, 255)
    arg2._cc.Parent = Lighting
    local now = tick()

    while true do
        if not (tick() < now + arg3) then
            break
        end

        local v1 = math.clamp((tick() - now) / arg3, 0, 1) ^ 4
        arg2._cc.Contrast = 0
        arg2._cc.Saturation = 0
        arg2._cc.TintColor = Color3.fromRGB(255, 255, 255):Lerp(Color3.fromRGB(255, 127, 127), v1)
        RunService.RenderStepped:Wait()

        if RedLightHash == arg2._red_light_hash then
            continue
        end

        return
    end

    arg2._cc.Contrast = 0
    arg2._cc.Saturation = 0
    arg2._cc.TintColor = Color3.fromRGB(255, 0, 0)
    arg2.ClientDuel.DuelInterface:CreateSound(
        "rbxassetid://115599786018668",
        0.5,
        0.875,
        script,
        true,
        5
    )
    local now_2 = tick()
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg5) -- line: 62
        -- upvalues:
        --  [1] RedLightHash (copy)
        --  [2] arg2 (copy)

        if RedLightHash ~= arg2._red_light_hash then
            return true
        end

        local v3 = (arg5 / 100) ^ 2
        arg2._cc.Contrast = 1 + -1 * v3
        arg2._cc.Saturation = 1 + -1 * v3
        arg2._cc.Brightness = 0.25 + -0.25 * v3
    end)
    wait(arg4 - (tick() - now_2))

    if RedLightHash ~= arg2._red_light_hash then
        return
    end

    arg2._cc.Parent = nil
end

function t.GreenLight(arg6, arg7, arg8, arg9) -- line: 83
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] Utility_m (copy)

    arg6._red_light_hash += 1
    local RedLightHash_1 = arg6._red_light_hash

    if not arg7 then
        arg6._cc.Parent = nil

        return
    end

    arg6.ClientDuel.DuelInterface:CreateSound(
        "rbxassetid://115599786018668",
        0.25,
        2,
        script,
        true,
        5
    )
    arg6._jingle_sfx = arg6.ClientDuel.DuelInterface:CreateSound(
        "rbxassetid://81396691367613",
        0.25,
        5 / arg7,
        script,
        true,
        10
    )
    arg6._cc.Contrast = 1
    arg6._cc.Saturation = 0.5
    arg6._cc.TintColor = Color3.fromRGB(100, 255, 50)
    local Cc_4 = arg6._cc
    Cc_4.Parent = not arg9 and Lighting or nil
    local now_3 = tick()
    wait(0.25)
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg10) -- line: 104
        -- upvalues:
        --  [1] RedLightHash_1 (copy)
        --  [2] arg6 (copy)

        if RedLightHash_1 ~= arg6._red_light_hash then
            return true
        end

        local v6 = 1 - (1 - arg10 / 100) ^ 2
        arg6._cc.Contrast = 1 + -1 * v6
        arg6._cc.Saturation = 0.5 + -0.5 * v6
        arg6._cc.TintColor = Color3.fromRGB(100, 255, 50):Lerp(Color3.fromRGB(255, 255, 255), v6)
    end)

    if RedLightHash_1 ~= arg6._red_light_hash then
        return
    end

    arg6._cc.Parent = nil
    arg6:RedLight(arg7 - (tick() - now_3), arg8)
end

function t.Stop(arg11) -- line: 124
    if arg11._jingle_sfx then
        arg11._jingle_sfx:Destroy()
        arg11._jingle_sfx = nil
    end
end

function t.Elimination(arg12) -- line: 131
    arg12.ClientDuel.DuelInterface:CreateSound(
        "rbxassetid://13270206222",
        1,
        1.25 + 0.5 * math.random(),
        script,
        true,
        5
    )
    arg12.ClientDuel.DuelInterface:CreateSound(
        "rbxassetid://13270206087",
        1,
        1.25 + 0.5 * math.random(),
        script,
        true,
        5
    )
end

function t.Destroy(arg13) -- line: 136
    arg13._red_light_hash += 1
    arg13._cc:Destroy()
end

function t._Init(arg14) -- line: 145
    arg14.ClientDuel:GetDataChangedSignal("IsSpectating"):Connect(function() -- line: 146
        -- upvalues:
        --  [1] arg14 (copy)

        if not arg14.ClientDuel:Get("IsSpectating") then
            arg14._cc.Parent = nil
        end
    end)
end

return t
