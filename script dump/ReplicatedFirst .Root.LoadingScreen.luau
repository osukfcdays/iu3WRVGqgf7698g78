local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RenderstepForLoop_m = require(
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild(
        "RenderstepForLoop"
    )
)
local BetterDebris_m = require(
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("BetterDebris")
)
local EventLibrary_m = require(
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EventLibrary")
)
local Signal_m = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Signal"))
local GlowyBackground_m = require(
    Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Modules"):WaitForChild(
        "GlowyBackground"
    )
)
local ChickenFooter_m = require(
    Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Modules"):WaitForChild(
        "ChickenFooter"
    )
)
local t = {}
t.__index = t

function t._new() -- line: 21
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] ChickenFooter_m (copy)
    --  [4] GlowyBackground_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.DeviceSelected = Signal_m.new()
    t_1.LoadingScreen = script:WaitForChild("LoadingScreen")
    t_1.MainFrame = t_1.LoadingScreen:WaitForChild("MainFrame")
    t_1.Device = t_1.MainFrame:WaitForChild("Device")
    t_1.DeviceTitle = t_1.Device:WaitForChild("Title")
    t_1.ConfirmDeviceButton = t_1.Device:WaitForChild("Confirm")
    t_1.Controls = t_1.Device:WaitForChild("Controls")
    t_1.DesktopButton = t_1.Controls:WaitForChild("Desktop")
    t_1.ConsoleButton = t_1.Controls:WaitForChild("Console")
    t_1.MobileButton = t_1.Controls:WaitForChild("Mobile")
    t_1.GameLogo = t_1.MainFrame:WaitForChild("GameLogo")
    t_1.Logo = t_1.MainFrame:WaitForChild("Logo")
    t_1.LogoN = t_1.Logo:WaitForChild("N")
    t_1.ContainerN = t_1.LogoN:WaitForChild("Container")
    t_1.WhiteN = t_1.ContainerN:WaitForChild("White")
    t_1.BlackN = t_1.ContainerN:WaitForChild("Black")
    t_1.LogoG = t_1.Logo:WaitForChild("G")
    t_1.ContainerG = t_1.LogoG:WaitForChild("Container")
    t_1.WhiteG = t_1.ContainerG:WaitForChild("White")
    t_1.BlackG = t_1.ContainerG:WaitForChild("Black")
    t_1._blur = Instance.new("BlurEffect")
    t_1._connection = nil
    t_1._chosen_device = nil
    t_1._chicken_footer = ChickenFooter_m.new()
    t_1._glowy_background = GlowyBackground_m.new("LoadingScreen")
    t_1:_Init()

    return t_1
end

function t.Activate(arg1) -- line: 61
    -- upvalues:
    --  [1] Players (copy)
    --  [2] Lighting (copy)

    arg1.LoadingScreen.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    arg1._blur.Parent = Lighting
end

function t.PlayLogoAnimation(arg2, arg3) -- line: 67
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    assert(
        if typeof(arg3) ~= "number" then false else true,
        "Argument 1 invalid, expected a number, got " .. tostring(arg3)
    )
    arg2:_ResetLogo()
    arg2.Logo.Visible = true
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://6384899588"
    Sound.Volume = 1
    Sound.Parent = script
    Sound:Play()
    BetterDebris_m:AddItem(Sound, 20)
    arg2:_SpiralAnimation(arg3)
end

function t.SplitLogo(arg4) -- line: 84
    -- upvalues:
    --  [1] RenderstepForLoop_m (copy)

    arg4.Logo:TweenPosition(
        UDim2.new(0.5, 0, 1, 0),
        "In",
        "Back",
        0.75,
        true
    )
    arg4.LogoN:TweenPosition(
        UDim2.new(-0.5, 0, 0.5, 0),
        "InOut",
        "Sine",
        1.5,
        true
    )
    arg4.LogoG:TweenPosition(
        UDim2.new(1.5, 0, 0.5, 0),
        "InOut",
        "Sine",
        1.5,
        true
    )
    RenderstepForLoop_m(0, 100, 2, function(arg5) -- line: 92
        -- upvalues:
        --  [1] arg4 (copy)

        local v8 = (0 + 720 * (arg5 / 100) ^ 2) % 360
        arg4.LogoN.Rotation = -v8
        arg4.LogoG.Rotation = v8
    end)
