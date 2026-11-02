local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Gun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._ImpactMarker(arg1, arg2) -- line: 28
    -- upvalues:
    --  [1] Gun_m (copy)

    local t_2 = { Color = Color3.fromRGB(0, 0, 0), NoTween = true }

    return Gun_m._ImpactMarker(arg1, arg2, t_2)
end

function t._Tracers(arg3, arg4) -- line: 37
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Gun_m (copy)

    local t_3 = {}
    local t_4 = {
        MaxLength = math.huge,
        MaxLengthFirstPerson = math.huge,
        NoDistanceDelay = true,
        PlayFlyBySound = function(arg5, arg6, arg7) --[[ PlayFlyBySound ]] -- line: 44
            -- upvalues:
            --  [1] Utility_m (ref)

            Utility_m:CreateSound(
                "rbxassetid://14767954026",
                1 * arg6,
                1.4 + 0.2 * math.random(),
                arg5,
                true,
                10,
                arg7,
                arg7
            )
            Utility_m:CreateSound(
                "rbxassetid://17640978498",
                0.15 * arg6,
                1.25 + 0.25 * math.random(),
                arg5,
                true,
                10,
                arg7,
                arg7
            )
        end,
        Template = arg3.ViewModel:GetTracerTemplate(),
        TemplateWrap = arg3:GetWrap(),
        InitCallback = nil,
        CustomUpdate = nil,
        UpdateSpeed = 5
    }

    function t_4.InitCallback(arg8, arg9) -- line: 50
        -- upvalues:
        --  [1] t_3 (copy)

        for _, descendant in pairs(arg8:GetDescendants()) do
            if descendant:IsA("Beam") then
                local v9 = if arg9 ~= 1 then descendant.Width1 else 0
                descendant.Width1 = v9
                local t_5 = {
                    IsBeam = true,
                    Width0 = descendant.Width0,
                    Width1 = descendant.Width1
                }
                t_3[descendant] = t_5
            elseif descendant:IsA("Light") then
                local t_6 = { IsLight = true, Brightness = descendant.Brightness }
                t_3[descendant] = t_6
            end
        end
    end

    function t_4.CustomUpdate(
        _,
        arg11,
        arg12,
        arg13,
        arg14,
        arg15
    ) -- line: 60
        -- upvalues:
        --  [1] t_3 (copy)

        arg12.WorldPosition = arg14
        arg11.WorldPosition = arg15
        local v10 = 1 - arg13 ^ 3

        for key_1, val in pairs(t_3) do
            if val.IsBeam then
                key_1.Width0 = val.Width0 * v10
                key_1.Width1 = val.Width1 * v10
            elseif val.IsLight then
                key_1.Brightness = val.Brightness * v10
            end
        end
    end

    return Gun_m._Tracers(arg3, arg4, t_4)
end

function t._Init(_) -- line: 81
end

return t
