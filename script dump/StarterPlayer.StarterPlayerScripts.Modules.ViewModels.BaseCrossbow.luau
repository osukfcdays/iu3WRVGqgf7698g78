local ClientViewModel_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild(
        "ClientReplicatedClasses"
    ):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._registered_ammo_visuals = {}
    t_1._visibility_delayed = nil
    t_1:_Init()

    return t_1
end

function t._UpdateAmmoVisual(arg1) -- line: 29
    if arg1._destroyed then
        return
    end

    local v3 = if not (arg1.ClientItem:Get("Ammo") > 0) then arg1:IsAnimationPlaying("Reload") else true

    if v3 and not arg1._visibility_delayed then
        arg1._visibility_delayed = true
        wait(0.1)
        arg1:_UpdateAmmoVisual()

        return
    end

    arg1._visibility_delayed = nil

    for key, _ in pairs(arg1._registered_ammo_visuals) do
        arg1:_LocalTransparencyModifier(key, "AmmoVisual", if not v3 then 1 else 0)
    end
end

function t._RegisterAmmoVisual(arg2, arg3) -- line: 53
    arg2._registered_ammo_visuals[arg3] = true
end

function t._Init(arg4) -- line: 57
    arg4.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisual()
    end)
    arg4.AnimationPlayed:Connect(function() -- line: 62
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisual()
    end)
    arg4.AnimationStopped:Connect(function() -- line: 66
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisual()
    end)
    task.spawn(arg4._UpdateAmmoVisual, arg4)
end

return t
