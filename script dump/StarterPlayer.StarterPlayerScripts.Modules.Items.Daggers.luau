local Gun_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1.ToggleAimEnabled = nil
    t_1:_Init()

    return t_1
end

function t.StartAiming(_, _) -- line: 22
    return false
end

function t.FinishAiming(_, _) -- line: 26
    return false
end

function t._UpdateViewModelAnimations(arg5) -- line: 34
    local v2 = if arg5:Get("Ammo") <= 0 then arg5.ViewModel.DontUseAmmoReserveToChangeCoreAnimations or arg5:Get(
        "AmmoReserve"
    ) <= 0 and true else false
    arg5.ViewModel:ChangeEquipAnimation(
        if not v2 then "Equip" else if not arg5.ViewModel.Info.Animations.EmptyEquip then "Equip" else "EmptyEquip"
    )
    arg5.ViewModel:ChangeInspectAnimation(
        if v2 and arg5.ViewModel.Info.Animations.EmptyInspect then "EmptyInspect" else "Inspect"
    )
    arg5.ViewModel:ChangeIdleAnimation(
        if v2 and arg5.ViewModel.Info.Animations.EmptyIdle then "EmptyIdle" else "Idle"
    )
    arg5.ViewModel:OverrideRootPartOffset(
        if v2 and arg5.ViewModel.Info.Animations.EmptyIdle then CFrame.identity else nil
    )
end

function t._Init(arg6) -- line: 43
    arg6:GetDataChangedSignal("Ammo"):Connect(function() -- line: 44
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateViewModelAnimations()
    end)
    arg6:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 48
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateViewModelAnimations()
    end)
    task.defer(arg6._UpdateViewModelAnimations, arg6)
end

return t
