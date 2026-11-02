local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local DialogButton = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DialogButton")
local DialogPage = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DialogPage")
local Pages = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Pages")
local t = setmetatable({}, Page_m)
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] DialogPage (copy)
    --  [2] Pages (copy)
    --  [3] Page_m (copy)
    --  [4] t (copy)

    local v3 = DialogPage:Clone()
    v3.Name = arg1
    v3.Parent = Pages
    local t_1 = setmetatable(Page_m.new(arg1), t)
    t_1.Container = t_1.PageFrame:WaitForChild("Container")
    t_1.Background = t_1.Container:WaitForChild("Background")
    t_1.Arrow = t_1.Background:WaitForChild("Arrow")
    t_1.Message = t_1.Container:WaitForChild("Message")
    t_1.Picture = t_1.Container:WaitForChild("Picture")
    t_1.ButtonsFrame = t_1.Container:WaitForChild("Buttons")
    t_1.HidePartyDisplay = true
    t_1._close_callback = nil
    t_1._dialog_buttons = {}
    t_1._layout_order = 0
    t_1._buttons_hash = 0
    t_1._play_dialog_hash = 0
    t_1._picture_original_size = t_1.Picture.Size
    t_1._dialog_actions = {}
    t_1:_Init()

    return t_1
end

function t.PlayDialog(arg2, arg3) -- line: 48
    arg2._play_dialog_hash += 1
    local _ = arg2._play_dialog_hash

    if arg3.Message then
        arg2:_Message(arg3.Message.Picture, arg3.Message.Text, arg3.Message.SoundID)
    else
        arg2:_Clear()
    end

    if arg3.Buttons then
        for _, val in pairs(arg3.Buttons) do
            local v5 = arg2:_GetButtonAction(val.NextDialog, val.DialogActionKey)
            local v6 = val.IsCloseButton

            if v6 then
                v6 = Color3.fromRGB(255, 50, 50)
            end

            arg2:_CreateButton(val.Text, v5, v6, arg3.ButtonAppearDelay)
        end
    end

    if arg3.DelayedContinue then
        task.spawn(function() -- line: 71
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] arg3 (copy)

            local PlayDialogHash_1 = arg2._play_dialog_hash
            wait(arg3.DelayedContinue.Delay)

            if PlayDialogHash_1 ~= arg2._play_dialog_hash then
                return
            end

            arg2:_GetButtonAction(arg3.DelayedContinue.NextDialog)()
        end)
    end
end

function t.HookDialogActionKey(arg4, arg5, arg6) -- line: 85
    arg4._dialog_actions[arg5] = arg6
end

function t.Open(arg7, ...) -- line: 89
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg7, ...)
    arg7:_Clear()
end

function t.Close(arg8, ...) -- line: 94
    -- upvalues:
    --  [1] Page_m (copy)

    arg8:_Clear()
    Page_m.Close(arg8, ...)
end

function t._FetchDialog(arg9, arg10, ...) -- line: 103
    local IsOpenHash = arg9._is_open_hash
    local Success, Result = pcall(arg10.InvokeServer, arg10, ...)

    if IsOpenHash ~= arg9._is_open_hash then
        return
    end

    if not Success then
        warn("Failed to fetch dialog, error:", Result)
    end

    if not Success or not Result then
        arg9:CloseRequest()

        return
    end

    arg9:PlayDialog(Result)
end

function t._GetButtonAction(arg11, arg12, arg13) -- line: 124
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return function() -- line: 125
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] arg11 (copy)
        --  [3] arg13 (copy)
        --  [4] ReplicatedStorage (ref)

        if arg12 then
            arg11:PlayDialog(arg12)
        else
            arg11:CloseRequest()
        end

        if arg13 then
            if arg11._dialog_actions[arg13] then
                arg11._dialog_actions[arg13]()

                return
            end

            ReplicatedStorage.Remotes.Misc.DialogAction:FireServer(arg13)
        end
    end
end

