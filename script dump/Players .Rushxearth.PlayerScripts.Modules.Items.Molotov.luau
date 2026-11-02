local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Throwable_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Throwable)
local t = setmetatable({}, Throwable_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Throwable_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Throwable_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 22
    -- upvalues:
    --  [1] Throwable_m (copy)

    if arg2 == "MolotovExplode" then
        if not arg1:IsRendered() then
            return
        end

        arg1.ViewModel:ExplosionEffect(..., arg1.Info.FireRadius)

        return
    else
        Throwable_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t._Init(arg3) -- line: 40
    -- upvalues:
    --  [1] Utility_m (copy)

    arg3.ProjectileThrown:Connect(function(arg4, _) -- line: 41
        -- upvalues:
        --  [1] Utility_m (ref)

        Utility_m:CreateSound(
            "rbxassetid://14812827928",
            1,
            1,
            arg4,
            true,
            10
        )
    end)
end

return t