end

function t.SetProgress(arg6, arg7, arg8) -- line: 102
    assert(
        if typeof(arg7) ~= "number" then false else true,
        "Argument 1 invalid, expected a number, got " .. tostring(arg7)
    )
    assert(
        if typeof(arg8) ~= "number" then false else true,
        "Argument 2 invalid, expected a number, got " .. tostring(arg8)
    )
    local udim2_3 = UDim2.new(1, 0, arg7, 0)
    local udim2_4 = UDim2.new(1, 0, 1 - arg7, 0)
    arg6.WhiteN:TweenSize(
        udim2_3,
        "Out",
        "Quint",
        arg8,
        true
    )
    arg6.BlackN:TweenSize(
        udim2_4,
        "Out",
        "Quint",
        arg8,
        true
    )
    arg6.WhiteG:TweenSize(
        udim2_3,
        "Out",
        "Quint",
        arg8,
        true
    )
    arg6.BlackG:TweenSize(
        udim2_4,
        "Out",
        "Quint",
        arg8,
        true
    )
end

function t.PickDevice(arg9, arg10) -- line: 116
    -- upvalues:
    --  [1] GuiService (copy)

    assert(
        if typeof(arg10) ~= "table" then false else true,
        "Argument 1 invalid, expected a table, got " .. tostring(arg10)
    )
    arg9.Device.Position = UDim2.new(0.5, 0, -0.5, 0)
    arg9.Device:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        1,
        true
    )
    arg9.Device.Visible = true
    arg9.DesktopButton.Visible = table.find(arg10, "Desktop")
    arg9.ConsoleButton.Visible = table.find(arg10, "Console")
    arg9.MobileButton.Visible = table.find(arg10, "Mobile")
    local v11 = GuiService
    v11.SelectedObject = arg9.ConsoleButton.Visible and arg9.ConsoleButton or nil
    local v13 = arg9.DeviceSelected:Wait()
    GuiService.SelectedObject = nil
    arg9.Device.Visible = false

    return v13
end

function t.PreRequireClient(arg11) -- line: 137
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    arg11.GameLogo.Visible = true
    arg11.GameLogo.Size = UDim2.new(1, 0, 1, 0)
    arg11.GameLogo:TweenSize(
        UDim2.new(0.6, 0, 0.6, 0),
        "Out",
        "Back",
        0.5,
        true
    )
    local Sound_1 = Instance.new("Sound")
    Sound_1.SoundId = "rbxassetid://8483887957"
    Sound_1.Volume = 1
    Sound_1.Parent = script
    Sound_1:Play()
    BetterDebris_m:AddItem(Sound_1, 20)
    wait(0.5)
end

function t.Close(arg12) -- line: 152
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] RenderstepForLoop_m (copy)

    arg12._connection:Disconnect()
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    arg12.MainFrame.Active = false
    arg12.GameLogo:TweenSize(
        UDim2.new(0, 0, 0, 0),
        "In",
        "Quint",
        1.5,
        true
    )
    arg12.GameLogo:TweenPosition(
        UDim2.new(0.5, 0, 1, 0),
        "In",
        "Quint",
        1.5,
        true
    )
    ReplicatedStorage.Remotes.Data.LoadingScreenDone:FireServer()
    arg12._chicken_footer:Hide()
    arg12._glowy_background:SetEnabled(false)
    wait(0.5)
    RenderstepForLoop_m(0, 100, 2, function(arg13) -- line: 167
        -- upvalues:
        --  [1] arg12 (copy)

        arg12.GameLogo.ImageTransparency = (arg13 / 100) ^ 3
        arg12._blur.Size = 56 * (1 - (1 - (1 - arg13 / 100) ^ 3))
    end)
    arg12:Destroy()
end

function t.Update(arg14, _) -- line: 177
    local v14 = tick() * 2 % 6.283185307179586
    local v15 = math.sin(v14) * 0.05
    local v16 = math.sin(v14 - 0.7853981633974483) * 0.05
    arg14.ContainerN.Position = UDim2.new(0.5, 0, v15 + 0.5, 0)
    arg14.ContainerG.Position = UDim2.new(0.5, 0, v16 + 0.5, 0)
end

