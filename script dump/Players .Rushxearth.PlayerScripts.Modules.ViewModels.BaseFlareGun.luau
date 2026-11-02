local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._ammo_visuals = {}
    t_1:_Init()

    return t_1
end

function t._UpdateAmmoVisual(arg1) -- line: 30
    local v3 = if arg1.ClientItem:Get("Ammo") > 0 then 0 else 1

    for key, _ in pairs(arg1._ammo_visuals) do
        arg1:_LocalTransparencyModifier(key, "AmmoVisual", v3)
    end
end

function t._RegisterAmmoVisual(arg2, arg3) -- line: 38
    arg2._ammo_visuals[arg3] = true
end

function t._RegisterDefaultAmmoVisuals(arg4) -- line: 42
    for _, child in pairs(arg4.ItemModel:WaitForChild("Shell"):GetChildren()) do
        if child:IsA("BasePart") then
            arg4:_RegisterAmmoVisual(child)
        end
    end
end

function t._Init(arg5) -- line: 50
    -- upvalues:
    --  [1] Players (copy)
    --  [2] Utility_m (copy)

    arg5.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 51
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateAmmoVisual()
    end)
    task.defer(function() -- line: 55
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] Players (ref)
        --  [3] Utility_m (ref)

        arg5.ClientItem.ProjectileShot:Connect(function(_, arg7) -- line: 56
            -- upvalues:
            --  [1] arg5 (ref)
            --  [2] Players (ref)
            --  [3] Utility_m (ref)

            local v5 = arg5.ClientItem.ClientFighter.Player:GetAttribute("TeamID")
            local v6 = not arg5.ClientItem.ClientFighter.IsLocalPlayer

            if v6 then
                v6 = not v5 or (if v5 == Players.LocalPlayer:GetAttribute("TeamID") then false else true)
            end

            v5 = v6 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(47, 255, 0)
            local v7, v8, v9 = v5:ToHSV()
            v6 = Color3.fromHSV(v7, v8 * 0.875, v9)

            for _, descendant in pairs(arg7:GetDescendants()) do
                if not descendant:GetAttribute("IgnoreRecolor") then
                    v9 = descendant:GetAttribute("IsDangerParticle") and v5 or v6

                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
                        descendant.Color = ColorSequence.new(v9)
                    elseif descendant:IsA("Light") then
                        descendant.Color = v9
                    end
                end
            end

            Utility_m:CreateSound(
                "rbxassetid://17331783148",
                1.25,
                1,
                arg7.Primary,
                true
            ).Looped = true
        end)
    end)
    arg5:_UpdateAmmoVisual()
end

return t
