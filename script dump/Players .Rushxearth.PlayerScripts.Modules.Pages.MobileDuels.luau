local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 10
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.ButtonsFrame = t_1.PageFrame:WaitForChild("Buttons")
    t_1.CloseButton = t_1.ButtonsFrame:WaitForChild("Close")
    t_1.TeleportButton = t_1.ButtonsFrame:WaitForChild("Teleport")
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 32
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] ButtonEffect_m (copy)

    arg1.CloseButton.MouseButton1Click:Connect(function() -- line: 33
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:CloseRequest()
    end)
    arg1.TeleportButton.MouseButton1Click:Connect(function() -- line: 37
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg1 (copy)

        ReplicatedStorage.Remotes.Misc.MobileDuelsTeleport:FireServer()
        arg1:CloseRequest()
    end)
    ButtonEffect_m:Add(arg1.CloseButton)
    ButtonEffect_m:Add(arg1.TeleportButton)
end

return t._new()
