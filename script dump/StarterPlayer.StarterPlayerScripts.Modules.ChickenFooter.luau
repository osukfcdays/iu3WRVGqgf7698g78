local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local FunFacts_m = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FunFacts"))
local ChickenFooter = Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild(
    "UserInterface"
):WaitForChild("ChickenFooter")
local t = {
    Chicken = "rbxassetid://133917828562858",
    Sensei = "rbxassetid://118135633428557",
    Nosniy = "rbxassetid://132709758724537",
    Neko = "rbxassetid://77873164738983",
    Bandoboy = "rbxassetid://121503061771505"
}
local t_1 = {
    "00bandoboy wuz here",
    "00nly my followers can play my secret gamemode in Private Servers"
}
local t_2 = {}
t_2.__index = t_2

function t_2.new() -- line: 22
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] ChickenFooter (copy)

    local t_3 = setmetatable({}, t_2)
    t_3.Frame = ChickenFooter:Clone()
    t_3.Picture = t_3.Frame:WaitForChild("Picture")
    t_3.PictureButton = t_3.Picture:WaitForChild("Button")
    t_3.TimerText = t_3.Frame:WaitForChild("Timer")
    t_3.StatusText = t_3.Frame:WaitForChild("Status")
    t_3.DescriptionFrame = t_3.Frame:WaitForChild("Description")
    t_3.DescriptionTitle = t_3.DescriptionFrame:WaitForChild("Title")
    t_3.DescriptionBackground = t_3.DescriptionFrame:WaitForChild("Background")
    t_3._connections = {}
    t_3._description_original_size = t_3.DescriptionFrame.Size
    t_3._picture_original_size = t_3.Picture.Size
    t_3._timer_hash = 0
    t_3._fun_facts_enabled = false
    t_3._last_fun_fact = nil
    t_3._is_shown = nil
    t_3:_Init()

    return t_3
end

function t_2.SetParent(arg1, arg2) -- line: 51
    arg1.Frame.Parent = arg2
end

function t_2.SetStatus(arg3, arg4) -- line: 55
    arg3.StatusText.Text = arg4 or ""
end

function t_2.SetTimer(arg5, arg6) -- line: 59
    arg5.TimerText.Text = arg6 or ""
end

function t_2.SetPicture(arg7, arg8) -- line: 63
    -- upvalues:
    --  [1] t (copy)

    arg7.Picture.Image = t[arg8] or ""
end

function t_2.SetMessage(arg9, arg10) -- line: 67
    -- upvalues:
    --  [1] Players (copy)

    local v2 = arg10 or ""
    local v3 = if v2 ~= "" then false else true
    arg9.DescriptionTitle.Text = v2
    arg9.DescriptionFrame.Visible = not v3
    local DescriptionOriginalSize = arg9._description_original_size
    local udim2 = if v3 then UDim2.new(0.075, 0, 1.5, 0) else UDim2.new(0.075, 0, 1, 0)
    local PictureOriginalSize = arg9._picture_original_size

    if arg9.Frame:IsDescendantOf(Players) then
        arg9.Picture:TweenPosition(
            udim2,
            "Out",
            "Quint",
            0.25,
            true
        )

        if not v3 then
            arg9.Picture.Size = UDim2.new(
                PictureOriginalSize.X.Scale * 0.8,
                0,
                PictureOriginalSize.Y.Scale * 1.2,
                0
            )
            arg9.Picture:TweenSize(
                PictureOriginalSize,
                "Out",
                "Back",
                0.5,
                true
            )
            arg9.DescriptionFrame.Size = UDim2.new(
                DescriptionOriginalSize.X.Scale * 0.8,
                0,
                DescriptionOriginalSize.Y.Scale * 1.2,
                0
            )
            arg9.DescriptionFrame:TweenSize(
                DescriptionOriginalSize,
                "Out",
                "Back",
                0.25,
                true
            )
        end
    else
        arg9.Picture.Position = udim2
        arg9.Picture.Size = PictureOriginalSize
        arg9.DescriptionFrame.Size = DescriptionOriginalSize
    end

    arg9:_Update()
