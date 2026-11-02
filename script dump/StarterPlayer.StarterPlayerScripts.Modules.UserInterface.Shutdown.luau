local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local _ = game:GetService("Lighting")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local GlowyBackground_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("GlowyBackground")
)
local ChickenFooter_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ChickenFooter")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Shutdown = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Shutdown")
local t = {}
t[Enum.CloseReason.Unknown] = "Unknown shutdown"
t[Enum.CloseReason.RobloxMaintenance] = "Roblox maintenance"
t[Enum.CloseReason.OutOfMemory] = "The server ran out of memory"
t[Enum.CloseReason.ServerEmpty] = "The server is now empty"
t[Enum.CloseReason.DeveloperUpdate] = "Migrating to new servers"
t[Enum.CloseReason.DeveloperShutdown] = "Shutdown by the developers"
local t_1 = {}
t_1.__index = t_1

function t_1._new() -- line: 26
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Signal_m (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.EnabledChanged = Signal_m.new()
    t_2.Enabled = nil
    t_2:_Init()

    return t_2
end

function t_1.Enable(arg1, arg2) -- line: 42
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] Teleporting_m (copy)
    --  [3] Shutdown (copy)
    --  [4] Players (copy)
    --  [5] RunService (copy)
    --  [6] t (copy)
    --  [7] ChickenFooter_m (copy)
    --  [8] GlowyBackground_m (copy)
    --  [9] Utility_m (copy)

    arg1.Enabled = true
    arg1.EnabledChanged:Fire()
    UILibrary_m.MainGui.Enabled = false
    Teleporting_m.GUI.Parent = nil
    local v5 = Shutdown:Clone()
    v5.Parent = Players.LocalPlayer.PlayerGui
    local now = tick()
    RunService.RenderStepped:Connect(function(deltaTime: number) -- line: 54
        -- upvalues:
        --  [1] v5 (copy)
        --  [2] now (copy)

        local Icon = v5.MainFrame.Container.Icon
        Icon.Rotation = Icon.Rotation + (math.sin((tick() - now) * 2 % 6.283185307179586) + 1) * deltaTime * 300
    end)
    local v6 = t[arg2] or arg2 and arg2.Name or ""
    local v7 = ChickenFooter_m.new()
    v7:SetStatus("Server Restart")
    v7:SetMessage(
        (if v6 ~= "" then v6 .. " \226\128\148 " else "") .. "Hang tight while I find a new server for you!"
    )
    v7:SetPicture("Sensei")
    v7:EnableTimer()
    v7:SetParent(v5.MainFrame)
    local v10 = GlowyBackground_m.new("Shutdown")
    v10:SetParent(v5.MainFrame)
    v10:SetEnabled(true)
    Utility_m:RenderstepForLoop(0, 100, 1, function(arg4) -- line: 70
        -- upvalues:
        --  [1] v5 (copy)

        v5.MainFrame.Container.Icon.ImageTransparency = (1 - arg4 / 100) ^ 5
    end)
end

function t_1._Init(_) -- line: 81
end

return t_1._new()
