local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local ClientMap_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDuel.ClientMap
)
local t = setmetatable({}, ClientMap_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] ClientMap_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientMap_m.new(...), t)
    t_1.Entrance = t_1.Model:WaitForChild("Portals"):WaitForChild("Entrance"):WaitForChild("Hitbox")
    t_1.Exit = t_1.Model:WaitForChild("Portals"):WaitForChild("Exit"):WaitForChild("Hitbox")
    t_1._teleport_cooldown = 0
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 34
    -- upvalues:
    --  [1] Players (copy)
    --  [2] FighterController_m (copy)
    --  [3] Utility_m (copy)

    arg1.Entrance.Touched:Connect(function(otherPart: BasePart) -- line: 35
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] Players (ref)
        --  [3] FighterController_m (ref)
        --  [4] Utility_m (ref)

        if
            tick() < arg1._teleport_cooldown
            or otherPart.Parent ~= Players.LocalPlayer.Character
            or not FighterController_m.LocalFighter
            or not FighterController_m.LocalFighter:IsAlive()
        then
            return
        end

        arg1._teleport_cooldown = tick() + 1
        FighterController_m.LocalFighter.Entity:WarpTo(arg1.Exit.CFrame)
        Utility_m:CreateSound(
            "rbxassetid://86785771664692",
            0.5,
            1 + 0.1 * math.random(),
            arg1.Entrance,
            true,
            10
        )
        Utility_m:CreateSound(
            "rbxassetid://81610952487049",
            1,
            1 + 0.1 * math.random(),
            arg1.Exit,
            true,
            10
        )
    end)
end

return t
