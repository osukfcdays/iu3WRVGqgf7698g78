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
    t_1._hide_this_mesh = t_1.ItemModel:WaitForChild("Body"):WaitForChild("MeshPart")
    t_1:_Init()

    return t_1
end

function t._UpdateAmmoVisual(arg1) -- line: 28
    if arg1._destroyed then
        return
    end

    local v3 = arg1.ClientItem:Get("Ammo") > 0 and true
    local HideThisMesh = arg1._hide_this_mesh
    HideThisMesh.Material = v3 and Enum.Material.Glass or Enum.Material.SmoothPlastic
    local v5 = if not v3 then 1 else 0
    arg1:_LocalTransparencyModifier(arg1._hide_this_mesh, "AmmoVisual", v5)
end

function t._Init(arg2) -- line: 39
    arg2.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 40
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateAmmoVisual()
    end)
    task.spawn(arg2._UpdateAmmoVisual, arg2)
end

return t
