local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local ClientHumanoidEntity_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighterCharacter = arg1
    t_1._last_is_alive_check = nil
    t_1._last_is_grounded_check = nil
    t_1._is_grounded_time = nil
    t_1:_Init()

    return t_1
end

function t.IsAliveCached(arg2) -- line: 28
    -- upvalues:
    --  [1] ClientHumanoidEntity_m (copy)

    if arg2._last_is_alive_check ~= nil then
    end

    local v1 = arg2.ClientFighterCharacter.Head and ClientHumanoidEntity_m.IsAlive(
        arg2.ClientFighterCharacter
    )
    arg2._last_is_alive_check = v1

    return v1
end

function t.IsGroundedCached(arg3) -- line: 40
    if arg3._last_is_grounded_check ~= nil then
        return arg3._last_is_grounded_check
    end

    if not arg3.ClientFighterCharacter:IsAlive() then
        arg3._last_is_grounded_check = false

        return false
    end

    local v2 = not arg3.ClientFighterCharacter:IsHumanoidStateAirborne()
    arg3._last_is_grounded_check = v2

    return v2
end

function t.Update(arg4, _, _) -- line: 67
    arg4._last_is_alive_check = nil
    arg4._last_is_grounded_check = nil
end

function t.Destroy(_) -- line: 72
end

function t._UpdateHumanoidStates(arg8) -- line: 80
    if not arg8.ClientFighterCharacter.Humanoid then
        return
    end

    local v3 = not (not arg8.ClientFighterCharacter:Get("IsFrozen"))
    arg8.ClientFighterCharacter.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    arg8.ClientFighterCharacter.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    arg8.ClientFighterCharacter.Humanoid:SetStateEnabled(
        Enum.HumanoidStateType.PlatformStanding,
        v3
    )
    arg8.ClientFighterCharacter.Humanoid.PlatformStand = v3
end

function t._Init(arg9) -- line: 93
    arg9.ClientFighterCharacter:GetDataChangedSignal("IsFrozen"):Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateHumanoidStates()
    end)
    arg9:_UpdateHumanoidStates()
end

return t
