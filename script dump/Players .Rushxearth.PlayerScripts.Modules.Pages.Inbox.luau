local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local Notifications_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Notifications")
)
local NotificationSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("NotificationSlot")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 15
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.NotificationQueued = Signal_m.new()
    t_1.NotificationAdded = Signal_m.new()
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.SlotsFrame = t_1.Container:WaitForChild("Slots")
    t_1.SlotsContainer = t_1.SlotsFrame:WaitForChild("Container")
    t_1.SlotsLayout = t_1.SlotsContainer:WaitForChild("Layout")
    t_1._layout_order = 0
    t_1._notification_queue = {}
    t_1._notification_slots = {}
    t_1._notification_queued_debounce = false
    t_1._notification_added_debounce = false
    t_1:_Init()

    return t_1
end

function t.GetNumNewNotifications(arg1) -- line: 44
    return #arg1._notification_queue
end

function t.GetNumOldNotifications(arg2) -- line: 48
    return #arg2._notification_slots
end

function t.GetNumNotifications(arg3) -- line: 52
    return arg3:GetNumNewNotifications() + arg3:GetNumOldNotifications()
end

function t.AddNotification(arg4, arg5) -- line: 56
    -- upvalues:
    --  [1] NotificationSlot_m (copy)

    arg4._layout_order += 1
    local v7 = NotificationSlot_m.new(
        arg5[1],
        arg5[2],
        arg5[3],
        arg5[4],
        arg5[5]
    )
    v7.Frame.LayoutOrder = -arg4._layout_order
    v7.Frame.ZIndex = -arg4._layout_order
    v7:SetParent(arg4.SlotsContainer)
    v7:UpdateAge()
    table.insert(arg4._notification_slots, 1, v7)
    local removedValue = table.remove(arg4._notification_slots, 50)

    if removedValue then
        removedValue:Destroy()
    end

    arg4._notification_added_debounce = true
    task.defer(function() -- line: 74
        -- upvalues:
        --  [1] arg4 (copy)

        if not arg4._notification_added_debounce then
            return
        end

        arg4._notification_added_debounce = false
        arg4.NotificationAdded:Fire()
    end)
    arg4:UpdateAges()
end

function t.QueueNotification(arg6, ...) -- line: 86
    local t_2 = { ... }
    t_2[5] = tick()

    if arg6._is_open then
        arg6:AddNotification(t_2)

        return
    end

    table.insert(arg6._notification_queue, t_2)
    arg6._notification_queued_debounce = true
    task.defer(function() -- line: 99
        -- upvalues:
        --  [1] arg6 (copy)

        if not arg6._notification_queued_debounce then
            return
        end

        arg6._notification_queued_debounce = false
        arg6.NotificationQueued:Fire()
    end)
end

function t.GenerateQueue(arg7) -- line: 109
    for index = math.max(1, #arg7._notification_queue - 50), #arg7._notification_queue do
        arg7:AddNotification(arg7._notification_queue[index])
    end

    arg7._notification_queue = {}
end

function t.UpdateAges(arg8) -- line: 117
    for _, val in pairs(arg8._notification_slots) do
        val:UpdateAge()
    end
end

function t.Open(arg9, ...) -- line: 123
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg9, ...)
    arg9:GenerateQueue()
    arg9:UpdateAges()
end

function t._Init(arg10) -- line: 133
    -- upvalues:
    --  [1] Notifications_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg10.CloseButton.MouseButton1Click:Connect(function() -- line: 134
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:CloseRequest()
    end)
    arg10.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 138
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.List.CanvasSize = UDim2.new(0, 0, 0, arg10.Layout.AbsoluteContentSize.Y)
        local List_1 = arg10.List
        List_1.Active = arg10.Layout.AbsoluteContentSize.Y >= arg10.List.AbsoluteSize.Y
    end)
    arg10.SlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 143
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.SlotsFrame.Size = UDim2.new(1, 0, 0, arg10.SlotsLayout.AbsoluteContentSize.Y)
    end)
    Notifications_m.NotificationSent:Connect(function(...) -- line: 147
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:QueueNotification(...)
    end)
    ButtonEffect_m:Add(arg10.CloseButton)
end

return t._new()
