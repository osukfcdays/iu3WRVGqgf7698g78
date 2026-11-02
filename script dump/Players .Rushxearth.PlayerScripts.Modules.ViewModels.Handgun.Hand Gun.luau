local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Handgun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Handgun)
local t = setmetatable({}, Handgun_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Handgun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Handgun_m.new(...), t)
    t_1._domain_expansion_hash = 0
    t_1._domain_expansion_cc = nil
    t_1._domain_expansion_sound = nil
    t_1:_Init()

    return t_1
end

function t.Destroy(arg1) -- line: 27
    -- upvalues:
    --  [1] Handgun_m (copy)

    arg1._domain_expansion_hash += 1

    if arg1._domain_expansion_cc then
        arg1._domain_expansion_cc:Destroy()
        arg1._domain_expansion_cc = nil
    end

    if arg1._domain_expansion_sound then
        arg1._domain_expansion_sound:Destroy()
        arg1._domain_expansion_sound = nil
    end

    Handgun_m.Destroy(arg1)
end

function t._DomainExpansion(arg2) -- line: 47
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] Utility_m (copy)

    if arg2._destroyed or not arg2.ClientItem.ClientFighter:Get("IsSpectating") then
        return
    end

    arg2._domain_expansion_hash += 1

    if arg2._domain_expansion_cc then
        arg2._domain_expansion_cc:Destroy()
        arg2._domain_expansion_cc = nil
    end

    if arg2._domain_expansion_sound then
        arg2._domain_expansion_sound:Destroy()
        arg2._domain_expansion_sound = nil
    end

    arg2._domain_expansion_cc = Instance.new("ColorCorrectionEffect")
    arg2._domain_expansion_cc.Brightness = -0.5
    arg2._domain_expansion_cc.Contrast = 2
    arg2._domain_expansion_cc.Saturation = -3
    arg2._domain_expansion_cc.Parent = Lighting
    arg2._domain_expansion_sound = Utility_m:CreateSound(
        "rbxassetid://83352422371729",
        1.25,
        1.1,
        script,
        true,
        20
    )
    local DomainExpansionHash = arg2._domain_expansion_hash
    task.delay(15, function() -- line: 74
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] Utility_m (ref)
        --  [3] DomainExpansionHash (copy)

        local v2 = arg2._domain_expansion_sound and arg2._domain_expansion_sound.Volume
        Utility_m:RenderstepForLoop(1, 0, -0.04, function(arg3) -- line: 77
            -- upvalues:
            --  [1] DomainExpansionHash (ref)
            --  [2] arg2 (ref)
            --  [3] v2 (copy)

            if DomainExpansionHash ~= arg2._domain_expansion_hash then
                return true
            end

            local v3 = arg3 ^ 4
            arg2._domain_expansion_cc.Saturation = -3 * v3
            arg2._domain_expansion_cc.Contrast = 2 * v3
            arg2._domain_expansion_cc.Brightness = -0.5 * v3

            if arg2._domain_expansion_sound then
                arg2._domain_expansion_sound.Volume = v2 * arg3
            end
        end)

        if DomainExpansionHash ~= arg2._domain_expansion_hash then
            return
        end

        arg2._domain_expansion_cc:Destroy()
        arg2._domain_expansion_cc = nil

        if arg2._domain_expansion_sound then
            arg2._domain_expansion_sound:Destroy()
            arg2._domain_expansion_sound = nil
        end
    end)
end

function t._Init(arg4) -- line: 107
    arg4.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 108
        -- upvalues:
        --  [1] arg4 (copy)

        if animationTrack == "RareInspect" then
            task.delay(0.6, arg4._DomainExpansion, arg4)
        end
    end)
end

return t
