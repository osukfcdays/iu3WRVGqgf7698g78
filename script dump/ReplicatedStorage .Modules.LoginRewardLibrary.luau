local t = {
    NUM_ONBOARDING_LOGIN_REWARD_MILESTONES = 0,
    NUM_LOOPED_LOGIN_REWARD_MILESTONES = 0,
    OnboardingRewards = {},
    LoopedRewards = {},
    GetLoginRewardInfoFromDay = function(arg1, arg2) --[[ GetLoginRewardInfoFromDay ]] -- line: 9
        if arg2 <= arg1.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES then
            return arg1.OnboardingRewards[arg2]
        end

        return arg1.LoopedRewards[(arg2 - arg1.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES - 1) % arg1.NUM_LOOPED_LOGIN_REWARD_MILESTONES + 1]
    end
}

local _ = function(arg3, arg4, arg5) --[[ add_login_reward ]] -- line: 19
    -- upvalues:
    --  [1] t (copy)

    local v1 = if not arg3 then t.LoopedRewards else t.OnboardingRewards
    local v2 = #v1 + 1
    local t_1 = { LoginRewardID = nil, Rewards = nil, Title = nil, Description = nil }
    local v3 = if not arg3 then "LoginRewardLooped" else "LoginRewardOnboarding"
    t_1.LoginRewardID = v3 .. v2
    t_1.Rewards = arg5
    t_1.Title = "Day " .. (v2 - 1) % 7 + 1
    t_1.Description = arg4 or ""
    table.insert(v1, t_1)

    if arg3 then
        local v4 = t
        v4.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES += 1

        return
    end

    local v5 = t
    v5.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
end

