local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CosmeticLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local StaticViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel
)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1.UnequippedViewModel = nil
    t_1._shield_attached = false
    t_1._update_shield_queued = false
    t_1._is_broken = t_1:Get("Ammo") <= 0 and true
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 31
    -- upvalues:
    --  [1] Melee_m (copy)

    if arg2 == "AbsorbedHit" then
        if not arg1:IsRendered() then
            return
        end

        arg1.ViewModel:Impulse(Vector3.new(0, -20, 0), 1, nil, true)
        arg1.ViewModel:AbsorbedHit()

        return
    else
        Melee_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t.Destroy(arg3) -- line: 44
    -- upvalues:
    --  [1] Melee_m (copy)

    arg3.UnequippedViewModel:Destroy()
    Melee_m.Destroy(arg3)
end

function t._CheckBroken(arg4) -- line: 53
    local v3 = arg4:Get("Ammo") <= 0 and true

    if arg4._is_broken == v3 then
        return
    end

    arg4._is_broken = v3
    arg4:_UpdateUnequippedViewModel()
    arg4.ViewModel:ChangeEquipAnimation(
        if arg4._is_broken and arg4.ViewModel.Info.Animations.EmptyEquip then "EmptyEquip" else "Equip"
    )
    arg4.ViewModel:ChangeInspectAnimation(
        if arg4._is_broken and arg4.ViewModel.Info.Animations.EmptyInspect then "EmptyInspect" else "Inspect"
    )
    arg4.ViewModel:ChangeIdleAnimation(
        if arg4._is_broken and arg4.ViewModel.Info.Animations.EmptyIdle then "EmptyIdle" else "Idle"
    )
    arg4.ViewModel:ChangeSprintAnimation(
        if arg4._is_broken and arg4.ViewModel.Info.Animations.EmptySprint then "EmptySprint" else "Sprint"
    )
    arg4.ViewModel:OverrideRootPartOffset(
        if arg4._is_broken and arg4.ViewModel.Info.Animations.EmptyIdle then CFrame.identity else nil
    )

    if not arg4._is_broken then
        return
    end

    arg4.ViewModel:ShieldBroken()
end

function t._WaitForUnequippedViewModelRoot(arg5) -- line: 76
    local v5 = arg5.ClientFighter.Entity

    if v5 then
        v5 = arg5.ClientFighter.Entity.Model

        if v5 then
            v5 = arg5.ClientFighter.Entity.Model:WaitForChild("UpperTorso")
        end
    end

    return v5
end

function t._UpdateUnequippedViewModel(arg6) -- line: 80
    if not arg6._shield_attached or arg6._update_shield_queued then
        return
    end

    arg6._update_shield_queued = true
    task.delay(0.1, function() -- line: 92
        -- upvalues:
        --  [1] arg6 (copy)

        arg6._update_shield_queued = false

        if arg6._destroyed then
            return
        end

        local v6 = not arg6.IsEquipped

        if v6 then
            v6 = not arg6.ClientFighter:IsActuallyFirstPerson()

            if v6 then
                v6 = not arg6.ClientFighter:Get("IsHiddenByEmotes")

                if v6 then
                    v6 = not arg6._is_broken
                end
            end
        end

        local v7 = v6

        if v7 then
            v7 = arg6:_WaitForUnequippedViewModelRoot()
        end

        if v7 then
            arg6.UnequippedViewModel:BreakWeld(v7)
            arg6.UnequippedViewModel:PivotTo(v7.CFrame, "_riot_shield_back")
            arg6.UnequippedViewModel:WeldTo(v7)
        end

        arg6.UnequippedViewModel:SetWrap(if not v6 then nil else arg6.ViewModel:GetWrap())
        arg6.UnequippedViewModel:SetParent(
            if not v6 then nil else if not arg6.ClientFighter.Entity then nil else arg6.ClientFighter.Entity.Model or nil
        )
    end)
end

function t._AttachUneqippedViewModel(arg7) -- line: 113
    if arg7._shield_attached then
        return
    end

    local v9 = arg7:_WaitForUnequippedViewModelRoot()

    if not v9 or arg7._shield_attached or not arg7.ClientFighter:IsAlive() then
        return
    end

    arg7._shield_attached = true
    arg7.UnequippedViewModel:PivotTo(v9.CFrame, "_riot_shield_back")
    arg7.UnequippedViewModel:WeldTo(v9)
    arg7:_UpdateUnequippedViewModel()
end

function t._Setup(arg8) -- line: 130
    -- upvalues:
    --  [1] StaticViewModel_m (copy)

    arg8.UnequippedViewModel = StaticViewModel_m.new(arg8.ViewModel.Name)
    arg8.UnequippedViewModel:SetArchivable(false)
end

function t._Init(arg9) -- line: 136
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CameraController_m (copy)

    arg9.EquippedChanged:Connect(function() -- line: 137
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateUnequippedViewModel()
    end)
    arg9:GetDataChangedSignal("Ammo"):Connect(function() -- line: 141
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_CheckBroken()
    end)
    local Connections = arg9._connections
    local IsSpectating = arg9.ClientFighter:GetDataChangedSignal("IsSpectating")
    table.insert(Connections, IsSpectating:Connect(function() -- line: 145
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateUnequippedViewModel()
    end))
    local Connections_1 = arg9._connections
    local IsHiddenByEmotes = arg9.ClientFighter:GetDataChangedSignal("IsHiddenByEmotes")
    table.insert(Connections_1, IsHiddenByEmotes:Connect(function() -- line: 149
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateUnequippedViewModel()
    end))
    table.insert(arg9._connections, arg9.ClientFighter.EntityAdded:Connect(function() -- line: 153
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_AttachUneqippedViewModel()
    end))
    table.insert(arg9._connections, arg9.ClientFighter.HealthChanged:Connect(function() -- line: 157
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_AttachUneqippedViewModel()
    end))
    local Connections_4 = arg9._connections
    local v10 = PlayerDataController_m:GetSettingChangedSignal("Wraps Disabled")
    table.insert(Connections_4, v10:Connect(function() -- line: 161
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateUnequippedViewModel()
    end))
    table.insert(arg9._connections, CameraController_m.POVStateChanged:Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateUnequippedViewModel()
    end))
    arg9:_Setup()
    task.spawn(arg9._CheckBroken, arg9)
    task.defer(arg9._AttachUneqippedViewModel, arg9)
end

return t
