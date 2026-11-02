local FlagUtil_m = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
)
local ZoomController_m = require(script.Parent:WaitForChild("ZoomController"))
local UserFixCameraFPError = FlagUtil_m.getUserFlag("UserFixCameraFPError")
local t = {}
t.__index = t
local cframe = CFrame.new()

local _ = function(u1: CFrame) --[[ cframeToAxis ]] -- line: 17
    local v3, v4 = u1:ToAxisAngle()

    return v3 * v4
end

local _ = function(vec1: Vector3) --[[ axisToCFrame ]] -- line: 22
    -- upvalues:
    --  [1] cframe (copy)

    local Magnitude = vec1.Magnitude

    if Magnitude > 1E-05 then
        return CFrame.fromAxisAngle(vec1, Magnitude)
    end

    return cframe
end

local _ = function(u2: CFrame) --[[ extractRotation ]] -- line: 30
    local _, _, _, v8, v9, v10, v11, v12, v13, v14, v15, v16 = u2:GetComponents()

    return CFrame.new(
        0,
        0,
        0,
        v8,
        v9,
        v10,
        v11,
        v12,
        v13,
        v14,
        v15,
        v16
    )
end

function t.new() -- line: 35
    -- upvalues:
    --  [1] t (copy)

    return (setmetatable({ lastCFrame = nil }, t))
end

function t.Step(t1: table, n1: number, u3: CFrame) -- line: 41
    -- upvalues:
    --  [1] cframe (copy)

    local v26 = t1.lastCFrame or u3
    t1.lastCFrame = u3
    local Position = u3.Position
    local _, _, _, v30, v31, v32, v33, v34, v35, v36, v37, v38 = u3:GetComponents()
    local v39 = v30
    local v40 = v31
    local v41 = v32
    local v42 = v33
    local v43 = v34
    local v44 = v35
    local v45 = v36
    local v46 = v37
    local v47 = v38
    local cframe_1 = CFrame.new(
        0,
        0,
        0,
        v39,
        v40,
        v41,
        v42,
        v43,
        v44,
        v45,
        v46,
        v47
    )
    local _ = CFrame.new(
        0,
        0,
        0,
        v39,
        v40,
        v41,
        v42,
        v43,
        v44,
        v45,
        v46,
        v47
    )
    local P = v26.p
    local _, _, _, v51, v52, v53, v54, v55, v56, v57, v58, v59 = v26:GetComponents()
    local cframe_3 = CFrame.new(
        0,
        0,
        0,
        v51,
        v52,
        v53,
        v54,
        v55,
        v56,
        v57,
        v58,
        v59
    )
    local v69 = (Position - P) / n1
    local v70, v71 = (cframe_1 * cframe_3:inverse()):ToAxisAngle()
    local v72 = v70 * v71 / n1

    local function extrapolate(arg1) -- line: 56
        -- upvalues:
        --  [1] v69 (copy)
        --  [2] Position (copy)
        --  [3] v72 (copy)
        --  [4] cframe (ref)
        --  [5] cframe_1 (copy)

        local v73 = v69 * arg1 + Position
        local v74 = v72 * arg1
        local Magnitude_1 = v74.Magnitude

        return (if not (Magnitude_1 > 1E-05) then cframe else CFrame.fromAxisAngle(v74, Magnitude_1)) * cframe_1 + v73
    end

    return { extrapolate = extrapolate, posVelocity = v69, rotVelocity = v72 }
end

function t.Reset(arg2) -- line: 69
    arg2.lastCFrame = nil
end

local BaseOcclusion_m = require(script.Parent:WaitForChild("BaseOcclusion"))
local t_2 = setmetatable({}, BaseOcclusion_m)
t_2.__index = t_2

function t_2.new() -- line: 79
    -- upvalues:
    --  [1] BaseOcclusion_m (copy)
    --  [2] t_2 (copy)
    --  [3] t (copy)

    local t_3 = setmetatable(BaseOcclusion_m.new(), t_2)
    t_3.focusExtrapolator = t.new()

    return t_3
end

function t_2.GetOcclusionMode(_) -- line: 85
    return Enum.DevCameraOcclusionMode.Zoom
end

function t_2.Enable(arg4, _) -- line: 89
    arg4.focusExtrapolator:Reset()
end

function t_2.Update(
    arg6,
    arg7,
    arg8,
    arg9,
    _
) -- line: 93
    -- upvalues:
    --  [1] UserFixCameraFPError (copy)
    --  [2] ZoomController_m (copy)

    local v78 = if UserFixCameraFPError then CFrame.lookAlong(arg9.p, -arg8.LookVector) * CFrame.new(
        0,
        0,
        0,
        -1,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        -1
    ) else CFrame.new(arg9.p, arg8.p) * CFrame.new(
        0,
        0,
        0,
        -1,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        -1
    )
    local v80 = arg6.focusExtrapolator:Step(arg7, v78)
    local v82 = ZoomController_m.Update(arg7, v78, v80)

    return v78 * CFrame.new(0, 0, v82), arg9
end

function t_2.CharacterAdded(_, _, _) -- line: 117
end

function t_2.CharacterRemoving(_, _, _) -- line: 121
end

function t_2.OnCameraSubjectChanged(_, _) -- line: 124
end

return t_2
