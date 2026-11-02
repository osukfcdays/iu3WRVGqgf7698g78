local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local GlowyBackground_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("GlowyBackground")
)
local ChickenFooter_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ChickenFooter")
)
local _ = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local TeleportingGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "TeleportingGui"
)
local t = {}
t.__index = t

function t._new() -- line: 17
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] TeleportingGui (copy)
    --  [4] ChickenFooter_m (copy)
    --  [5] GlowyBackground_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.EnabledChanged = Signal_m.new()
    t_1.Enabled = nil
    t_1.GUI = TeleportingGui:Clone()
    t_1.Frame = t_1.GUI:WaitForChild("Teleporting")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Dots = t_1.Container:WaitForChild("Waiting"):WaitForChild("Dots")
    t_1._enabled_hash = 0
    t_1._blur = Instance.new("BlurEffect")
    t_1._chicken_footer = ChickenFooter_m.new()
    t_1._glowy_background = GlowyBackground_m.new("Teleporting")
    t_1:_Init()

    return t_1
end

function t.Enable(arg1, arg2) -- line: 43
    if arg2 == arg1.Enabled then
        return
    end

    arg1.Enabled = arg2
    arg1.EnabledChanged:Fire()
    arg1._enabled_hash += 1
    task.spawn(arg1._Update, arg1)
end

function t._Update(arg3) -- line: 58
    -- upvalues:
    --  [1] Utility_m (copy)

    local EnabledHash = arg3._enabled_hash
    arg3.Container.Visible = arg3.Enabled
    arg3._glowy_background:SetEnabled(arg3.Enabled)

    if arg3.Enabled then
        arg3.Dots:AddTag("UILoadingDots")
        arg3._chicken_footer:Show()
        arg3._chicken_footer:EnableTimer()
        arg3._chicken_footer:EnableFunFacts()
        arg3._chicken_footer:SetStatus("Teleporting")
    else
        arg3.Dots:RemoveTag("UILoadingDots")
        arg3._chicken_footer:Hide()
    end

    if arg3.Enabled then
    end

    if arg3.Enabled then
    end

    local v4 = if not arg3.Enabled then 56 else 0
    local v5 = if not arg3.Enabled then 0 else 56
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg4) -- line: 80
        -- upvalues:
        --  [1] EnabledHash (copy)
        --  [2] arg3 (copy)
        --  [3] v4 (copy)
        --  [4] v5 (copy)

        if EnabledHash ~= arg3._enabled_hash then
            return true
        end

        arg3._blur.Size = v4 + (v5 - v4) * (1 - (1 - arg4 / 100) ^ 3)
    end)
end

function t._Setup(arg5) -- line: 91
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] Players (copy)

    arg5._blur.Size = 0
    arg5._blur.Name = "Teleporting"
    arg5._blur.Parent = Lighting
    arg5._chicken_footer:SetParent(arg5.Frame)
    arg5._glowy_background:SetParent(arg5.Frame)
    arg5.GUI.Parent = Players.LocalPlayer.PlayerGui
end

function t._Init(arg6) -- line: 102
    -- upvalues:
    --  [1] TeleportService (copy)
    --  [2] ReplicatedStorage (copy)

    arg6.EnabledChanged:Connect(function() -- line: 103
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] TeleportService (ref)

        if arg6.Enabled then
            TeleportService:SetTeleportGui(arg6.GUI)
        end
    end)
    ReplicatedStorage.Remotes.Misc.Teleporting.OnClientEvent:Connect(function(arguments) -- line: 109
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:Enable(arguments)
    end)
    arg6:_Setup()
    arg6:Enable(false)
end

return t._new()
