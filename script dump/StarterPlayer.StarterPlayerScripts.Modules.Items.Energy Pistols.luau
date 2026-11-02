local Players = game:GetService("Players")
local Gun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local EnergyTracerEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "EnergyTracerEffect"
)
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

function t._ImpactMarker(_, _) -- line: 28
end

function t._Tracers(arg3, arg4) -- line: 32
    -- upvalues:
    --  [1] EnergyTracerEffect (copy)
    --  [2] Gun_m (copy)

    local _ = {}

    return Gun_m._Tracers(arg3, arg4, {
        PlayFlyBySound = function(_, _) --[[ PlayFlyBySound ]] -- line: 36
        end,
        Template = EnergyTracerEffect,
        InitCallback = function(arg7, _) --[[ InitCallback ]] -- line: 40
            for _, descendant in pairs(arg7:GetDescendants()) do
                if descendant:IsA("Beam") then
                    descendant.Width1 = 0
                end
            end
        end
    })
end

function t._Init(_) -- line: 52
end

return t
