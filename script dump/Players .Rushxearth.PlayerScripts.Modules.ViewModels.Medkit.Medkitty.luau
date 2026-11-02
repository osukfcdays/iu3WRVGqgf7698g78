local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Medkit_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Medkit)
local t = setmetatable({}, Medkit_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Medkit_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Medkit_m.new(...), t)
    t_1.PlayEquipAnimationOnHeal = false
    t_1._heal_particles_attachment = t_1.ItemModel:WaitForChild("Head"):WaitForChild("Head"):WaitForChild(
        "_medkitty_heal"
    )
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 32
    -- upvalues:
    --  [1] Utility_m (copy)

    task.defer(function() -- line: 33
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] Utility_m (ref)

        table.insert(arg1._connections, arg1.ClientItem.AnimationReachedHealTimestamp:Connect(function() -- line: 34
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] arg1 (ref)

            Utility_m:PlayParticles(arg1._heal_particles_attachment)
        end))
    end)
end

return t
