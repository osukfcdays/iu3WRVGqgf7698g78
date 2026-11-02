local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 11
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.ClaimButton = t_1.PageFrame:WaitForChild("Claim")
    t_1.RewardsFrame = t_1.PageFrame:WaitForChild("Rewards")
    t_1.TitleText = t_1.PageFrame:WaitForChild("Title")
    t_1.HidePartyDisplay = true
    t_1:_Init()

    return t_1
end

function t.CloseRequest(arg1, ...) -- line: 29
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] Page_m (copy)

    ReplicatedStorage.Remotes.Data.ClaimWelcomeBackGift:FireServer()
    Page_m.CloseRequest(arg1, ...)
end

function t._Setup(arg2) -- line: 38
    -- upvalues:
    --  [1] Players (copy)
    --  [2] RewardSlot_m (copy)

    arg2.TitleText.Text = "Welcome back, " .. Players.LocalPlayer.DisplayName .. "!"
    RewardSlot_m.new({ Name = "Standard Weapon Crate", Quantity = 1 }):SetParent(arg2.RewardsFrame)
end

function t._Init(arg3) -- line: 43
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg3.ClaimButton.MouseButton1Click:Connect(function() -- line: 44
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:CloseRequest()
    end)
    arg3:_Setup()
    ButtonEffect_m:Add(arg3.ClaimButton)
end

return t._new()
