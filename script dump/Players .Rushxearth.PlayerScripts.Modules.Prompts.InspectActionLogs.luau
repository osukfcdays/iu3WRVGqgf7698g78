local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.ModerationLibrary)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local ActionLogSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ActionLogSlot")
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1) -- line: 14
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.EmptyText = t_1.PromptFrame:WaitForChild("Empty")
    t_1.List = t_1.PromptFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._ban_data = arg1
    t_1:_Init()

    return t_1
end

function t._Setup(arg2) -- line: 40
    -- upvalues:
    --  [1] ActionLogSlot (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] Players (copy)

    local v4 = arg2._ban_data.ActionHistory or {}
    local EmptyText = arg2.EmptyText
    EmptyText.Visible = #v4 == 0
    arg2.List.Visible = not arg2.EmptyText.Visible

    for _, val in pairs(v4) do
        local v6 = ActionLogSlot:Clone()
        v6.Picture.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, (tostring(val.TargetUserID)))
        v6.Date.Text = os.date("%x", val.Timestamp) .. " " .. os.date("%X", val.Timestamp)
        v6.Target.Text = "\226\128\162 \226\128\162 \226\128\162"
        v6.Action.Text = val.Action
        v6.Parent = arg2.Container
        task.spawn(function() -- line: 54
            -- upvalues:
            --  [1] v6 (copy)
            --  [2] Players (ref)
            --  [3] val (copy)

            local Target = v6.Target
            local Success, Result = pcall(Players.GetNameFromUserIdAsync, Players, val.TargetUserID)

            if Success then
                Target.Text = Result
            end
        end)
    end
end

function t._Init(arg3) -- line: 65
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg3.CloseButton.MouseButton1Click:Connect(function() -- line: 66
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:CloseRequest()
    end)
    arg3.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg3 (copy)

        arg3.List.CanvasSize = UDim2.new(0, 0, 0, arg3.Layout.AbsoluteContentSize.Y)
    end)
    arg3:_Setup()
    ButtonEffect_m:Add(arg3.CloseButton)
end

return t
