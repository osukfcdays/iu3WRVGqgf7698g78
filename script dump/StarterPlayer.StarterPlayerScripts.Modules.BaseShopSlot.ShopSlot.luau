local Players = game:GetService("Players")
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Parent_m = require(script.Parent)
local ShopSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ShopSlot")
local t = setmetatable({}, Parent_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Parent_m (copy)
    --  [2] t (copy)
    --  [3] ShopSlot (copy)

    local t_1 = setmetatable(Parent_m.new(...), t)
    t_1.Frame = ShopSlot:Clone()
    t_1.DetailsFrame = t_1.Frame.Details
    t_1.RewardSlot = nil
    t_1:_Init()

    return t_1
end

function t.OnClick(arg1, ...) -- line: 27
    arg1.RewardSlot:OnClick(...)
end

function t.Destroy(arg2) -- line: 31
    -- upvalues:
    --  [1] Parent_m (copy)

    arg2.Frame:Destroy()

    if arg2.RewardSlot then
        arg2.RewardSlot:Destroy()
    end

    Parent_m.Destroy(arg2)
end

function t._Setup(arg3) -- line: 45
    -- upvalues:
    --  [1] RewardSlot_m (copy)

    local v3 = arg3.IsLocked
    local New = RewardSlot_m.new
    local FirstRewardData = arg3.FirstRewardData

    if not v3 then
        v3 = arg3.IsOwned
    end

    arg3.RewardSlot = New(FirstRewardData, v3)
    arg3.RewardSlot:SetNameText("")
    arg3.RewardSlot:SetParent(arg3.Frame.Container)
    local DetailsFrame = arg3.DetailsFrame
    DetailsFrame.Parent = arg3.RewardSlot.CosmeticSlot and arg3.RewardSlot.CosmeticSlot.Frame.Button or arg3.RewardSlot.Frame.Reward
end

function t._Init(arg4) -- line: 52
    arg4:_Setup()
    arg4:_SetupBuyButton(arg4.DetailsFrame.Buy, arg4.DetailsFrame.Owned)
end

return t
