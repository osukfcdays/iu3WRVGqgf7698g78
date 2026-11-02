local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Custom_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local t = {
    Utility = "rbxassetid://134135466396929",
    Melee = "rbxassetid://78813062969940",
    Secondary = "rbxassetid://136044794858753",
    Primary = "rbxassetid://77716075365102"
}
local t_1 = setmetatable({}, Custom_m)
t_1.__index = t_1

function t_1.new(...) -- line: 20
    -- upvalues:
    --  [1] Custom_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Custom_m.new(...), t_1)
    t_2._use_cooldown = 0
    t_2:_Init()

    return t_2
end

function t_1.GetAutoShootReactionTime(_) -- line: 34
    return nil
end

function t_1.CanQuickAttack(arg2) -- line: 38
    return if tick() > arg2._use_cooldown then not arg2:IsEquipping() else false
end

function t_1.StartShooting(arg3, arg4) -- line: 42
    if not arg4 and (tick() < arg3._use_cooldown or arg3:IsEquipping()) then
        return false
    end

    local now_1 = tick()
    arg3._use_cooldown = now_1 + arg3.Info.RollDuration + arg3.Info.Cooldown
    arg3.ViewModel:PlayAnimation("Use")
    arg3:CooldownEffect("rbxassetid://132973552546079", arg3.Info.RollDuration, "Rolling", true)
    task.delay(arg3.Info.RollDuration, function() -- line: 51
        -- upvalues:
        --  [1] arg3 (copy)

        if arg3._destroyed then
            return
        end

        arg3:CooldownEffect("rbxassetid://17156089790", arg3.Info.Cooldown, "Cooldown")
    end)

    return true, "StartShooting"
end

function t_1.ReplicateFromServer(arg5, arg6, ...) -- line: 62
    -- upvalues:
    --  [1] t (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] Custom_m (copy)

    if arg6 == "RollResult" then
        if not arg5:IsRendered() then
            return
        end

        local v3, v4 = ...
        local v5 = if v4 then "rbxassetid://136831234910767" else t[ItemLibrary_m.Items[v3].Class] or "rbxassetid://134135466396929"

        if arg5.ClientFighter.FighterInterface then
            arg5.ClientFighter.FighterInterface:HotbarRollEffect(arg5)
        end

        arg5:CreateSound(
            "rbxassetid://95740132815107",
            1.5,
            1 + 0.1 * math.random(),
            true,
            0.4
        ):SetAttribute("DontClearSound", true)
        wait(0.4)
        arg5:CreateSound(
            v5,
            1.5,
            1 + 0.2 * math.random(),
            true,
            5
        ):SetAttribute("DontClearSound", true)

        return
    else
        Custom_m.ReplicateFromServer(arg5, arg6, ...)

        return
    end
end

function t_1._Init(_) -- line: 89
end

return t_1
