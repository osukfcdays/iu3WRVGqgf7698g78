local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
local PingEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc.PingEffect
local PingSlot = Players.LocalPlayer.PlayerScripts.UserInterface.PingSlot
t.__index = t

function t._new() -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "PingEffect")
    t_1._ping_objects = {}
    t_1._ping_slots = {}
    t_1._is_looping = false
    t_1:_Init()

    return t_1
end

function t.Play(arg1, arg2, arg3) -- line: 37
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] DuelLibrary_m (copy)
    --  [4] PingEffect (copy)
    --  [5] BetterDebris_m (copy)
    --  [6] Utility_m (copy)
    --  [7] PingSlot (copy)

    if
        (arg2 - workspace.CurrentCamera.CFrame.Position).Magnitude > CONSTANTS_m.RENDER_DISTANCE
        or not PlayerDataController_m:GetSetting("Pings")
    then
        return
    end

    if arg1._ping_objects[arg3] then
        arg1._ping_objects[arg3]:Destroy()
    end

    local v4 = DuelLibrary_m:GetTeamColor(
        arg3:GetAttribute("TeamID"),
        Color3.fromRGB(255, 255, 255)
    )
    local v5 = PingEffect:Clone()
    v5.CFrame = CFrame.new(arg2)
    v5.OnTop.Picture.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, arg3.UserId)
    v5.OnTop.Shadow.ImageColor3 = v4
    v5.OnTop.Ping.ImageColor3 = v4
    v5.Bright.Shadow.ImageColor3 = v4
    v5.Bright.Ping.ImageColor3 = v4
    v5.Parent = workspace
    BetterDebris_m:AddItem(v5, 8)
    arg1._ping_objects[arg3] = v5
    v5.OnTop.Picture:TweenPosition(
        UDim2.new(0.5, 0, 0.25, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
    v5.OnTop.Ping:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
    v5.Bright.Ping:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
    Utility_m:CreateSound(
        "rbxassetid://17270018886",
        1,
        1.5,
        v5,
        true,
        5
    )
    v5.Destroying:Connect(function() -- line: 65
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] arg3 (copy)
        --  [3] v5 (copy)

        if arg1._ping_objects[arg3] == v5 then
            arg1._ping_objects[arg3] = nil
        end

        if arg1._ping_slots[v5] then
            arg1._ping_slots[v5]:Destroy()
            arg1._ping_slots[v5] = nil
        end
    end)
    local v6 = PingSlot:Clone()
    v6.Picture.Image = v5.OnTop.Picture.Image
    v6.Ping.ImageColor3 = v4
    v6.Parent = arg1.Frame
    arg1._ping_slots[v5] = v6
    task.spawn(arg1._StartLoop, arg1)
end

function t._StartLoop(arg4) -- line: 89
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] RunService (copy)

    if arg4._is_looping then
        return
    end

    arg4._is_looping = true
    local v7 = true
    local v13

    for key, val in pairs(arg4._ping_slots) do
        v7 = false
        local v8 = Vector2.one * 40 + val.AbsoluteSize / 2
        local v9 = arg4.Frame.AbsoluteSize - Vector2.one * 40 - val.AbsoluteSize / 2
        local screenPoint, isOnScreen = workspace.CurrentCamera:WorldToScreenPoint(key.Position)
        local v11 = UILibrary_m:ScreenPointToPosition(
            Vector2.new(screenPoint.X, screenPoint.Y),
            arg4.Frame.AbsolutePosition
        )
        local vec2_1 = Vector2.new(math.clamp(v11.X, v8.X, v9.X), (math.clamp(v11.Y, v8.Y, v9.Y)))

        if not isOnScreen then
            if screenPoint.Z < 0 then
                v13 = if not isOnScreen then val.Visible else false
                val.Visible = v13
            else
                local v14 = 360 - math.deg((math.atan2(v11.X - vec2_1.X, v11.Y - vec2_1.Y)))
                val.Rotation = v14
                val.Picture.Rotation = -v14
                val.Position = UDim2.new(0, vec2_1.X, 0, vec2_1.Y)
                val.Visible = true
            end
        else
            v13 = if not isOnScreen then val.Visible else false
            val.Visible = v13
        end
    end

    if not v7 then
        RunService.RenderStepped:Wait()
    end

    arg4._is_looping = false
end

function t._Init(_) -- line: 135
end

return t._new()
