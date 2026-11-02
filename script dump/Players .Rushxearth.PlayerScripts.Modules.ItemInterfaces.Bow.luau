local ItemInterface_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild(
        "ClientReplicatedClasses"
    ):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ItemInterface")
)
local Charge_m = require(script:WaitForChild("Charge"))
local t = setmetatable({}, ItemInterface_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] ItemInterface_m (copy)
    --  [2] t (copy)
    --  [3] Charge_m (copy)

    local t_1 = setmetatable(ItemInterface_m.new(...), t)
    t_1.Charge = Charge_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.Destroy(arg1) -- line: 23
    -- upvalues:
    --  [1] ItemInterface_m (copy)

    arg1.Charge:Destroy()
    ItemInterface_m.Destroy(arg1)
end

function t._Init(_) -- line: 32
end

return t