function t._CreateButton(
    arg14,
    arg15,
    arg16,
    arg17,
    arg18
) -- line: 142
    -- upvalues:
    --  [1] DialogButton (copy)
    --  [2] ButtonEffect_m (copy)

    arg14._layout_order += 1
    local v8 = arg17 or Color3.fromRGB(84, 212, 42)
    local v9 = DialogButton:Clone()
    v9.Button.BackgroundColor3 = v8
    v9.Button.Container.Arrow.ImageColor3 = v8
    v9.Button.Container.Title.Text = arg15
    v9.LayoutOrder = arg14._layout_order
    v9.Parent = arg14.ButtonsFrame
    table.insert(arg14._dialog_buttons, v9)
    v8 = v9.Button
    local Container = v8.Container
    local Title = Container.Title

    local function update() -- line: 159
        -- upvalues:
        --  [1] v9 (copy)
        --  [2] Title (copy)
        --  [3] Container (copy)
        --  [4] v8 (copy)

        v9.Size = UDim2.new(
            0,
            (Title.TextBounds.X + Container.AbsoluteSize.X) / v8.Size.X.Scale,
            1,
            0
        )
        Title.Position = UDim2.new(1, -v9.AbsoluteSize.X / 2 * v8.Size.X.Scale, 0.5, 0)
    end

    Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
    v8:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
    Title:GetPropertyChangedSignal("TextBounds"):Connect(update)
    update()
    v8.MouseButton1Click:Connect(arg16)
    ButtonEffect_m:Add(v8)
    local v12 = arg18 or 0
    task.spawn(function() -- line: 172
        -- upvalues:
        --  [1] arg14 (copy)
        --  [2] v8 (copy)
        --  [3] v12 (copy)

        local ButtonsHash = arg14._buttons_hash
        v8.Visible = false
        wait(0.1 * (arg14._layout_order - 1) + v12)

        if ButtonsHash ~= arg14._buttons_hash then
            return
        end

        v8.Visible = true
        v8.Position = UDim2.new(0.75, 0, 0.5, 0)
        v8:TweenPosition(
            UDim2.new(0.5, 0, 0.5, 0),
            "Out",
            "Quint",
            0.5,
            true
        )
    end)
end

function t._ClearButtons(arg19) -- line: 189
    for _, val_1 in pairs(arg19._dialog_buttons) do
        val_1:Destroy()
    end

    arg19._dialog_buttons = {}
    arg19._layout_order = 0
    arg19._buttons_hash += 1
end

function t._Message(arg20, arg21, arg22, arg23) -- line: 199
    -- upvalues:
    --  [1] Players (copy)
    --  [2] Utility_m (copy)

    arg20:_ClearButtons()
    local v15 = arg21 or ""
    local v16 = arg22 or ""
    arg20.Message.Text = v16
    arg20.Picture.Image = v15
    local v17 = true
    local Background = arg20.Background

    if v16 == "" then
        v17 = v15 ~= ""
    end

    Background.Visible = v17
    local Arrow = arg20.Arrow
    Arrow.Visible = v15 ~= ""

    if arg20.Picture:IsDescendantOf(Players) then
        arg20.Picture.Size = UDim2.new(
            arg20._picture_original_size.X.Scale * 0.8,
            0,
            arg20._picture_original_size.Y.Scale * 1.2,
            0
        )
        arg20.Picture:TweenSize(
            arg20._picture_original_size,
            "Out",
            "Back",
            0.5,
            true
        )
    else
        arg20.Picture.Size = arg20._picture_original_size
    end

    if arg23 then
        Utility_m:CreateSound(
            arg23,
            1,
            1,
            script,
            true,
            10
        )
    end
end

function t._Clear(arg24) -- line: 222
    arg24:_Message(nil, nil, nil)
end

function t._Setup(arg25) -- line: 226
    function arg25._close_callback() -- line: 227
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:CloseRequest()
    end
end

function t._Init(arg26) -- line: 232
    arg26:_Setup()
    arg26:_Clear()
end

return t
