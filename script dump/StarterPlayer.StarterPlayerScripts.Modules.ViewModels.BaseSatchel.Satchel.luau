local BaseSatchel_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseSatchel
)
local t = setmetatable({}, BaseSatchel_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseSatchel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseSatchel_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    task.defer(function() -- line: 27
        -- upvalues:
        --  [1] arg1 (copy)

        arg1.ClientItem.ProjectileThrown:Connect(function(_, arg3) -- line: 28
            -- upvalues:
            --  [1] arg1 (ref)

            arg1:_PlayBeepAnimation(arg3:WaitForChild("Beep"))
        end)
    end)
    arg1:_RegisterBeepPart(arg1.ItemModel:WaitForChild("Body"):WaitForChild("Beep"))
end

return t