end

function t_2.EnableFunFacts(arg11) -- line: 97
    if arg11._fun_facts_enabled then
        return
    end

    arg11._fun_facts_enabled = true
    arg11:_NewFunFact()
end

function t_2.DisableFunFacts(arg12) -- line: 106
    if not arg12._fun_facts_enabled then
        return
    end

    arg12._fun_facts_enabled = false
end

function t_2.EnableTimer(arg13) -- line: 114
    task.spawn(function() -- line: 115
        -- upvalues:
        --  [1] arg13 (copy)

        local v5 = arg13
        v5._timer_hash += 1
        local TimerHash = arg13._timer_hash

        for index = 0, math.huge do
            arg13:SetTimer(index)
            wait(1)

            if TimerHash ~= arg13._timer_hash then
                return
            end
        end
    end)
end

function t_2.DisableTimer(arg14) -- line: 131
    arg14._timer_hash += 1
end

function t_2.Show(arg15) -- line: 135
    if arg15._is_shown then
        return
    end

    arg15._is_shown = true
    arg15.TimerText.Visible = true
    arg15.StatusText.Visible = true
end

function t_2.Hide(arg16) -- line: 145
    if not arg16._is_shown then
        return
    end

    arg16._is_shown = false
    arg16:DisableFunFacts()
    arg16:DisableTimer()
    arg16:SetMessage(nil)
    arg16.TimerText.Visible = false
    arg16.StatusText.Visible = false
end

function t_2.Destroy(arg17) -- line: 158
    for _, val in pairs(arg17._connections) do
        val:Disconnect()
    end

    arg17:DisableTimer()
    arg17.Frame:Destroy()
end

function t_2._RandomPicture(arg18) -- line: 171
    -- upvalues:
    --  [1] t (copy)

    local t_4 = {}

    for key_1, _ in pairs(t) do
        table.insert(t_4, key_1)
    end

    arg18:SetPicture(t_4[math.random(#t_4)])
end

function t_2._NewFunFact(arg19) -- line: 181
    -- upvalues:
    --  [1] FunFacts_m (copy)
    --  [2] t_1 (copy)

    if not arg19._fun_facts_enabled then
        return
    end

    local v6 = nil

    for _ = 1, 10 do
        v6 = FunFacts_m()

        if v6 and v6 ~= arg19._last_fun_fact then
            break
        end
    end

    if table.find(t_1, v6) then
        arg19:SetPicture("Bandoboy")
        arg19:SetMessage(v6)

        return
    end

    arg19:SetPicture("Chicken")
    arg19:SetMessage(if string.sub(v6, 1, 19) == "Thanks for playing," then v6 else "" .. v6)
end

function t_2._Update(arg20) -- line: 205
    task.delay(0, function() -- line: 207
        -- upvalues:
        --  [1] arg20 (copy)

        arg20.DescriptionBackground.Size = UDim2.new(
            0.02,
            arg20.DescriptionTitle.TextBounds.X,
            1,
            0
        )
    end)
end

function t_2._Init(arg21) -- line: 212
    -- upvalues:
    --  [1] UserInputService (copy)

    arg21.PictureButton.MouseButton1Click:Connect(function() -- line: 213
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_NewFunFact()
    end)
    arg21.DescriptionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 217
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_Update()
    end)
    arg21.DescriptionTitle:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 221
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_Update()
    end)
    arg21.DescriptionTitle:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 225
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_Update()
    end)
    table.insert(arg21._connections, UserInputService.WindowFocused:Connect(function() -- line: 229
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_Update()
    end))
    table.insert(arg21._connections, UserInputService.WindowFocusReleased:Connect(function() -- line: 233
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_Update()
    end))
    arg21:_Update()
    arg21:SetPicture("Chicken")
    arg21:SetMessage(nil)
    arg21:SetStatus(nil)
    arg21:SetTimer(nil)
    arg21:Show()
end

return t_2
