local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local _ = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("ChainsawParticles")
local t = { 1, 0.1 }
local t_1 = setmetatable({}, ClientViewModel_m)
t_1.__index = t_1

function t_1.new(...) -- line: 13
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(ClientViewModel_m.new(...), t_1)
    t_2._beep_parts = {}
    t_2._beep_visible = false
    t_2._toggle_index = 0
    t_2._next_toggle = 0
    t_2:_Init()

    return t_2
end

function t_1.Update(arg1, arg2, arg3, arg4) -- line: 30
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    ClientViewModel_m.Update(arg1, arg2, arg3, arg4)

    if not arg4.IsActive then
        return
    end

    if tick() < arg1._next_toggle then
        return
    end

    arg1._toggle_index = arg1._toggle_index % #t + 1
    arg1._next_toggle = tick() + t[arg1._toggle_index]
    arg1._beep_visible = not arg1._beep_visible

    for key, _ in pairs(arg1._beep_parts) do
        arg1:_LocalTransparencyModifier(key, "Update", if not arg1._beep_visible then 1 else 0)
    end
end

function t_1._PlayBeepAnimation(_, arg6) -- line: 54
    while true do
        if not arg6:IsDescendantOf(workspace) then
            break
        end

        wait(1)
        arg6.LocalTransparencyModifier = 1
        wait(0.1)
        arg6.LocalTransparencyModifier = 0
    end
end

function t_1._RegisterBeepPart(arg7, arg8) -- line: 66
    arg7._beep_parts[arg8] = true
end

function t_1._Init(arg9) -- line: 70
    -- upvalues:
    --  [1] Utility_m (copy)

    task.defer(function() -- line: 71
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] Utility_m (ref)

        arg9.ClientItem.ProjectileThrown:Connect(function(arg10, _) -- line: 72
            -- upvalues:
            --  [1] Utility_m (ref)

            wait(0.5)
            Utility_m:CreateSound(
                "rbxassetid://104924027407060",
                0.05,
                1 + 0.1 * math.random(),
                arg10,
                true
            ).Looped = true
        end)
    end)
end

return t_1
