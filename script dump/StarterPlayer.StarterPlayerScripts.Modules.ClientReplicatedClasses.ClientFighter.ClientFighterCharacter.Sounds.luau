local SoundLibrary_m = require(game:GetService("ReplicatedStorage").Modules.SoundLibrary)
local t = {}
t.__index = t

function t.new(arg1) -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighterCharacter = arg1
    t_1._last_footstep = 0
    t_1._falling_start = nil
    t_1._falling_sound = nil
    t_1._footsteps_disabled = 0
    t_1:_Init()

    return t_1
end

function t.DisableFootsteps(arg2, arg3) -- line: 27
    arg2._footsteps_disabled = tick() + arg3
end

function t.Update(arg4, arg5, arg6) -- line: 31
    arg4:_UpdateFalling(arg5, arg6)
    arg4:_UpdateFootstep(arg5, arg6)
end

function t.Destroy(arg7) -- line: 36
    arg7:_ClearFallingSound()
end

function t._ClearFallingSound(arg8) -- line: 44
    if arg8._falling_sound then
        arg8._falling_sound:Destroy()
        arg8._falling_sound = nil
    end
end

function t._UpdateFalling(arg9, _, arg11) -- line: 51
    local v1 = arg11.IsGrounded or arg11.IsHiddenByCutscene

    if not v1 and not arg9._falling_start then
        arg9._falling_start = tick()
        local v2 = arg9.ClientFighterCharacter.ClientFighter.IsLocalPlayer

        if v2 then
            v2 = arg9.ClientFighterCharacter.ClientFighter:CreateSound(
                "rbxassetid://16737738355",
                0,
                1,
                true
            )
        end

        arg9._falling_sound = v2
        arg9.ClientFighterCharacter.ClientFighter:CreateSound(
            "rbxassetid://16736552098",
            0.5,
            1 + 0.5 * math.random(),
            true,
            5
        )

        if arg9._falling_sound then
            arg9._falling_sound.Looped = true
        end
    elseif v1 and arg9._falling_start and tick() - arg9._falling_start > 0.25 then
        arg9:_ClearFallingSound()
        arg9.ClientFighterCharacter.ClientFighter:CreateSound(
            "rbxassetid://16736552001",
            math.clamp((tick() - arg9._falling_start - 1) * 0.45, 0, 0.9) + 0.1,
            1 + 0.75 * math.random(),
            true,
            5
        )
        arg9._falling_start = nil
        arg11.JustLanded = true

        return true
    end

    if arg9._falling_sound then
        local FallingSound = arg9._falling_sound
        local maximum = math.max(0, -arg9.ClientFighterCharacter.RootPart.Velocity.Y - 24)
        FallingSound.Volume = math.min(1, (math.sqrt(maximum) / 15) ^ 2 * 2)
    end
end

function t._UpdateFootstep(arg12, _, arg14) -- line: 77
    -- upvalues:
    --  [1] SoundLibrary_m (copy)

    if
        not arg14.IsAlive
        or arg14.IsCrouching
        or arg14.IsSliding
        or (if arg14.IsGrounded then arg14.IsHiddenByEmotes or arg14.IsHiddenByCutscene else not arg14.IsClimbing or arg14.IsHiddenByEmotes or arg14.IsHiddenByCutscene)
    then
        return
    end

    if tick() < arg12._footsteps_disabled then
        return
    end

    local v6 = arg12.ClientFighterCharacter:GetCurrentEmote()

    if
        v6
        and v6.Info.HideFootsteps
        and not arg12.ClientFighterCharacter.ClientFighter:Get("IsInDuel")
    then
        return
    end

    local v7 = arg12.ClientFighterCharacter.ClientFighter.Entity:Get("Scale") or 1
    local v8 = 1 + (v7 - 1) / 2
    local v9 = arg14.IsClimbing and math.abs(arg14.PlayerVelocity.Y * 1.25) or arg14.MoveSpeed / v8

    if v9 < 1 or tick() < arg12._last_footstep + 4.5 / v9 then
        return
    end

    arg12._last_footstep = tick()
    v8 = if not arg14.IsClimbing then if not (v7 >= 2) then SoundLibrary_m.FootstepSounds[arg12.ClientFighterCharacter.Humanoid.FloorMaterial.Name] and arg12.ClientFighterCharacter.Humanoid.FloorMaterial.Name or "Default" else "Stomping" else "Climbing"
    local v10 = SoundLibrary_m.FootstepSounds[v8]
    local v11 = SoundLibrary_m.FootstepSounds[v10] or v10

    if #v11 == 0 then
        return
    end

    local v12 = (0.875 + 0.25 * math.random()) * (1 + 0.1 * (v9 / 16))
    local v13 = if v8 ~= "Default" then 1 else 2
    local v17 = v9 / 32 * v13 * (if v8 == "Stomping" then 2 else 1) * (if arg12.ClientFighterCharacter.ClientFighter:Get(
        "IsSpectating"
    ) then 0.5 else 1)
    local ClientFighter_2 = arg12.ClientFighterCharacter.ClientFighter
    local v18 = v17 * 0.75
    ClientFighter_2:CreateSound(
        v11[math.random(#v11)],
        v18,
        v12,
        true,
        5,
        32,
        100
    )
end

function t._Init(arg15) -- line: 121
    arg15.ClientFighterCharacter.Died:Connect(function() -- line: 122
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_ClearFallingSound()
    end)
end

return t
