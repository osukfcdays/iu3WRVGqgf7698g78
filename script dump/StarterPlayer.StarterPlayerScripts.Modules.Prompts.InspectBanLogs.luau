local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BanLibrary_m = require(ReplicatedStorage.Modules.BanLibrary)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local BanLogSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("BanLogSlot")
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
    --  [1] BanLogSlot (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] BanLibrary_m (copy)
    --  [4] Players (copy)

    local v4 = arg2._ban_data.BanHistory or {}
    local EmptyText = arg2.EmptyText
    EmptyText.Visible = #v4 == 0
    arg2.List.Visible = not arg2.EmptyText.Visible
    local v8

    for _, val in pairs(v4) do
        local v6 = BanLogSlot:Clone()
        v6.Picture.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, (tostring(val.Moderator)))
        v6.Date.Text = val.Date
        local Duration = v6.Duration
        local v7 = if val.Duration and val.Duration >= BanLibrary_m.PERMANENT_BAN_DURATION then "\226\136\158" else val.Duration and val.Duration .. "d" or ""
        Duration.Text = v7
        v6.Moderator.Text = "\226\128\162 \226\128\162 \226\128\162"
        v6.Reason.Text = val.Reason
        local Reason = v6.Reason

        if BanLibrary_m:IsBanLogANote(val) then
            v8 = Color3.fromRGB(127, 127, 127)

            if not v8 then
                v8 = BanLibrary_m:IsBanLogABan(val) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(
                    100,
                    255,
                    50
                )
            end
        else
            v8 = BanLibrary_m:IsBanLogABan(val) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(
                100,
                255,
                50
            )
        end

        Reason.TextColor3 = v8
        v6.Parent = arg2.Container
        task.spawn(function() -- line: 56
            -- upvalues:
            --  [1] v6 (copy)
            --  [2] Players (ref)
            --  [3] val (copy)

            local Moderator = v6.Moderator
            local Success, Result = pcall(Players.GetNameFromUserIdAsync, Players, val.Moderator)

            if Success then
                Moderator.Text = Result
            end
        end)
    end
end

function t._Init(arg3) -- line: 67
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg3.CloseButton.MouseButton1Click:Connect(function() -- line: 68
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:CloseRequest()
    end)
    arg3.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 72
        -- upvalues:
        --  [1] arg3 (copy)

        arg3.List.CanvasSize = UDim2.new(0, 0, 0, arg3.Layout.AbsoluteContentSize.Y)
    end)
    arg3:_Setup()
    ButtonEffect_m:Add(arg3.CloseButton)
end

return t
