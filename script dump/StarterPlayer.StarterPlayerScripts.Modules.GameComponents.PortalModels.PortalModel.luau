local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local Portal_m = require(script:WaitForChild("Portal"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 12
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Model = arg1
    t_1.Portals = {}
    t_1._item_id = t_1.Model:GetAttribute("ItemID")
    t_1._user_id = t_1.Model:GetAttribute("UserID")
    t_1._teleport_cooldowns = {}
    t_1:_Init()

    return t_1
end

function t.GetPortal(arg2, arg3) -- line: 31
    for key, val in pairs(arg2.Portals) do
        if val.Model == arg3 then
            return val, key
        end
    end
end

function t.GetOtherPortal(arg4, arg5) -- line: 39
    return arg4.Portals[3 - arg5.PortalNum]
end

function t.ArePortalsGrown(arg6) -- line: 43
    local v2 = arg6.Portals[1]

    if v2 then
        v2 = arg6.Portals[1]:IsGrown()

        if v2 then
            v2 = arg6.Portals[2]

            if v2 then
                v2 = arg6.Portals[2]:IsGrown()
            end
        end
    end

    return v2
end

function t.CanWarp(arg7) -- line: 48
    -- upvalues:
    --  [1] Players (copy)

    return arg7.Portals[1] and arg7.Portals[2] and (not arg7._user_id or arg7._user_id == Players.LocalPlayer.UserId)
end

function t.Update(arg8, arg9) -- line: 52
    for _, val_1 in pairs(arg8.Portals) do
        val_1:Update(arg9)
    end
end

function t.Destroy(arg10) -- line: 58
    for _, val_2 in pairs(arg10.Portals) do
        val_2:Destroy()
    end

    pcall(function() -- line: 63
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.Model:Destroy()
    end)
end

function t._Touched(arg11, arg12, arg13) -- line: 72
    -- upvalues:
    --  [1] Players (copy)
    --  [2] FighterController_m (copy)
    --  [3] GameplayUtility_m (copy)
    --  [4] Utility_m (copy)
    --  [5] ReplicatedStorage (copy)

    if not arg11:CanWarp() or not arg11:ArePortalsGrown() then
        return
    end

    local v4 = arg11:GetOtherPortal(arg12)

    if not v4 then
        return
    end

    local v5 = arg13.AssemblyRootPart or arg13

    if
        arg13.Parent ~= Players.LocalPlayer.Character
        or tick() < (arg11._teleport_cooldowns[arg12.PortalNum][v5] or 0)
        or not FighterController_m.LocalFighter
        or not FighterController_m.LocalFighter:IsAlive()
    then
        return
    end

    local raycastResult = Utility_m:Raycast(
        arg12.Hitbox.Position,
        v5.Position,
        (arg12.Hitbox.Position - v5.Position).Magnitude,
        GameplayUtility_m:GetRaycastWhitelist(Players.LocalPlayer:GetAttribute("EnvironmentID")),
        Enum.RaycastFilterType.Include
    )

    if raycastResult.Instance and not raycastResult.Instance:IsDescendantOf(v5.Parent) then
        return
    end

    arg11._teleport_cooldowns[arg12.PortalNum][v5] = tick() + 0.25
    arg11._teleport_cooldowns[v4.PortalNum][v5] = tick() + 1
    FighterController_m.LocalFighter.Entity:WarpTo(v4:GetTeleportCFrame())
    Utility_m:CreateSound(
        "rbxassetid://86785771664692",
        0.5,
        1 + 0.1 * math.random(),
        arg12.Hitbox.Position,
        true,
        10
    )
    Utility_m:CreateSound(
        "rbxassetid://81610952487049",
        1,
        1 + 0.1 * math.random(),
        v4.Hitbox.Position,
        true,
        10
    )
    ReplicatedStorage.Remotes.Replication.Fighter.PlayMechanicsSound:FireServer("Warp")
    ReplicatedStorage.Remotes.Replication.Fighter.JustWarped:FireServer(
        arg11._item_id,
        arg12.PortalNum
    )
end

function t._UpdateVisuals(arg14) -- line: 106
    local v15 = arg14:CanWarp()

    for _, val_3 in pairs(arg14.Portals) do
        val_3:UpdateVisuals(v15)
    end
end

function t._ChildRemoved(arg15, arg16) -- line: 114
    local v17, v18 = arg15:GetPortal(arg16)

    if not v17 then
        return
    end

    v17:Destroy()
    arg15.Portals[v18] = nil
    arg15:_UpdateVisuals()
end

function t._ChildAdded(arg17, arg18) -- line: 126
    -- upvalues:
    --  [1] Portal_m (copy)
    --  [2] Players (copy)
    --  [3] Utility_m (copy)

    if not arg18:IsA("Model") then
        return
    end

    arg17:_ChildRemoved(arg18)
    local v19 = Portal_m.new(arg18)
    arg17.Portals[v19.PortalNum] = v19
    arg17:_UpdateVisuals()
    arg17._teleport_cooldowns[v19.PortalNum] = {}
    v19.Hitbox.Touched:Connect(function(otherPart: BasePart) -- line: 139
        -- upvalues:
        --  [1] arg17 (copy)
        --  [2] v19 (copy)

        arg17:_Touched(v19, otherPart)
    end)

    local function check_now() -- line: 143
        -- upvalues:
        --  [1] Players (ref)
        --  [2] Utility_m (ref)
        --  [3] v19 (copy)
        --  [4] arg17 (copy)

        local v20 = pairs
        local v21 = Players.LocalPlayer.Character and Players.LocalPlayer.Character:GetChildren() or {}

        for _, val_4 in v20(v21) do
            local v22 = Utility_m
            local Hitbox = v19.Hitbox
            local Position = val_4.Position

            if
                val_4:IsA("BasePart")
                and v22:IsWithinPart(
                    Hitbox,
                    Position,
                    Vector3.new(1, 1, 1) * math.max(val_4.Size.X, val_4.Size.Y, val_4.Size.Z) * 1.4142135623730951
                )
            then
                arg17:_Touched(v19, val_4)

                return
            end
        end
    end

    v19.FinishedGrowing:Connect(check_now)
    check_now()
end

function t._Init(arg20) -- line: 160
    arg20.Model.ChildAdded:Connect(function(child: Instance) -- line: 161
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_ChildAdded(child)
    end)
    arg20.Model.ChildRemoved:Connect(function(child_1: Instance) -- line: 165
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_ChildRemoved(child_1)
    end)
end

return t
