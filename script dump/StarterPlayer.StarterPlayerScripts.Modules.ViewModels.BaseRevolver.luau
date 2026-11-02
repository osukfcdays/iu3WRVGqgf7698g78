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
    t_1._registered_ammo_visuals = { Bullets = {}, ReloadBullets = {} }
    t_1:_Init()

    return t_1
end

function t._UpdateAmmoVisual(arg1) -- line: 28
    if arg1._destroyed then
        return
    end

    local v3 = arg1:IsAnimationPlaying("Reload") or arg1:IsAnimationPlaying("EmptyReload")
    local v4 = arg1.ClientItem:Get("AmmoReserve")
    local v5 = arg1.ClientItem:Get("Ammo")
    local v6 = v4 + v5
    local v7

    for key, val in pairs(arg1._registered_ammo_visuals.Bullets) do
        v7 = if v3 then if not (v6 >= key) then 1 else 0 else if not (v5 >= key) then 1 else 0
        arg1:_LocalTransparencyModifier(val, "AmmoVisual", v7)
    end

    for key_1, val_1 in pairs(arg1._registered_ammo_visuals.ReloadBullets) do
        v7 = if not (v5 >= key_1) then 1 else 0
        arg1:_LocalTransparencyModifier(val_1, "AmmoVisual", v7)
    end
end

function t._RegisterAmmoVisual(arg2, arg3, arg4) -- line: 47
    table.insert(arg2._registered_ammo_visuals[arg3], arg4)
end

function t._RegisterDefaultAmmoVisuals(arg5) -- line: 51
    for _, val_2 in pairs({ "ReloadBullets", "Bullets" }) do
        local v8 = arg5.ItemModel:WaitForChild(val_2)

        for index = 1, 6 do
            arg5:_RegisterAmmoVisual(val_2, v8:WaitForChild(index))
        end
    end
end

function t._Init(arg6) -- line: 61
    arg6.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 62
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateAmmoVisual()
    end)
    arg6.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 66
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateAmmoVisual()
    end)
    arg6.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 70
        -- upvalues:
        --  [1] arg6 (copy)

        if animationTrack == "Reload" or animationTrack == "EmptyReload" then
            arg6:_UpdateAmmoVisual()
        end
    end)
    arg6.AnimationStopped:Connect(function(arg8) -- line: 76
        -- upvalues:
        --  [1] arg6 (copy)

        if arg8 == "Reload" or arg8 == "EmptyReload" then
            arg6:_UpdateAmmoVisual()
        end
    end)
    task.defer(arg6._UpdateAmmoVisual, arg6)
end

return t
