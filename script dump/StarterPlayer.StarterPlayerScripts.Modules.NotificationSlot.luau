local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local BountyLibrary_m = require(ReplicatedStorage.Modules.BountyLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local NotificationSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "NotificationSlot"
)
local t = {}
t.__index = t

function t.new(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5
) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] NotificationSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = NotificationSlot:Clone()
    t_1._creation_time = arg5 or tick()
    t_1._title = arg1 or ""
    t_1._description = arg2 or ""
    t_1._first_icon = arg3
    t_1._second_icon = arg4
    t_1._first_reward_info = if typeof(t_1._first_icon) == "table" then t_1._first_icon else false
    t_1._second_reward_info = if typeof(t_1._second_icon) == "table" then t_1._second_icon else false
    t_1._cleanup = {}
    t_1:_Init()

    return t_1
end

function t.SetParent(arg6, arg7) -- line: 38
    arg6.Frame.Parent = arg7
end

function t.PlaySound(arg8, arg9) -- line: 42
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] BountyLibrary_m (copy)
    --  [3] CosmeticLibrary_m (copy)

    if arg9 then
        Utility_m:CreateSound(
            arg9,
            1.5,
            1,
            script,
            true,
            5
        )

        return
    end

    if arg8._second_reward_info and BountyLibrary_m.Rewards[arg8._second_reward_info.Name] then
        Utility_m:CreateSound(
            "rbxassetid://17770244373",
            1.5,
            1,
            script,
            true,
            5
        )

        return
    end

    if
        arg8._second_reward_info
        and CosmeticLibrary_m.Rewards[arg8._second_reward_info.Name]
        and CosmeticLibrary_m.Rewards[arg8._second_reward_info.Name].Type == "Weapon"
    then
        Utility_m:CreateSound(
            "rbxassetid://17769583566",
            1.5,
            1,
            script,
            true,
            5
        )

        return
    end

    if arg8._second_reward_info and CosmeticLibrary_m.Rewards[arg8._second_reward_info.Name] then
        Utility_m:CreateSound(
            "rbxassetid://17769583339",
            1.5,
            1,
            script,
            true,
            5
        )

        return
    end

    if arg8._second_reward_info and arg8._second_reward_info.Weapon == "IsUniversal" then
        Utility_m:CreateSound(
            "rbxassetid://17769583566",
            1.5,
            1,
            script,
            true,
            5
        )

        return
    end

    if arg8._second_reward_info then
        Utility_m:CreateSound(
            "rbxassetid://17769583804",
            1.5,
            1,
            script,
            true,
            5
        )

        return
    end

    Utility_m:CreateSound(
        "rbxassetid://17769893181",
        1.5,
        1,
        script,
        true,
        5
    )
end

function t.PlayGlow(arg10) -- line: 60
    -- upvalues:
    --  [1] Utility_m (copy)

    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        0,
        100,
        1,
        function(arg11) -- line: 61
            -- upvalues:
            --  [1] arg10 (copy)

            arg10.Frame.Visuals.Glow.ImageTransparency = arg11 / 100
        end
    )
end

function t.PlaySize(arg12, arg13, arg14) -- line: 68
    -- upvalues:
    --  [1] Players (copy)
    --  [2] Utility_m (copy)

    local v3 = arg13 or 1
    arg12.Frame.Size = UDim2.new(1.1 * v3, 0, 1.1 * v3, 0)
    arg12.Frame:TweenSize(
        UDim2.new(1 * v3, 0, 1 * v3, 0),
        "Out",
        "Back",
        0.25,
        true
    )

    if arg14 then
        task.delay(arg14, function() -- line: 75
            -- upvalues:
            --  [1] Players (ref)
            --  [2] arg12 (copy)
            --  [3] v3 (copy)
            --  [4] Utility_m (ref)

            local Inset_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Inset)
            arg12.Frame.Visuals.ClipsDescendants = true
            arg12.Frame:TweenSize(
                UDim2.new(0.13333333333333333 * v3, 0, 1 * v3, 0),
                "In",
                "Quint",
                0.5,
                true,
                function() -- line: 79
                    -- upvalues:
                    --  [1] Inset_m (copy)
                    --  [2] Utility_m (ref)
                    --  [3] arg12 (ref)
                    --  [4] v3 (ref)

                    local v4 = Inset_m.MainBar:GetNotificationGoal()
                    Utility_m:RenderstepForLoop(0, 100, 7.5, function(arg15) -- line: 82
                        -- upvalues:
                        --  [1] v4 (copy)
                        --  [2] arg12 (ref)
                        --  [3] v3 (ref)

                        local v5 = arg15 / 100
                        local v6 = v4.Frame.AbsolutePosition + v4.Frame.AbsoluteSize / 2 - (arg12.Frame.AbsolutePosition + arg12.Frame.AbsoluteSize / 2)
                        arg12.Frame.Size = UDim2.new(
                            0.13333333333333333 * (1 - v5) * v3,
                            0,
                            1 * (1 - v5) * v3,
                            0
                        )
                        arg12.Frame.Visuals.Position = UDim2.new(0.5, v6.X * v5, 0.5, v6.Y * v5)
                    end)
                    v4:PlayJiggleEffect()
                    arg12:Destroy()
                end
            )
        end)
    end
end

function t.UpdateAge(arg16) -- line: 98
    -- upvalues:
    --  [1] Utility_m (copy)

    local now = tick()
    local floorValue = math.floor(now - arg16._creation_time)
    arg16.Frame.Visuals.Container.Age.Visible = true
    arg16.Frame.Visuals.Container.Age.Title.Text = if floorValue < 1 then "just now" else Utility_m:TimeFormat2(
        floorValue,
        true
    ) .. " ago"
end

function t.Destroy(arg17) -- line: 105
    for _, val in pairs(arg17._cleanup) do
        val:Destroy()
    end

    arg17._cleanup = {}
    arg17.Frame:Destroy()
end

function t._Setup(arg18) -- line: 119
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] RewardSlot_m (copy)

    arg18.Frame.Visuals.Container.Title.Text = arg18._title or ""
    arg18.Frame.Visuals.Container.Description.Text = arg18._description or ""
    local FirstIcon = arg18.Frame.Visuals.Container.FirstIcon
    FirstIcon.Image = typeof(arg18._first_icon) == "string" and arg18._first_icon or ""
    local SecondIcon = arg18.Frame.Visuals.Container.SecondIcon
    SecondIcon.Image = typeof(arg18._second_icon) == "string" and arg18._second_icon or ""
    arg18.Frame.Visuals.Background.BackgroundColor3 = UILibrary_m.BUTTON_BACKGROUND_COLOR
    arg18.Frame.Visuals.Background.BackgroundTransparency = UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY

    if arg18._first_reward_info then
        if CosmeticLibrary_m.Cosmetics[arg18._first_reward_info.Name] then
            arg18._first_reward_info.Quantity = nil
        end

        local v9 = RewardSlot_m.new(arg18._first_reward_info)
        v9:SetParent(arg18.Frame.Visuals.Container.FirstReward)
        table.insert(arg18._cleanup, v9)
    end

    if arg18._second_reward_info then
        if CosmeticLibrary_m.Cosmetics[arg18._second_reward_info.Name] then
            arg18._second_reward_info.Quantity = nil
        end

        local v10 = RewardSlot_m.new(arg18._second_reward_info)
        v10:SetParent(arg18.Frame.Visuals.Container.SecondReward)
        table.insert(arg18._cleanup, v10)
    end
end

function t._Init(arg19) -- line: 148
    arg19:_Setup()
end

return t
