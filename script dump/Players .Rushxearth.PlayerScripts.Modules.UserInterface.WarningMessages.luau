local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local GlowyBackground_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("GlowyBackground")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local WarningCard = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("WarningCard")
local t = {}
t.__index = t

function t._new() -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)
    --  [3] GlowyBackground_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("WarningMessages")
    t_1._glowy_background = GlowyBackground_m.new("WarningCard")
    t_1._message_queue = {}
    t_1._queue_started = false
    t_1:_Init()

    return t_1
end

function t.AddToQueue(arg1, arg2) -- line: 34
    if arg2.HasUnderstood then
        return
    end

    for _, val in pairs(arg1._message_queue) do
        if val.WarnID == arg2.WarnID then
            return
        end
    end

    table.insert(arg1._message_queue, arg2)
    task.defer(arg1._StartQueue, arg1)
end

function t._StartQueue(arg3) -- line: 53
    -- upvalues:
    --  [1] WarningCard (copy)
    --  [2] ButtonEffect_m (copy)
    --  [3] ReplicatedStorage (copy)

    if arg3._queue_started then
        return
    end

    arg3._queue_started = true
    arg3._glowy_background:SetEnabled(true)

    while true do
        if not (#arg3._message_queue > 0) then
            break
        end

        local v5 = arg3._message_queue[1]
        local v6 = WarningCard:Clone()
        v6.Container.Message.Description.Text = v5.WarnMessage
        v6.Container.Message.InvisibleDescription.Text = v5.WarnMessage
        v6.ZIndex = 9999999
        v6.Parent = arg3.Frame
        v6.Container.Position = UDim2.new(0.5, 0, 0.6, 0)
        v6.Container:TweenPosition(
            UDim2.new(0.5, 0, 0.5, 0),
            "Out",
            "Back",
            0.25,
            true
        )
        local v8 = v6.Container.Message
        local Description = v8.Description
        local InvisibleDescription = v8.InvisibleDescription

        function v8() --[[ update_text ]] -- line: 76
            -- upvalues:
            --  [1] Description (copy)
            --  [2] InvisibleDescription (copy)

            Description.Text = InvisibleDescription.Text
            Description.Size = UDim2.new(
                0.9,
                0,
                InvisibleDescription.Size.Y.Scale * math.ceil(
                    InvisibleDescription.TextBounds.X / Description.AbsoluteSize.X
                ),
                0
            )
        end

        InvisibleDescription:GetPropertyChangedSignal("AbsolutePosition"):Connect(v8)
        InvisibleDescription:GetPropertyChangedSignal("AbsoluteSize"):Connect(v8)
        InvisibleDescription:GetPropertyChangedSignal("TextBounds"):Connect(v8)
        InvisibleDescription:GetPropertyChangedSignal("Text"):Connect(v8)
        Description:GetPropertyChangedSignal("AbsoluteSize"):Connect(v8)
        Description.Text = InvisibleDescription.Text
        Description.Size = UDim2.new(
            0.9,
            0,
            InvisibleDescription.Size.Y.Scale * math.ceil(
                InvisibleDescription.TextBounds.X / Description.AbsoluteSize.X
            ),
            0
        )
        local Button = v6.Container.Button
        local FakeButton = v6.Container.FakeButton
        FakeButton.ResizeEffect.Size = UDim2.new(0, 0, 1, 0)
        FakeButton.ResizeEffect:TweenSize(
            UDim2.new(1, 0, 1, 0),
            "Out",
            "Linear",
            15,
            true
        )
        task.delay(15, function() -- line: 94
            -- upvalues:
            --  [1] Button (copy)
            --  [2] FakeButton (copy)

            Button.Visible = true
            FakeButton.Visible = false
        end)
        ButtonEffect_m:Add(Button, true)
        Button.MouseButton1Click:Wait()
        table.remove(arg3._message_queue, 1)
        v6:Destroy()
        ReplicatedStorage.Remotes.Misc.UnderstoodWarning:FireServer(v5.WarnID)
    end

    arg3._glowy_background:SetEnabled(false)
    arg3._queue_started = false
end

function t._UpdateQueue(arg4) -- line: 111
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    for _, val_1 in pairs(PlayerDataController_m:Get("ModerationWarningMessages")) do
        arg4:AddToQueue(val_1)
    end
end

function t._Setup(arg5) -- line: 117
    arg5._glowy_background:SetColor("Purple", Color3.fromRGB(80, 67, 0))
    arg5._glowy_background:SetColor("Purple2", Color3.fromRGB(0, 0, 0))
    arg5._glowy_background:SetColor("Yellow", Color3.fromRGB(255, 215, 0))
    arg5._glowy_background:SetParent(arg5.Frame)
end

function t._Init(arg6) -- line: 124
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    PlayerDataController_m:GetDataChangedSignal("ModerationWarningMessages"):Connect(function() -- line: 125
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateQueue()
    end)
    arg6:_Setup()
    arg6:_UpdateQueue()
end

return t._new()
