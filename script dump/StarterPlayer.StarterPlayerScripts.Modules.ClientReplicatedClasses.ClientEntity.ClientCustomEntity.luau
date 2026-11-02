local ClientEntity_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity
)
local t = setmetatable({}, ClientEntity_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] ClientEntity_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientEntity_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetHealth(arg1) -- line: 20
    return arg1.Model:GetAttribute("Health")
end

function t.GetMaxHealth(arg2) -- line: 24
    return arg2.Model:GetAttribute("MaxHealth")
end

function t._Init(arg3) -- line: 32
    arg3.Model:GetAttributeChangedSignal("MaxHealth"):Connect(function() -- line: 33
        -- upvalues:
        --  [1] arg3 (copy)

        arg3.HealthChanged:Fire()
    end)
    arg3.Model:GetAttributeChangedSignal("Health"):Connect(function() -- line: 37
        -- upvalues:
        --  [1] arg3 (copy)

        arg3.HealthChanged:Fire()
    end)
end

return t
