local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("UserInputService")
local _ = game:GetService("GuiService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local Prompts = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompts")
local t = {}
t.__index = t

function t.new(arg1) -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    assert(
        if typeof(arg1) == "Instance" then arg1:IsA("ImageButton") else false,
        "Argument 1 invalid, expected an ImageButton, got " .. tostring(arg1)
    )
    local t_1 = setmetatable({}, t)
    t_1.PromptAdded = Signal_m.new()
    t_1.PromptRemoved = Signal_m.new()
    t_1.PromptsFrame = arg1
    t_1.PromptsFrameBackground = t_1.PromptsFrame:WaitForChild("Background")
    t_1.CurrentPrompt = nil
    t_1._locked = false
    t_1:_Init()

    return t_1
end

function t.GetDefaultElement(arg2) -- line: 41
    local v2 = arg2.CurrentPrompt

    if v2 then
        v2 = arg2.CurrentPrompt:GetDefaultElement()
    end

    return v2
end

function t.Lock(arg3, arg4) -- line: 46
    assert(
        if typeof(arg4) ~= "boolean" then false else true,
        "Argument 1 invalid, expected a boolean, got " .. tostring(arg4)
    )
    arg3._locked = arg4
end

function t.Open(arg5, arg6, ...) -- line: 53
    -- upvalues:
    --  [1] Prompts (copy)
    --  [2] Utility_m (copy)

    assert(
        not arg6 or (if typeof(arg6) ~= "string" then false else true),
        "Argument 1 invalid, expected a string or nil, got " .. tostring(arg6)
    )
    arg5:Close(true)

    if arg6 then
        local v5 = require(Prompts[arg6])
        assert(v5.GetDefaultElement, "You forgot to implement " .. arg6 .. ":GetDefaultElement()")
        assert(v5.CloseRequest, "You forgot to implement " .. arg6 .. ":CloseRequest()")
        assert(v5.Open, "You forgot to implement " .. arg6 .. ":Open()")
        assert(v5.Destroy, "You forgot to implement " .. arg6 .. ":Destroy()")
        arg5.CurrentPrompt = v5.new(...)
        arg5.CurrentPrompt.Closed:Connect(function() -- line: 68
            -- upvalues:
            --  [1] arg5 (copy)

            arg5:Close()
        end)
        arg5.CurrentPrompt.OpenPrompt:Connect(function(...) -- line: 72
            -- upvalues:
            --  [1] arg5 (copy)

            arg5:Open(...)
        end)
        arg5.CurrentPrompt:Open(arg5.PromptsFrame)
        local CurrentPrompt = arg5.CurrentPrompt
        arg5.PromptsFrame.Visible = true
        task.spawn(
            Utility_m.RenderstepForLoop,
            Utility_m,
            (1 - arg5.PromptsFrameBackground.BackgroundTransparency) * 100,
            100,
            4,
            function(arg7) -- line: 82
                -- upvalues:
                --  [1] arg5 (copy)
                --  [2] CurrentPrompt (copy)

                if arg5.CurrentPrompt ~= CurrentPrompt then
                    return true
                end

                arg5.PromptsFrameBackground.BackgroundTransparency = 1 + -0.667 * (1 - (1 - arg7 / 100) ^ 5)
            end
        )
        arg5.PromptAdded:Fire(arg5.CurrentPrompt)
    end

    return arg5.CurrentPrompt
end

function t.Close(arg8, arg9) -- line: 100
    -- upvalues:
    --  [1] Utility_m (copy)

    assert(
        not arg9 or (if typeof(arg9) ~= "boolean" then false else true),
        "Argument 1 invalid, expected a boolean or nil, got " .. tostring(arg9)
    )
    local CurrentPrompt_1 = arg8.CurrentPrompt

    if CurrentPrompt_1 then
        arg8.CurrentPrompt = nil
        arg8:Lock(false)
        CurrentPrompt_1:Destroy()
        arg8.PromptRemoved:Fire(CurrentPrompt_1)

        if arg9 then
            return
        end

        task.spawn(function() -- line: 115
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] arg8 (copy)

            Utility_m:RenderstepForLoop(arg8.PromptsFrameBackground.BackgroundTransparency * 100, 100, 10, function(
                arg10
            ) -- line: 116
                -- upvalues:
                --  [1] arg8 (ref)

                if arg8.CurrentPrompt then
                    return true
                end

                arg8.PromptsFrameBackground.BackgroundTransparency = 0.333 + 0.667 * (arg10 / 100)
            end)
            arg8.PromptsFrame.Visible = if arg8.CurrentPrompt == nil then false else true
        end)
    end
end

function t.Destroy(arg11) -- line: 131
    arg11:Close(true)
    arg11.PromptAdded:Destroy()
    arg11.PromptRemoved:Destroy()
end

function t._IsMouseWithinPromptBounds(arg12) -- line: 141
    -- upvalues:
    --  [1] UILibrary_m (copy)

    if arg12._locked then
        return true
    end

    local v9 = arg12.CurrentPrompt and arg12.CurrentPrompt.PromptFrame
    local v10 = v9

    if v10 then
        v10 = UILibrary_m:IsMouseWithinBounds(v9.AbsolutePosition, v9.AbsoluteSize)
    end

    return v10
end

function t._Init(arg13) -- line: 151
    arg13.PromptsFrame.MouseButton1Click:Connect(function() -- line: 152
        -- upvalues:
        --  [1] arg13 (copy)

        if not arg13:_IsMouseWithinPromptBounds() then
            arg13:Close()
        end
    end)
end

return t
