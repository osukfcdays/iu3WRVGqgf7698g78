local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.GameplayUtility)
local Custom_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local t = setmetatable({}, Custom_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Custom_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Custom_m.new(...), t)
    t_1._use_cooldown = 0
    t_1._preview_connection = nil
    t_1._preview_model = nil
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(_) -- line: 27
    return nil
end

function t.CanQuickAttack(arg2) -- line: 31
    return if tick() > arg2._use_cooldown then if (arg2:Get("Ammo") or math.huge) > 0 then not arg2:IsEquipping() else false else false
end

function t.StartShooting(arg3, arg4) -- line: 35
    if
        not arg4
        and (tick() < arg3._use_cooldown or (arg3:Get("Ammo") or math.huge) <= 0 or arg3:IsEquipping())
    then
        return false
    end

    arg3._use_cooldown = tick() + arg3.Info.Cooldown
    arg3:CooldownEffect("rbxassetid://17156089790", arg3.Info.Cooldown, "Use")
    arg3.ViewModel:StopAnimation("Inspect")
    arg3.ViewModel:PlayAnimation("Use", 0.5)

    return true, "StartShooting", arg3:_GetPlacementPosition()
end

function t.Equip(arg5, ...) -- line: 48
    -- upvalues:
    --  [1] Custom_m (copy)

    Custom_m.Equip(arg5, ...)
    arg5:_StartPlacementPreview()
end

function t.Unequip(arg6, ...) -- line: 53
    -- upvalues:
    --  [1] Custom_m (copy)

    arg6:_StopPlacementPreview()
    Custom_m.Unequip(arg6, ...)
end

function t.ReplicateFromServer(arg7, arg8, ...) -- line: 58
    -- upvalues:
    --  [1] Custom_m (copy)

    if arg8 == "MineExplosion" then
        if not arg7:IsRendered() then
            return
        end

        arg7.ViewModel:ExplosionEffect(...)

        return
    else
        Custom_m.ReplicateFromServer(arg7, arg8, ...)

        return
    end
end

function t.Destroy(arg9) -- line: 70
    -- upvalues:
    --  [1] Custom_m (copy)

    arg9:_StopPlacementPreview()
    Custom_m.Destroy(arg9)
end

function t._GetPlacementPosition(arg10) -- line: 79
    local _, v4 = arg10.ClientFighter:GetCameraData()

    return v4.Position
end

function t._StopPlacementPreview(arg11) -- line: 85
    if arg11._preview_connection then
        arg11._preview_connection:Disconnect()
        arg11._preview_connection = nil
    end

    if arg11._preview_model then
        arg11._preview_model:Destroy()
        arg11._preview_model = nil
    end
end

function t._StartPlacementPreview(arg12) -- line: 97
    arg12:_StopPlacementPreview()

    if not arg12.ClientFighter.IsLocalPlayer then
        return
    end
end

function t._Init(_) -- line: 141
end

return t
