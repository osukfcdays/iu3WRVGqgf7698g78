local Players = game:GetService("Players")
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local ParticipationPrize_m = require(script:WaitForChild("ParticipationPrize"))
local GloryPayout_m = require(script:WaitForChild("GloryPayout"))
local ELOShield_m = require(script:WaitForChild("ELOShield"))
local TopReward_m = require(script:WaitForChild("TopReward"))
local Countdown_m = require(script:WaitForChild("Countdown"))
local Locked_m = require(script:WaitForChild("Locked"))
local Header_m = require(script:WaitForChild("Header"))
local Queues_m = require(script:WaitForChild("Queues"))
local Rank_m = require(script:WaitForChild("Rank"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 19
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)
    --  [4] ParticipationPrize_m (copy)
    --  [5] GloryPayout_m (copy)
    --  [6] ELOShield_m (copy)
    --  [7] TopReward_m (copy)
    --  [8] Countdown_m (copy)
    --  [9] Locked_m (copy)
    --  [10] Header_m (copy)
    --  [11] Queues_m (copy)
    --  [12] Rank_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.UnlockedFrame = t_1.PageFrame:WaitForChild("Unlocked")
    t_1.CloseButton = t_1.UnlockedFrame:WaitForChild("Close")
    t_1.List = t_1.UnlockedFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1.ParticipationPrize = ParticipationPrize_m.new(t_1)
    t_1.GloryPayout = GloryPayout_m.new(t_1)
    t_1.ELOShield = ELOShield_m.new(t_1)
    t_1.TopReward = TopReward_m.new(t_1)
    t_1.Countdown = Countdown_m.new(t_1)
    t_1.Locked = Locked_m.new(t_1)
    t_1.Header = Header_m.new(t_1)
    t_1.Queues = Queues_m.new(t_1)
    t_1.Rank = Rank_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.CloseRequest(arg1) -- line: 49
    arg1.OpenPage:Fire("Matchmaking")
end

function t.Open(arg2, ...) -- line: 53
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg2, ...)
    arg2.ParticipationPrize:Open()
    arg2.GloryPayout:Open()
    arg2.ELOShield:Open()
    arg2.TopReward:Open()
    arg2.Countdown:Open()
    arg2.Locked:Open()
    arg2.Header:Open()
    arg2.Queues:Open()
    arg2.Rank:Open()
end

function t.Close(arg3, ...) -- line: 67
    -- upvalues:
    --  [1] Page_m (copy)

    arg3.ParticipationPrize:Close()
    arg3.GloryPayout:Close()
    arg3.TopReward:Close()
    arg3.ELOShield:Close()
    arg3.Countdown:Close()
    arg3.Locked:Close()
    arg3.Header:Close()
    arg3.Queues:Close()
    arg3.Rank:Close()
    Page_m.Close(arg3, ...)
end

function t._UpdateList(arg4) -- line: 85
    arg4.CloseButton.Position = UDim2.new(0.975, 0, 0.0225, arg4.PageFrame.AbsoluteSize.Y * 0.125)
    arg4.List.Position = UDim2.new(0.5, 9, 0, arg4.PageFrame.AbsoluteSize.Y * 0.125)
    arg4.List.Size = UDim2.new(0.85, 0, 0, arg4.PageFrame.AbsoluteSize.Y * 0.75)
    arg4.List.CanvasSize = UDim2.new(0, 0, 0, arg4.Layout.AbsoluteContentSize.Y)
end

function t._Init(arg5) -- line: 92
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg5.CloseButton.MouseButton1Click:Connect(function() -- line: 93
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:CloseRequest()
    end)
    arg5.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 97
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateList()
    end)
    arg5.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 101
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateList()
    end)
    arg5:_UpdateList()
    ButtonEffect_m:Add(arg5.CloseButton)
end

return t._new()
