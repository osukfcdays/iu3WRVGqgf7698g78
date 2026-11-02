local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("HapticService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local t = {}
t.__index = t

function t._new() -- line: 16
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t.ClickSound(_) -- line: 28
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://177266782",
        0.5,
        1,
        script,
        true,
        4
    )
end

function t.Add(arg2, arg3, arg4, arg5) -- line: 33
    -- upvalues:
    --  [1] Players (copy)

    local v1 = if typeof(arg3) == "Instance" then arg3:IsA("ImageButton") or arg3:IsA("TextButton") or arg3:IsA(
        "ClickDetector"
    ) else false
    assert(
        v1,
        "Argument 1 invalid, expected an ImageButton or TextButton or ClickDetector, got " .. tostring(
            arg3
        )
    )
    v1 = not arg4 or (if typeof(arg4) ~= "boolean" then false else true)
    assert(v1, "Argument 2 invalid, expected a boolean or nil, got " .. tostring(arg4))
    v1 = not arg5 or (if typeof(arg5) ~= "table" then false else true)
    assert(v1, "Argument 3 invalid, expected a table or nil, got " .. tostring(arg5))
    local v2 = arg5 and table.clone(arg5) or {}
    v2.Speed = v2.Speed or 1
    v2.PressRatio = v2.PressRatio or 0.875
    v2.HoverRatio = v2.HoverRatio or 1.125
    v2.ReleaseRatio = v2.ReleaseRatio or 1.125
    v2.TargetElement = v2.TargetElement or arg3
    v2.OnRelease = v2.OnRelease or nil
    v2.OnHover = v2.OnHover or nil
    v2.DontReposition = v2.DontReposition or nil
    local TargetElement = v2.TargetElement

    if arg3:IsA("ClickDetector") then
        arg3.MouseClick:Connect(function() -- line: 51
            -- upvalues:
            --  [1] arg2 (copy)

            arg2:ClickSound()
        end)

        return
    end

    local v4 = nil
    local v5 = nil
    local v6 = nil
    local v7 = nil

    local function update_original_size(arg6) -- line: 63
        -- upvalues:
        --  [1] v4 (ref)
        --  [2] v5 (ref)
        --  [3] v2 (copy)
        --  [4] v6 (ref)
        --  [5] v7 (ref)

        v4 = arg6
        v5 = typeof(v2.PressRatio) == "UDim2" and v4 + v2.PressRatio or UDim2.new(
            v4.X.Scale * v2.PressRatio,
            v4.X.Offset * v2.PressRatio,
            v4.Y.Scale * v2.PressRatio,
            v4.Y.Offset * v2.PressRatio
        )
        v6 = typeof(v2.HoverRatio) == "UDim2" and v4 + v2.HoverRatio or UDim2.new(
            v4.X.Scale * v2.HoverRatio,
            v4.X.Offset * v2.HoverRatio,
            v4.Y.Scale * v2.HoverRatio,
            v4.Y.Offset * v2.HoverRatio
        )
        v7 = typeof(v2.ReleaseRatio) == "UDim2" and v4 + v2.ReleaseRatio or UDim2.new(
            v4.X.Scale * v2.ReleaseRatio,
            v4.X.Offset * v2.ReleaseRatio,
            v4.Y.Scale * v2.ReleaseRatio,
            v4.Y.Offset * v2.ReleaseRatio
        )
    end

    update_original_size(TargetElement.Size)
    local v10 = false

    local function release() -- line: 92
        -- upvalues:
        --  [1] v10 (ref)
        --  [2] arg4 (copy)
        --  [3] TargetElement (copy)
        --  [4] Players (ref)
        --  [5] v7 (ref)
        --  [6] v4 (ref)
        --  [7] v2 (copy)

        if not v10 then
        end

        v10 = false

        if not arg4 then
            if TargetElement:IsDescendantOf(workspace) or TargetElement:IsDescendantOf(Players) then
                TargetElement.Size = v7
                TargetElement:TweenSize(
                    v4,
                    "Out",
                    "Back",
                    0.25,
                    true
                )
            else
                TargetElement.Size = v4
            end
        end

        if v2.OnRelease then
            v2.OnRelease()
        end
    end

    arg3.MouseButton1Up:Connect(release)
    arg3.MouseLeave:Connect(release)
    arg3.SelectionLost:Connect(release)

    local function hover() -- line: 119
        -- upvalues:
        --  [1] arg4 (copy)
        --  [2] TargetElement (copy)
        --  [3] Players (ref)
        --  [4] v6 (ref)
        --  [5] v2 (copy)

        if not arg4 then
            if TargetElement:IsDescendantOf(workspace) or TargetElement:IsDescendantOf(Players) then
                TargetElement:TweenSize(
                    v6,
                    "Out",
                    "Quint",
                    0.25,
                    true
                )
            else
                TargetElement.Size = v6
            end
        end

        if v2.OnHover then
            v2.OnHover()
        end
    end

    arg3.MouseEnter:Connect(hover)
    arg3.SelectionGained:Connect(hover)
    arg3.MouseButton1Down:Connect(function() --[[ press ]] -- line: 136
        -- upvalues:
        --  [1] v10 (ref)
        --  [2] arg4 (copy)
        --  [3] TargetElement (copy)
        --  [4] Players (ref)
        --  [5] v5 (ref)
        --  [6] arg2 (copy)

        v10 = true

        if not arg4 then
            if TargetElement:IsDescendantOf(workspace) or TargetElement:IsDescendantOf(Players) then
                TargetElement:TweenSize(
                    v5,
                    "Out",
                    "Quint",
                    0.25,
                    true
                )
            else
                TargetElement.Size = v5
            end
        end

        arg2:ClickSound()
    end)

    if not arg4 and not v2.DontReposition then
        local v11 = 0.5 - TargetElement.AnchorPoint.X
        local v12 = 0.5 - TargetElement.AnchorPoint.Y
        TargetElement.Position = TargetElement.Position + UDim2.new(
            TargetElement.Size.X.Scale * v11,
            TargetElement.Size.X.Offset * v11,
            TargetElement.Size.Y.Scale * v12,
            TargetElement.Size.Y.Offset * v12
        )
        TargetElement.AnchorPoint = Vector2.new(0.5, 0.5)
    end

    return { UpdateOriginalSize = update_original_size }
end

function t._Init(_) -- line: 169
end

return t._new()
