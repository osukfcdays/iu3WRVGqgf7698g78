local Gun_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    function arg1._on_reload_callback() -- line: 27
        -- upvalues:
        --  [1] arg1 (copy)

        local ReloadHash = arg1._reload_hash
        task.delay(0.5, function() -- line: 30
            -- upvalues:
            --  [1] ReloadHash (copy)
            --  [2] arg1 (ref)

            if ReloadHash ~= arg1._reload_hash then
                return
            end

            arg1.ViewModel:PlayReloadParticles()
        end)
    end
end

return t