function t.Destroy(arg16) -- line: 186
    arg16._blur:Destroy()
    arg16._chicken_footer:Destroy()
    arg16._glowy_background:Destroy()
    arg16.LoadingScreen:Destroy()
    arg16.DeviceSelected:Destroy()
end

function t._ClientAlert(_) -- line: 198
    -- upvalues:
    --  [1] Players (copy)

    Players.LocalPlayer:WaitForChild("ClientAlert"):FireServer()
end

function t._ChooseDevice(arg18, arg19) -- line: 202
    arg18._chosen_device = arg19

    for _, val in pairs({ "Desktop", "Mobile", "Console" }) do
        arg18[val .. "Button"].Chosen.Visible = if val ~= arg18._chosen_device then false else true
        local Icon = arg18[val .. "Button"].Icon
        local v18 = val == arg18._chosen_device and Color3.fromRGB(60, 226, 31) or Color3.fromRGB(
            255,
            255,
            255
        )
        Icon.ImageColor3 = v18
    end

    arg18.ConfirmDeviceButton.Visible = true
end

function t._SpiralAnimation(arg20, arg21) -- line: 217
    -- upvalues:
    --  [1] RenderstepForLoop_m (copy)

    assert(
        if typeof(arg21) ~= "number" then false else true,
        "Argument 1 invalid, expected a number, got " .. tostring(arg21)
    )
    arg20.LogoN:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        arg21 * 1.5,
        true
    )
    arg20.LogoG:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        arg21 * 1.5,
        true
    )
    RenderstepForLoop_m(0, 100, 1.667 / arg21, function(arg22) -- line: 226
        -- upvalues:
        --  [1] arg20 (copy)

        local v22 = (math.sqrt(1 - (arg22 / 100 - 1) ^ 2) * 540 + 180) % 360
        arg20.Logo.Rotation = v22
        arg20.LogoN.Rotation = -v22
        arg20.LogoG.Rotation = -v22
    end)
end

function t._ResetLogo(arg23) -- line: 236
    arg23.LogoN.Position = UDim2.new(-1, 0, 0.5, 0)
    arg23.LogoG.Position = UDim2.new(2, 0, 0.5, 0)
    arg23.WhiteN.Size = UDim2.new(1, 0, 0, 0)
    arg23.BlackN.Size = UDim2.new(1, 0, 1, 0)
    arg23.WhiteG.Size = UDim2.new(1, 0, 0, 0)
    arg23.BlackG.Size = UDim2.new(1, 0, 1, 0)
end

function t._Setup(arg24) -- line: 246
    -- upvalues:
    --  [1] EventLibrary_m (copy)

    arg24._blur.Name = "LoadingScreen"
    arg24._blur.Size = 56
    arg24._chicken_footer:Show()
    arg24._chicken_footer:EnableTimer()
    arg24._chicken_footer:EnableFunFacts()
    arg24._chicken_footer:SetStatus("Loading")
    arg24._chicken_footer:SetParent(arg24.MainFrame)
    arg24._glowy_background:SetParent(arg24.MainFrame)
    arg24._glowy_background:SetEnabled(true, true)
    local GameLogo_4 = arg24.GameLogo
    GameLogo_4.Image = EventLibrary_m.IS_ACTIVE and EventLibrary_m.EVENT_DETAILS.LOADING_SCREEN_LOGO or arg24.GameLogo.Image
end

function t._Init(arg25) -- line: 262
    -- upvalues:
    --  [1] RunService (copy)

    arg25.DesktopButton.MouseButton1Click:Connect(function() -- line: 263
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_ChooseDevice("Desktop")
    end)
    arg25.MobileButton.MouseButton1Click:Connect(function() -- line: 267
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_ChooseDevice("Mobile")
    end)
    arg25.ConsoleButton.MouseButton1Click:Connect(function() -- line: 271
        -- upvalues:
        --  [1] arg25 (copy)

        arg25:_ChooseDevice("Console")
    end)
    arg25.ConfirmDeviceButton.MouseButton1Click:Connect(function() -- line: 275
        -- upvalues:
        --  [1] arg25 (copy)

        arg25.DeviceSelected:Fire(arg25._chosen_device)
    end)
    arg25._connection = RunService.RenderStepped:Connect(function() -- line: 279
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    end)
    arg25:_Setup()
    arg25:_ResetLogo()
    task.defer(arg25._ClientAlert, arg25)
end

return t._new()
