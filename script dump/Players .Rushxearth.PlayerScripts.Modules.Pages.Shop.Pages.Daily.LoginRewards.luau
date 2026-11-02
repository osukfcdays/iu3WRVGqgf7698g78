local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LoginRewardLibrary_m = require(ReplicatedStorage.Modules.LoginRewardLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local LoginRewardSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "LoginRewardSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 14
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Daily = arg1
    t_1.Frame = t_1.Daily.Container:WaitForChild("LoginRewards")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.SlotsFrame = t_1.Container:WaitForChild("Slots")
    t_1._cleanup = {}
    t_1:_Init()

    return t_1
end

function t.Generate(arg2) -- line: 33
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] LoginRewardLibrary_m (copy)
    --  [3] LoginRewardSlot (copy)
    --  [4] RewardSlot_m (copy)
    --  [5] ReplicatedStorage (copy)
    --  [6] ButtonEffect_m (copy)

    for _, val in pairs(arg2._cleanup) do
        val:Destroy()
    end

    arg2._cleanup = {}
    local v1 = PlayerDataController_m:Get("ClaimedLoginRewardToday")
    local v2 = PlayerDataController_m:Get("LoginRewardsClaimed")
    local ceiling = math.ceil((v2 + (if v1 then 0 else 1)) / 7 - 1)
    local v5 = math.max(0, ceiling) * 7 + 1

    for index = v5, v5 + 7 - 1 do
        local v6 = LoginRewardLibrary_m:GetLoginRewardInfoFromDay(index)
        local v7 = v2 >= index and true
        local v8 = if index ~= v2 + 1 then false else true
        local v9 = if not v8 then Color3.fromRGB(0, 0, 0) else if v1 then Color3.fromRGB(0, 0, 0) else Color3.fromRGB(
            255,
            255,
            255
        )
        local v10 = LoginRewardSlot:Clone()
        v10.Button.Title.Text = v6.Title
        v10.Button.Description.Text = if v7 then "" else if v6.Description == "" then if not v8 then "" else if v1 then "" else "Claim now!" else v6.Description or (if not v8 then "" else if v1 then "" else "Claim now!")
        v10.Button.Background.BackgroundColor3 = v9
        v10.Button.Background.UIStroke.Color = v9
        v10.Button.Claimed.Visible = v7
        v10.Parent = arg2.SlotsFrame:WaitForChild(index - v5 + 1)
        table.insert(arg2._cleanup, v10)

        for _, val_1 in pairs(v6.Rewards) do
            v9 = RewardSlot_m.new(val_1)
            v9:SetInteractable(false)
            v9:SetParent(v10.Button.Reward)
            table.insert(arg2._cleanup, v9)
        end

        if v8 and not v1 then
            v10.Button.MouseButton1Click:Connect(function() -- line: 67
                -- upvalues:
                --  [1] ReplicatedStorage (ref)

                ReplicatedStorage.Remotes.Data.ClaimLoginReward:FireServer()
            end)
            ButtonEffect_m:Add(v10.Button, nil, { HoverRatio = 1.05, ReleaseRatio = 1.05 })
        end
    end
end

function t.Open(arg3) -- line: 76
    arg3:Generate()
end

function t.Close(arg4) -- line: 80
    arg4:Generate()
end

function t.Setup(arg5) -- line: 84
    arg5:Generate()
end

function t._Init(arg6) -- line: 92
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    PlayerDataController_m:GetDataChangedSignal("ClaimedLoginRewardToday"):Connect(function() -- line: 93
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:Generate()
    end)
    PlayerDataController_m:GetDataChangedSignal("LoginRewardsClaimed"):Connect(function() -- line: 97
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:Generate()
    end)
end

return t
