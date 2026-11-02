local FreezeRay_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Freeze Ray"]
)
local t = setmetatable({}, FreezeRay_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] FreezeRay_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(FreezeRay_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(_) -- line: 26
end

return t
