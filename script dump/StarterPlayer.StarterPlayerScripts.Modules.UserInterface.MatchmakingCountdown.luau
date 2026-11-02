local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController")
)
local Notifications_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "Notifications"
    )
)
local GlowyBackground_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("GlowyBackground")
)
local ChickenFooter_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ChickenFooter")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)
    --  [4] ChickenFooter_m (copy)
    --  [5] GlowyBackground_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.VisibilityChanged = Signal_m.new()
    t_1.Frame = UILibrary_m:GetTo("MatchmakingCountdown")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.CountdownFrame = t_1.Container:WaitForChild("Countdown")
    t_1.CountdownText = t_1.CountdownFrame:WaitForChild("Value")
    t_1.CountdownGlow = t_1.CountdownFrame:WaitForChild("Glow")
    t_1.WaitingFrame = t_1.Container:WaitForChild("Waiting")
    t_1.WaitingDotsFrame = t_1.WaitingFrame:WaitForChild("Dots")
    t_1._countdown_hash = 0
    t_1._aborted_notification = false
    t_1._cover_part = Instance.new("Part")
    t_1._cover_connection = nil
    t_1._chicken_footer = ChickenFooter_m.new()
    t_1._glowy_background = GlowyBackground_m.new("MatchmakingCountdown")
    t_1:_Init()

    return t_1
end

function t.IsVisible(arg1) -- line: 47
    return arg1.Frame.Visible
end

function t._Countdown(arg2) -- line: 55
    -- upvalues:
    --  [1] MatchmakingController_m (copy)
    --  [2] Utility_m (copy)
    --  [3] TweenService (copy)
    --  [4] RunService (copy)

    arg2._countdown_hash += 1
    local CountdownHash = arg2._countdown_hash
    local v6 = MatchmakingController_m:Get("MatchmadeCountdown") or 0
    arg2.CountdownFrame.Visible = v6 > 0 and true
    arg2.CountdownText.Text = v6

    if v6 <= 0 then
        return
    end

    Utility_m:CreateSound(
        "rbxassetid://17259538274",
        0.5,
        1,
        script,
        true,
        5
    )
    local now = tick()

    while true do
        if not (tick() < now + 0.375) then
            break
        end

        if CountdownHash ~= arg2._countdown_hash then
            return
        end

        local v8 = (tick() - now) / 0.375
        local v9 = TweenService:GetValue(v8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local v10 = TweenService:GetValue(v8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        arg2.CountdownText.Size = UDim2.new(1, 0, 1.25 - 0.625 * v9)
        arg2.CountdownGlow.ImageTransparency = 0.875 - 0.25 * v10
        arg2.CountdownGlow.Size = UDim2.new(v10, 0, v10, 0)
        RunService.RenderStepped:Wait()
    end

    local now_2 = tick()

    while true do
        if not (tick() < now_2 + 0.625) then
            break
        end

        if CountdownHash ~= arg2._countdown_hash then
            return
        end

        local v11 = (tick() - now_2) / 0.625
        local v12 = TweenService:GetValue(v11, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local v13 = TweenService:GetValue(v11, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        arg2.CountdownText.Size = UDim2.new(1, 0, 0.625 - 0.625 * v12)
        arg2.CountdownGlow.ImageTransparency = 0.625 + 0.25 * v13
        RunService.RenderStepped:Wait()
    end

    if CountdownHash ~= arg2._countdown_hash then
        return
    end

    arg2.CountdownFrame.Visible = false
end

function t._Update(arg3) -- line: 112
    -- upvalues:
    --  [1] MatchmakingController_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] RunService (copy)
    --  [4] Notifications_m (copy)

    local v14 = MatchmakingController_m:Get("MatchmadeStatus")
    local v15 = MatchmakingController_m:Get("MatchmadeExpectedPlayers")
    local v16 = CONSTANTS_m.IS_MATCHMAKING_SERVER

    if v16 then
        v16 = not MatchmakingController_m:Get("MatchmadeGameOver")

        if v16 then
            v16 = v14 == "Waiting" or v14 == "Starting"
        end
    end

    local v17 = v16 and v14 == "Waiting"
    arg3.Frame.Visible = v16
    arg3.WaitingFrame.Visible = v17
    arg3._glowy_background:SetEnabled(v16, v16)

    if v17 then
        arg3.WaitingDotsFrame:AddTag("UILoadingDots")
        arg3._chicken_footer:Show()
        arg3._chicken_footer:SetStatus("Waiting For Players")
        arg3._chicken_footer:EnableFunFacts()
        arg3._chicken_footer:SetTimer(
            (MatchmakingController_m:Get("MatchmadeConnectedPlayers") or 0) .. " / " .. (v15 or "???")
        )
    else
        arg3.WaitingDotsFrame:RemoveTag("UILoadingDots")
        arg3._chicken_footer:Hide()
    end

    if v16 and not arg3._cover_connection then
        arg3._cover_part.Parent = workspace
        arg3._cover_connection = RunService.RenderStepped:Connect(function() -- line: 136
            -- upvalues:
            --  [1] arg3 (copy)

            arg3._cover_part.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -1)
        end)
    elseif not v16 and arg3._cover_connection then
        arg3._cover_part.Parent = nil
        arg3._cover_connection:Disconnect()
        arg3._cover_connection = nil
    end

    if v14 == "Aborted" and not arg3._aborted_notification then
        arg3._aborted_notification = true
        Notifications_m:Queue(
            "Duel Cancelled",
            "Not enough players connected",
            "rbxassetid://18553001997",
            nil,
            0.75
        )
    end
end

function t._Setup(arg4) -- line: 151
    arg4._cover_part.Size = Vector3.new(10, 10, 0)
    arg4._cover_part.Anchored = true
    arg4._cover_part.CanCollide = false
    arg4._cover_part.CanTouch = false
    arg4._cover_part.CanQuery = false
    arg4._cover_part.Color = Color3.fromRGB(0, 0, 0)
    arg4._cover_part.Material = Enum.Material.Neon
    local SurfaceGui = Instance.new("SurfaceGui")
    SurfaceGui.AlwaysOnTop = true
    SurfaceGui.Face = Enum.NormalId.Back
    SurfaceGui.Parent = arg4._cover_part
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.Parent = SurfaceGui
    arg4._chicken_footer:SetParent(arg4.Container)
    arg4._glowy_background:SetParent(arg4.Container)
end

function t._Init(arg5) -- line: 174
    -- upvalues:
    --  [1] MatchmakingController_m (copy)

    arg5.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 175
        -- upvalues:
        --  [1] arg5 (copy)

        arg5.VisibilityChanged:Fire()
    end)
    MatchmakingController_m:GetDataChangedSignal("MatchmadeGameOver"):Connect(function() -- line: 179
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    MatchmakingController_m:GetDataChangedSignal("MatchmadeStatus"):Connect(function() -- line: 183
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    MatchmakingController_m:GetDataChangedSignal("MatchmadeCountdown"):Connect(function() -- line: 187
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
        arg5:_Countdown()
    end)
    MatchmakingController_m:GetDataChangedSignal("MatchmadeConnectedPlayers"):Connect(function() -- line: 192
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
        arg5:_Countdown()
    end)
    MatchmakingController_m:GetDataChangedSignal("MatchmadeExpectedPlayers"):Connect(function() -- line: 197
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
        arg5:_Countdown()
    end)
    arg5:_Setup()
    task.defer(arg5._Update, arg5)
    task.defer(arg5._Countdown, arg5)
end

return t._new()
