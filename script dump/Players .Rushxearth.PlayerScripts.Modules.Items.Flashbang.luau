local Players = game:GetService("Players")
local FlashbangEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.Functions.FlashbangEffect
)
local Throwable_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Throwable)
local t = setmetatable({}, Throwable_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Throwable_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Throwable_m.new(...), t)
    t_1._play_flash_sound_callback = nil
    t_1._play_ringing_sound_callback = nil
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 24
    -- upvalues:
    --  [1] FlashbangEffect_m (copy)
    --  [2] Throwable_m (copy)

    if arg2 == "BlindEffect" then
        if not arg1:IsRendered() then
            return
        end

        local v2, v3 = ...
        local BlindDuration = arg1.Info.BlindDuration
        local v4 = arg1:Get("ObjectID")
        FlashbangEffect_m(
            { v3 },
            v2,
            BlindDuration,
            v4,
            arg1.ViewModel.Name,
            arg1._play_flash_sound_callback,
            arg1._play_ringing_sound_callback
        )

        return
    else
        Throwable_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t._Setup(arg3) -- line: 46
    function arg3._play_flash_sound_callback(arg4) -- line: 47
        -- upvalues:
        --  [1] arg3 (copy)

        return arg3.ViewModel:PlayFlashSound(arg4)
    end

    function arg3._play_ringing_sound_callback(arg5) -- line: 51
        -- upvalues:
        --  [1] arg3 (copy)

        return arg3.ViewModel:PlayRingingSound(arg5)
    end
end

function t._Init(arg6) -- line: 56
    arg6:_Setup()
end

return t
