local BaseFlareGun_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseFlareGun
)
local t = setmetatable({}, BaseFlareGun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseFlareGun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseFlareGun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._UpdateViewModelAnimations(arg1) -- line: 26
    arg1.Animator:ChangeRareInspectAnimation(
        if arg1.ClientItem:Get("Ammo") > 0 then "RareInspect" else "nil"
    )
end

function t._Init(arg2) -- line: 30
    local Connections = arg2._connections
    local Ammo = arg2.ClientItem:GetDataChangedSignal("Ammo")
    table.insert(Connections, Ammo:Connect(function() -- line: 31
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateViewModelAnimations()
    end))
    arg2:_RegisterDefaultAmmoVisuals()
    task.defer(arg2._UpdateViewModelAnimations, arg2)
end

return t
