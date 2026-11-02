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

function t._UpdateBall(arg1) -- line: 29
    if arg1._destroyed then
        return
    end

    local v3 = if not (arg1.ClientItem:Get("Ammo") > 0) then arg1:IsAnimationPlaying("Reload") else true

    if v3 and not arg1._visibility_delayed then
        arg1._visibility_delayed = true
        wait(0.1)
        arg1:_UpdateBall()

        return
    end

    for _, _ in pairs(arg1._registered_ammo_visuals) do
        local v4 = if not v3 then 1 else 0
        arg1:_LocalTransparencyModifier(arg1._sphere, "AmmoVisual", v4)
    end

    arg1._visibility_delayed = nil
end

function t._RegisterAmmoVisual(arg2, arg3) -- line: 53
    arg2._registered_ammo_visuals[arg3] = true
    task.spawn(arg2._UpdateBall, arg2)
end

function t._RegisterDefaultAmmoVisuals(arg4) -- line: 58
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("Ball"):WaitForChild("Sphere"))
end

function t._Init(arg5) -- line: 62
    arg5.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 63
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateBall()
    end)
    arg5.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 67
        -- upvalues:
        --  [1] arg5 (copy)

        if animationTrack == "Reload" then
            arg5:_UpdateBall()
        end
    end)
    arg5.AnimationStopped:Connect(function(arg7) -- line: 73
        -- upvalues:
        --  [1] arg5 (copy)

        if arg7 == "Reload" then
            arg5:_UpdateBall()
        end
    end)
    task.spawn(arg5._UpdateBall, arg5)
end

return t
