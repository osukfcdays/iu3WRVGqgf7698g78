local ItemInterface_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild(
        "ClientReplicatedClasses"
    ):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ItemInterface")
)
local ScopeModifier_m = require(script:WaitForChild("ScopeModifier"))
local t = setmetatable({}, ItemInterface_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] ItemInterface_m (copy)
    --  [2] t (copy)
    --  [3] ScopeModifier_m (copy)

    local t_1 = setmetatable(ItemInterface_m.new(...), t)
    t_1.ScopeModifier = ScopeModifier_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.Unequip(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] ItemInterface_m (copy)

    arg1.ScopeModifier:Refresh()
    ItemInterface_m.Unequip(arg1, ...)
end

function t.Destroy(arg2) -- line: 28
    -- upvalues:
    --  [1] ItemInterface_m (copy)

    arg2.ScopeModifier:Destroy()
    ItemInterface_m.Destroy(arg2)
end

function t._Init(_) -- line: 37
end

return t
