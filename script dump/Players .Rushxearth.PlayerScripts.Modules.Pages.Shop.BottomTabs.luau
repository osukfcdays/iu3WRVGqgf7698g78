local Players = game:GetService("Players")
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ShopController)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local t = {}
t.__index = t

function t.new(arg1) -- line: 9
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Shop = arg1
    t_1.Frame = t_1.Shop.List:WaitForChild("BottomTabs")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.GiftingButton = t_1.Container:WaitForChild("Gifting")
    t_1.RewardsButton = t_1.Container:WaitForChild("Rewards")
    t_1:_Init()

    return t_1
end

function t.Open(_) -- line: 27
end

function t.Close(_) -- line: 31
end

function t.Setup(_) -- line: 35
end

function t._Init(arg5) -- line: 43
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg5.GiftingButton.MouseButton1Click:Connect(function() -- line: 44
        -- upvalues:
        --  [1] arg5 (copy)

        arg5.Shop:SetPage("Gifting")
    end)
    arg5.RewardsButton.MouseButton1Click:Connect(function() -- line: 48
        -- upvalues:
        --  [1] arg5 (copy)

        arg5.Shop:SetPage("Rewards")
    end)
    ButtonEffect_m:Add(arg5.GiftingButton)
    ButtonEffect_m:Add(arg5.RewardsButton)
end

return t
