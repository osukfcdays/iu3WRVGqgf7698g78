local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController")
)
local BaseMatchmakingQueueSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseMatchmakingQueueSlot")
)
local MatchmakingQueueSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "MatchmakingQueueSlot"
)
local t = setmetatable({}, BaseMatchmakingQueueSlot_m)
t.__index = t

function t.new(arg1, arg2) -- line: 16
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] BaseMatchmakingQueueSlot_m (copy)
    --  [3] MatchmakingQueueSlot (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] t (copy)
    --  [6] Signal_m (copy)

    assert(DuelLibrary_m.MatchmakingQueues[arg1], arg1)
    local t_1 = setmetatable(
        BaseMatchmakingQueueSlot_m.new(
            MatchmakingQueueSlot:Clone(),
            nil,
            if arg1 ~= CONSTANTS_m.BEGINNER_QUEUE_NAME then false else true
        ),
        t
    )
    t_1.QueueStatus = Signal_m.new()
    t_1.QueueName = arg1
    t_1.Container = arg2
    t_1._queue_info = DuelLibrary_m.MatchmakingQueues[t_1.QueueName]
    t_1._y_scale = t_1.Container:GetAttribute("YScale") or 1
    t_1:_Init()

    return t_1
end

function t.Destroy(arg3) -- line: 38
    -- upvalues:
    --  [1] BaseMatchmakingQueueSlot_m (copy)

    arg3.QueueStatus:Destroy()
    BaseMatchmakingQueueSlot_m.Destroy(arg3)
end

function t._UpdateLayouts(arg4) -- line: 47
    arg4.Frame.Button.Tooltip.Background.Size = UDim2.new(
        0,
        arg4.Frame.Button.Tooltip.Title.TextBounds.X + arg4.Frame.Button.Tooltip.AbsoluteSize.X * 1,
        1,
        0
    )
end

function t._Setup(arg5) -- line: 51
    arg5.Container.BackgroundTransparency = 1
    arg5.Container.BorderSizePixel = 0
    local Title = arg5.Frame.Button.Title
    Title.Size = UDim2.new(
        arg5.Frame.Button.Title.Size.X.Scale,
        arg5.Frame.Button.Title.Size.X.Offset,
        arg5.Frame.Button.Title.Size.Y.Scale * arg5._y_scale,
        arg5.Frame.Button.Title.Size.Y.Offset * arg5._y_scale
    )
    local Title_1 = arg5.Frame.Button.Title
    Title_1.Position = UDim2.new(
        arg5.Frame.Button.Title.Position.X.Scale,
        arg5.Frame.Button.Title.Position.X.Offset,
        0.5 + (arg5.Frame.Button.Title.Position.Y.Scale - 0.5) * arg5._y_scale,
        0.5 + (arg5.Frame.Button.Title.Position.Y.Offset - 0.5) * arg5._y_scale
    )
    local Description = arg5.Frame.Button.Description
    Description.Size = UDim2.new(
        arg5.Frame.Button.Description.Size.X.Scale,
        arg5.Frame.Button.Description.Size.X.Offset,
        arg5.Frame.Button.Description.Size.Y.Scale * arg5._y_scale,
        arg5.Frame.Button.Description.Size.Y.Offset * arg5._y_scale
    )
    local Description_1 = arg5.Frame.Button.Description
    Description_1.Position = UDim2.new(
        arg5.Frame.Button.Description.Position.X.Scale,
        arg5.Frame.Button.Description.Position.X.Offset,
        0.5 + (arg5.Frame.Button.Description.Position.Y.Scale - 0.5) * arg5._y_scale,
        0.5 + (arg5.Frame.Button.Description.Position.Y.Offset - 0.5) * arg5._y_scale
    )
    local BottomLeft = arg5.Frame.Button.BottomLeft
    BottomLeft.Size = UDim2.new(
        arg5.Frame.Button.BottomLeft.Size.X.Scale * arg5._y_scale,
        arg5.Frame.Button.BottomLeft.Size.X.Offset * arg5._y_scale,
        arg5.Frame.Button.BottomLeft.Size.Y.Scale * arg5._y_scale,
        arg5.Frame.Button.BottomLeft.Size.Y.Offset * arg5._y_scale
    )
    local v6 = arg5._queue_info and arg5._queue_info.AreStreaksDisabled
    local Thumbnail = arg5.Frame.Button.Thumbnail
    local v7 = arg5._queue_info and arg5._queue_info.Thumbnail or ""
    Thumbnail.Image = v7
    local Description_2 = arg5.Frame.Button.Description
    v7 = arg5._queue_info and arg5._queue_info.Description or ""
    Description_2.Text = v7
    local Title_2 = arg5.Frame.Button.Title
    v7 = arg5._queue_info and arg5._queue_info.DisplayName or ""
    Title_2.Text = v7
    local Title_3 = arg5.Frame.Button.Title
    v7 = if arg5.Frame.Button.Description.Text ~= "" then arg5.Frame.Button.Title.Position else UDim2.new(
        0.5,
        0,
        0.5,
        0
    ) or arg5.Frame.Button.Title.Position
    Title_3.Position = v7
    local StreaksDisabled = arg5.Frame.Button.BottomLeft.StreaksDisabled
    v7 = v6 and v6() or false
    StreaksDisabled.Visible = v7
    v7 = arg5._queue_info
    local Tooltip = arg5.Frame.Button.Tooltip
    v7 = v7 and arg5._queue_info.Tooltip ~= nil
    Tooltip.Visible = v7
    local Title_4 = arg5.Frame.Button.Tooltip.Title
    v7 = arg5._queue_info and arg5._queue_info.Tooltip or ""
    Title_4.Text = v7
    arg5.Frame.Parent = arg5.Container
end

function t._Init(arg6) -- line: 117
    -- upvalues:
    --  [1] MatchmakingController_m (copy)

    arg6.Clicked:Connect(function() -- line: 118
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] MatchmakingController_m (ref)

        arg6.QueueStatus:Fire(MatchmakingController_m:QueueInto(arg6.QueueName))
    end)
    arg6.Frame.Button.Tooltip.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 122
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateLayouts()
    end)
    arg6.Frame.Button.Tooltip:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 126
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateLayouts()
    end)
    arg6:_Setup()
    arg6:_UpdateLayouts()
end

return t
