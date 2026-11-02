local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ArcadeController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.ArcadeController)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 13
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1._update_garage_doors_internal = Signal_m.new()
    t_1:_Init()

    return t_1
end

function t._DoorAdded(arg1, arg2) -- line: 33
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ArcadeController_m (copy)
    --  [3] Players (copy)

    local Door = arg2:WaitForChild("Door")
    local ArcadePortal = arg2:WaitForChild("ArcadePortal")

    if CONSTANTS_m.QUEUES_ACTIVE then
        task.defer(ArcadePortal.Destroy, ArcadePortal)

        return
    end

    local Portal = ArcadePortal:WaitForChild("Portal")
    local Hitbox = Portal:WaitForChild("Hitbox")
    Portal:PivotTo(ArcadePortal:WaitForChild("Anchor").CFrame)
    local UnanchorMe = Portal:WaitForChild("Model"):WaitForChild("UnanchorMe")
    local v2 = UnanchorMe:Clone()
    v2:PivotTo(UnanchorMe:GetPivot())
    v2.Parent = UnanchorMe.Parent
    UnanchorMe.Parent = nil
    local v3 = pairs
    local _ = UnanchorMe:GetPivot()

    for _, val in v3(v2:GetDescendants()) do
        if val:IsA("BasePart") and not val:HasTag("DontUnanchorMe") then
            val.Anchored = false
        end
    end

    arg1._update_garage_doors_internal:Connect(function() --[[ update ]] -- line: 59
        -- upvalues:
        --  [1] ArcadeController_m (ref)
        --  [2] Door (copy)
        --  [3] arg1 (copy)
        --  [4] ArcadePortal (copy)
        --  [5] arg2 (copy)

        local v4 = ArcadeController_m.CurrentDuel

        if v4 then
            v4 = if ArcadeController_m.CurrentDuel:Get("Status") == "GameOver" then false else true
        end

        Door:PivotTo(
            arg1:_GetOriginalPivot(Door) + (if not v4 then Vector3.new(0, -21.75, 0) else Vector3.new(0, 0, 0))
        )
        local v9 = ArcadePortal
        v9.Parent = v4 and arg2 or nil
    end)
    local v11 = ArcadeController_m.CurrentDuel

    if v11 then
        v11 = if ArcadeController_m.CurrentDuel:Get("Status") == "GameOver" then false else true
    end

    local v12 = arg1:_GetOriginalPivot(Door)
    Door:PivotTo(v12 + (if not v11 then Vector3.new(0, -21.75, 0) else Vector3.new(0, 0, 0)))
    ArcadePortal.Parent = v11 and arg2 or nil
    Hitbox.Touched:Connect(function(otherPart: BasePart) -- line: 70
        -- upvalues:
        --  [1] Players (ref)
        --  [2] ArcadeController_m (ref)

        if Players:GetPlayerFromCharacter(otherPart.Parent) == Players.LocalPlayer then
            ArcadeController_m:Join()
        end
    end)
end

function t._ClientDuelAdded(arg4, arg5) -- line: 77
    arg5:GetDataChangedSignal("Status"):Connect(function() -- line: 78
        -- upvalues:
        --  [1] arg4 (copy)

        arg4._update_garage_doors_internal:Fire()
    end)
    arg4._update_garage_doors_internal:Fire()
end

function t._Init(arg6) -- line: 85
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] ArcadeController_m (copy)

    CollectionService:GetInstanceAddedSignal("LobbyDuelsGarageDoor"):Connect(function(arg7) -- line: 86
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_DoorAdded(arg7)
    end)
    ArcadeController_m.DuelSet:Connect(function(arg8) -- line: 90
        -- upvalues:
        --  [1] ArcadeController_m (ref)
        --  [2] arg6 (copy)

        if ArcadeController_m.CurrentDuel then
            arg6:_ClientDuelAdded(arg8)

            return
        end

        arg6._update_garage_doors_internal:Fire()
    end)

    if ArcadeController_m.CurrentDuel then
        task.defer(arg6._ClientDuelAdded, arg6, ArcadeController_m.CurrentDuel)
    end

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyDuelsGarageDoor")) do
        task.defer(arg6._DoorAdded, arg6, val_1)
    end
end

return t._new()