local OnboardingRewards = t.OnboardingRewards
local v6 = #OnboardingRewards + 1
table.insert(
    OnboardingRewards,
    {
        LoginRewardID = "LoginRewardOnboarding" .. v6,
        Rewards = { { Name = "Key", Quantity = 1 } },
        Title = "Day " .. (v6 - 1) % 7 + 1,
        Description = "Welcome!"
    }
)
t.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES += 1
local OnboardingRewards_1 = t.OnboardingRewards
local v7 = #OnboardingRewards_1 + 1
table.insert(
    OnboardingRewards_1,
    {
        LoginRewardID = "LoginRewardOnboarding" .. v7,
        Rewards = { { Name = "Wrap Box", Quantity = 1, Weapon = "IsRandom" } },
        Title = "Day " .. (v7 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES += 1
local OnboardingRewards_2 = t.OnboardingRewards
local v8 = #OnboardingRewards_2 + 1
table.insert(
    OnboardingRewards_2,
    {
        LoginRewardID = "LoginRewardOnboarding" .. v8,
        Rewards = { { Name = "Standard Weapon Crate", Quantity = 1 } },
        Title = "Day " .. (v8 - 1) % 7 + 1,
        Description = "Free weapon!"
    }
)
t.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES += 1
local OnboardingRewards_3 = t.OnboardingRewards
local v9 = #OnboardingRewards_3 + 1
table.insert(
    OnboardingRewards_3,
    {
        LoginRewardID = "LoginRewardOnboarding" .. v9,
        Rewards = { { Name = "Prize Wheel", Quantity = 1, Weapon = "IsRandom" } },
        Title = "Day " .. (v9 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES += 1
local OnboardingRewards_4 = t.OnboardingRewards
local v10 = #OnboardingRewards_4 + 1
table.insert(
    OnboardingRewards_4,
    {
        LoginRewardID = "LoginRewardOnboarding" .. v10,
        Rewards = { { Name = "Finisher Pack", Quantity = 1, Weapon = "IsRandom" } },
        Title = "Day " .. (v10 - 1) % 7 + 1,
        Description = "Super cool!"
    }
)
t.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES += 1
local OnboardingRewards_5 = t.OnboardingRewards
local v11 = #OnboardingRewards_5 + 1
table.insert(
    OnboardingRewards_5,
    {
        LoginRewardID = "LoginRewardOnboarding" .. v11,
        Rewards = { { Name = "Key", Quantity = 10 } },
        Title = "Day " .. (v11 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES += 1
local OnboardingRewards_6 = t.OnboardingRewards
local v12 = #OnboardingRewards_6 + 1
table.insert(
    OnboardingRewards_6,
    {
        LoginRewardID = "LoginRewardOnboarding" .. v12,
        Rewards = { { Name = "Skin Ticket", Quantity = 1 } },
        Title = "Day " .. (v12 - 1) % 7 + 1,
        Description = "Free skins!"
    }
)
t.NUM_ONBOARDING_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards = t.LoopedRewards
local v13 = #LoopedRewards + 1
table.insert(
    LoopedRewards,
    {
        LoginRewardID = "LoginRewardLooped" .. v13,
        Rewards = { { Name = "Key", Quantity = 1 } },
        Title = "Day " .. (v13 - 1) % 7 + 1,
        Description = "Claim now!"
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_1 = t.LoopedRewards
local v14 = #LoopedRewards_1 + 1
table.insert(
    LoopedRewards_1,
    {
        LoginRewardID = "LoginRewardLooped" .. v14,
        Rewards = { { Name = "Goodie Bag", Quantity = 1, Weapon = "IsRandom" } },
        Title = "Day " .. (v14 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_2 = t.LoopedRewards
local v15 = #LoopedRewards_2 + 1
table.insert(
    LoopedRewards_2,
    {
        LoginRewardID = "LoginRewardLooped" .. v15,
        Rewards = { { Name = "Key", Quantity = 3 } },
        Title = "Day " .. (v15 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_3 = t.LoopedRewards
local v16 = #LoopedRewards_3 + 1
table.insert(
    LoopedRewards_3,
    {
        LoginRewardID = "LoginRewardLooped" .. v16,
        Rewards = { { Name = "Goodie Bag", Quantity = 2, Weapon = "IsRandom" } },
        Title = "Day " .. (v16 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_4 = t.LoopedRewards
local v17 = #LoopedRewards_4 + 1
table.insert(
    LoopedRewards_4,
    {
        LoginRewardID = "LoginRewardLooped" .. v17,
        Rewards = { { Name = "Goodie Bag", Quantity = 3, Weapon = "IsRandom" } },
        Title = "Day " .. (v17 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_5 = t.LoopedRewards
local v18 = #LoopedRewards_5 + 1
table.insert(
    LoopedRewards_5,
    {
        LoginRewardID = "LoginRewardLooped" .. v18,
        Rewards = { { Name = "Key", Quantity = 5 } },
        Title = "Day " .. (v18 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_6 = t.LoopedRewards
local v19 = #LoopedRewards_6 + 1
table.insert(
    LoopedRewards_6,
    {
        LoginRewardID = "LoginRewardLooped" .. v19,
        Rewards = { { Name = "Skin Ticket", Quantity = 1 } },
        Title = "Day " .. (v19 - 1) % 7 + 1,
        Description = "Grand prize!"
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_7 = t.LoopedRewards
local v20 = #LoopedRewards_7 + 1
table.insert(
    LoopedRewards_7,
    {
        LoginRewardID = "LoginRewardLooped" .. v20,
        Rewards = { { Name = "Goodie Bag", Quantity = 1, Weapon = "IsRandom" } },
        Title = "Day " .. (v20 - 1) % 7 + 1,
        Description = "Claim now!"
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_8 = t.LoopedRewards
local v21 = #LoopedRewards_8 + 1
table.insert(
    LoopedRewards_8,
    {
        LoginRewardID = "LoginRewardLooped" .. v21,
        Rewards = { { Name = "Key", Quantity = 3 } },
        Title = "Day " .. (v21 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_9 = t.LoopedRewards
local v22 = #LoopedRewards_9 + 1
table.insert(
    LoopedRewards_9,
    {
        LoginRewardID = "LoginRewardLooped" .. v22,
        Rewards = { { Name = "Goodie Bag", Quantity = 2, Weapon = "IsRandom" } },
        Title = "Day " .. (v22 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_10 = t.LoopedRewards
local v23 = #LoopedRewards_10 + 1
table.insert(
    LoopedRewards_10,
    {
        LoginRewardID = "LoginRewardLooped" .. v23,
        Rewards = { { Name = "Key", Quantity = 5 } },
        Title = "Day " .. (v23 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_11 = t.LoopedRewards
local v24 = #LoopedRewards_11 + 1
table.insert(
    LoopedRewards_11,
    {
        LoginRewardID = "LoginRewardLooped" .. v24,
        Rewards = { { Name = "Goodie Bag", Quantity = 3, Weapon = "IsRandom" } },
        Title = "Day " .. (v24 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_12 = t.LoopedRewards
local v25 = #LoopedRewards_12 + 1
table.insert(
    LoopedRewards_12,
    {
        LoginRewardID = "LoginRewardLooped" .. v25,
        Rewards = { { Name = "Key", Quantity = 7 } },
        Title = "Day " .. (v25 - 1) % 7 + 1,
        Description = ""
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1
local LoopedRewards_13 = t.LoopedRewards
local v26 = #LoopedRewards_13 + 1
table.insert(
    LoopedRewards_13,
    {
        LoginRewardID = "LoginRewardLooped" .. v26,
        Rewards = { { Name = "Prime Goodie Bag", Quantity = 1, Weapon = "IsRandom" } },
        Title = "Day " .. (v26 - 1) % 7 + 1,
        Description = "Grand prize!"
    }
)
t.NUM_LOOPED_LOGIN_REWARD_MILESTONES += 1

return t
