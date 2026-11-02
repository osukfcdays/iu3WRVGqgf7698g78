local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.Utility)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Pages = arg1
    t_1.Frame = t_1.Pages.Frame:WaitForChild("Bundles")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.PermanentFrame = t_1.Container:WaitForChild("Permanent")
    t_1.TimedFrame = t_1.Container:WaitForChild("Timed")
    t_1._is_open_hash = 0
    t_1._superstarterbundle_slot = nil
    t_1:_Init()

    return t_1
end

function t.Open(arg2) -- line: 31
    if arg2._superstarterbundle_slot then
        arg2._superstarterbundle_slot:StartLoops()
    end
end

function t.Close(arg3) -- line: 37
    if arg3._superstarterbundle_slot then
        arg3._superstarterbundle_slot:StopLoops()
    end
end

function t.Setup(arg4) -- line: 43
    for _, val in pairs(arg4.Pages.Shop.BUNDLE_NAMES) do
        arg4.Pages.Shop:CreateBundleSlot(val):SetParent(arg4.PermanentFrame:WaitForChild(val))
    end

    arg4:_SetupSuperStarterBundleSlot()
end

function t._SetupSuperStarterBundleSlot(arg5) -- line: 55
    arg5._superstarterbundle_slot = arg5.Pages.Shop:CreateBundleSlot("superstarter_bundle")
    arg5._superstarterbundle_slot:SetParent(arg5.TimedFrame:WaitForChild("superstarter_bundle"))

    local function update() -- line: 59
        -- upvalues:
        --  [1] arg5 (copy)

        arg5.TimedFrame.Visible = arg5._superstarterbundle_slot:IsAvailableToPurchase()
    end

    arg5._superstarterbundle_slot.AvailabilityChanged:Connect(update)
    arg5.TimedFrame.Visible = arg5._superstarterbundle_slot:IsAvailableToPurchase()

    if arg5.Pages.Shop:IsOpen() then
        arg5._superstarterbundle_slot:StartLoops()
    end
end

function t._Init(_) -- line: 71
end

return t
