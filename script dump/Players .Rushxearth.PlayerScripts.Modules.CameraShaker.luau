local t = {}
t.__index = t
local debug_profilebegin = debug.profilebegin
local debug_profileend = debug.profileend
local New = CFrame.new
local Angles = CFrame.Angles
local math_rad = math.rad
local vec3 = Vector3.new()
local CameraShakeInstance_m = require(script.CameraShakeInstance)
local CameraShakeState = CameraShakeInstance_m.CameraShakeState
t.CameraShakeInstance = CameraShakeInstance_m
t.Presets = require(script.CameraShakePresets)

function t.new(arg1, arg2) -- line: 87
    -- upvalues:
    --  [1] vec3 (copy)
    --  [2] t (copy)

    assert(
        if type(arg1) ~= "number" then false else true,
        "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)"
    )
    assert(if type(arg2) ~= "function" then false else true, "Callback must be a function")

    return (setmetatable(
        {
            _running = false,
            _renderName = "CameraShaker",
            _renderPriority = arg1,
            _posAddShake = vec3,
            _rotAddShake = vec3,
            _camShakeInstances = {},
            _removeInstances = {},
            _callback = arg2
        },
        t
    ))
end

function t.Start(arg3) -- line: 108
    -- upvalues:
    --  [1] debug_profilebegin (copy)
    --  [2] debug_profileend (copy)

    if arg3._running then
        return
    end

    arg3._running = true
    local Callback = arg3._callback
    game:GetService("RunService"):BindToRenderStep(arg3._renderName, arg3._renderPriority, function(
        arg4
    ) -- line: 112
        -- upvalues:
        --  [1] debug_profilebegin (ref)
        --  [2] arg3 (copy)
        --  [3] debug_profileend (ref)
        --  [4] Callback (copy)

        debug_profilebegin("CameraShakerUpdate")
        local v2 = arg3:Update(arg4)
        debug_profileend()
        Callback(v2)
    end)
end

function t.Stop(arg5) -- line: 121
    if not arg5._running then
        return
    end

    game:GetService("RunService"):UnbindFromRenderStep(arg5._renderName)
    arg5._running = false
end

function t.StopSustained(arg6, arg7) -- line: 128
    for _, val in pairs(arg6._camShakeInstances) do
        if val.fadeOutDuration == 0 then
            val:StartFadeOut(arg7 or val.fadeInDuration)
        end
    end
end

function t.Update(arg8, arg9) -- line: 137
    -- upvalues:
    --  [1] vec3 (copy)
    --  [2] CameraShakeState (copy)
    --  [3] New (copy)
    --  [4] Angles (copy)
    --  [5] math_rad (copy)

    local v5 = vec3
    local v6 = vec3
    local CamShakeInstances = arg8._camShakeInstances

    for index = 1, #CamShakeInstances do
        local v7 = CamShakeInstances[index]
        local state = v7:GetState()

        if state == CameraShakeState.Inactive and v7.DeleteOnInactive then
            arg8._removeInstances[#arg8._removeInstances + 1] = index
        elseif state ~= CameraShakeState.Inactive then
            local v8 = v7:UpdateShake(arg9)
            v5 += v8 * v7.PositionInfluence
            v6 += v8 * v7.RotationInfluence
        end
    end

    for index_1 = #arg8._removeInstances, 1, -1 do
        table.remove(CamShakeInstances, arg8._removeInstances[index_1])
        arg8._removeInstances[index_1] = nil
    end

    return New(v5) * Angles(0, math_rad(v6.Y), 0) * Angles(math_rad(v6.X), 0, (math_rad(v6.Z)))
end

function t.Shake(arg10, arg11) -- line: 174
    assert(
        if type(arg11) == "table" then arg11._camShakeInstance else false,
        "ShakeInstance must be of type CameraShakeInstance"
    )
    arg10._camShakeInstances[#arg10._camShakeInstances + 1] = arg11

    return arg11
end

function t.ShakeSustain(arg12, arg13) -- line: 181
    assert(
        if type(arg13) == "table" then arg13._camShakeInstance else false,
        "ShakeInstance must be of type CameraShakeInstance"
    )
    arg12._camShakeInstances[#arg12._camShakeInstances + 1] = arg13
    arg13:StartFadeIn(arg13.fadeInDuration)

    return arg13
end

function t.ShakeOnce(
    arg14,
    arg15,
    arg16,
    arg17,
    arg18,
    arg19,
    arg20
) -- line: 189
    -- upvalues:
    --  [1] CameraShakeInstance_m (copy)

    local v16 = CameraShakeInstance_m.new(arg15, arg16, arg17, arg18)
    v16.PositionInfluence = typeof(arg19) == "Vector3" and arg19 or Vector3.new(0.15, 0.15, 0.15)
    v16.RotationInfluence = typeof(arg20) == "Vector3" and arg20 or Vector3.new(1, 1, 1)
    arg14._camShakeInstances[#arg14._camShakeInstances + 1] = v16

    return v16
end

function t.StartShake(
    arg21,
    arg22,
    arg23,
    arg24,
    arg25,
    arg26
) -- line: 198
    -- upvalues:
    --  [1] CameraShakeInstance_m (copy)

    local v18 = CameraShakeInstance_m.new(arg22, arg23, arg24)
    v18.PositionInfluence = typeof(arg25) == "Vector3" and arg25 or Vector3.new(0.15, 0.15, 0.15)
    v18.RotationInfluence = typeof(arg26) == "Vector3" and arg26 or Vector3.new(1, 1, 1)
    v18:StartFadeIn(arg24)
    arg21._camShakeInstances[#arg21._camShakeInstances + 1] = v18

    return v18
end

return t
