local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ConceptsLibrary_m = require(ReplicatedStorage.Modules.ConceptsLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local CreditsPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "CreditsPlayerSlot"
)
local t = {
    { "Tester", Color3.fromRGB(255, 215, 0) },
    { "Moderator", Color3.fromRGB(255, 127, 0) },
    { "Community Staff", Color3.fromRGB(127, 110, 255) }
}
local color = Color3.fromRGB(159, 25, 255)
local _ = Color3.fromRGB(46, 204, 113)
local t_4 = {
    { 20349956, "Nosniy", "Owner, 3D Artist", color },
    { 15941965, "SenseiWarrior", "Owner, Programmer, UI/UX, SFX", color },
    { 780350915, "nekoanims", "Animation" },
    { 8034104, "GreatGuyBoom", "3D Artist, 2D Artist" },
    { 1730213868, "Brian1KB", "Matchmaking, Technical Advisor" },
    { 13108868, "ShadowTrojan", "3D Artist, 2D Artist, Wraps Artist" },
    { 25056711, "PrimeVoxel", "Particles" },
    { 42477697, "D_reamz", "Renders" },
    { 945382833, "himochu", "2D Artist" },
    { 113947873, "LiamGame09", "Wraps Artist" },
    { 182316511, "BSlickMusic", "Music, SFX" },
    { 1080973296, "xlISinner", "Anticheat" },
    { 424377859, "Kurookku", "Technical Advisor" },
    { 4444072910, "FluxxyBoiOfficial", "Bot Developer" },
    { 274029164, "StaredSystemized", "Graphics" },
    { 167445091, "SoftGB", "Graphics" }
}
local t_21 = setmetatable({}, Page_m)
t_21.__index = t_21

function t_21._new() -- line: 45
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_21 (copy)
    --  [3] PromptSystem_m (copy)

    local t_22 = setmetatable(Page_m.new(script.Name), t_21)
    t_22.PromptsFrame = t_22.PageFrame:WaitForChild("Prompts")
    t_22.PageContainer = t_22.PageFrame:WaitForChild("Container")
    t_22.CloseButton = t_22.PageContainer:WaitForChild("Close")
    t_22.List = t_22.PageContainer:WaitForChild("List")
    t_22.Container = t_22.List:WaitForChild("Container")
    t_22.Layout = t_22.Container:WaitForChild("Layout")
    t_22.ConceptorsFrame = t_22.Container:WaitForChild("Conceptors")
    t_22.ConceptorsContainer = t_22.ConceptorsFrame:WaitForChild("Container")
    t_22.ConceptorsPlayersFrame = t_22.ConceptorsContainer:WaitForChild("Players")
    t_22.ConceptorsPlayersLayout = t_22.ConceptorsPlayersFrame:WaitForChild("Layout")
    t_22.ConceptorsRewardFrame = t_22.ConceptorsContainer:WaitForChild("Reward")
    t_22.TeamFrame = t_22.Container:WaitForChild("Team")
    t_22.TeamEmptyFrame = t_22.TeamFrame:WaitForChild("Empty")
    t_22.TeamContainer = t_22.TeamFrame:WaitForChild("Container")
    t_22.TeamPlayersFrame = t_22.TeamContainer:WaitForChild("Players")
    t_22.TeamPlayersLayout = t_22.TeamPlayersFrame:WaitForChild("Layout")
    t_22.ContributorsFrame = t_22.Container:WaitForChild("Contributors")
    t_22.ContributorsEmptyFrame = t_22.ContributorsFrame:WaitForChild("Empty")
    t_22.ContributorsContainer = t_22.ContributorsFrame:WaitForChild("Container")
    t_22.ContributorsPlayersFrame = t_22.ContributorsContainer:WaitForChild("Players")
    t_22.ContributorsPlayersLayout = t_22.ContributorsPlayersFrame:WaitForChild("Layout")
    t_22.PromptSystem = PromptSystem_m.new(t_22.PromptsFrame)
    t_22:_Init()

    return t_22
end

function t_21._Update(arg1) -- line: 87
    arg1.List.Size = UDim2.new(0.85, 0, 0, arg1.PageFrame.AbsoluteSize.Y * 0.75)
    arg1.List.CanvasSize = UDim2.new(0, 0, 0, arg1.Layout.AbsoluteContentSize.Y)
    arg1.ConceptorsFrame.Size = UDim2.new(
        1,
        0,
        0.1325,
        arg1.ConceptorsPlayersLayout.AbsoluteContentSize.Y
    )
end

function t_21._Generate(arg2) -- line: 98
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] t_4 (copy)
    --  [3] t (copy)
    --  [4] ConceptsLibrary_m (copy)
    --  [5] ComplianceController_m (copy)
    --  [6] CreditsPlayerSlot (copy)
    --  [7] CONSTANTS_m (copy)
    --  [8] ButtonEffect_m (copy)

    local v7 = ReplicatedStorage.Remotes.Misc.RequestGroupMembers:InvokeServer()
    local t_23 = {}

    for _, val in pairs(t_4) do
        table.insert(t_23, val[1])
    end

    for _, val_1 in pairs(t) do
        local v8 = pairs
        local v9 = v7[val_1[1]] or {}

        for _, val_2 in v8(v9) do
            table.insert(t_23, val_2)
        end
    end

    for _, val_3 in pairs(ConceptsLibrary_m.Leaderboard) do
        table.insert(t_23, (tonumber(val_3.key)))
    end

    local v11 = ComplianceController_m:GetUserInfos(t_23)
    local v12 = 0

    local _ = function(
        arg3,
        arg4,
        arg5,
        arg6,
        arg7,
        arg8
    ) --[[ create_slot ]] -- line: 119
        -- upvalues:
        --  [1] v12 (ref)
        --  [2] CreditsPlayerSlot (ref)
        --  [3] CONSTANTS_m (ref)

        v12 += 1
        local v13 = CreditsPlayerSlot:Clone()
        v13.LayoutOrder = v12
        v13.Description.Text = arg5
        v13.Username.Text = arg4
        local v14 = arg8
        local Headshot = v13.Headshot

        if not v14 then
            v14 = string.format(CONSTANTS_m.HEADSHOT_IMAGE, arg3)
        end

        Headshot.Image = v14
        v13.Background.ImageColor3 = arg6
        v13.Parent = arg7

        return v13
    end

    for key_4, val_4 in pairs(ConceptsLibrary_m.Leaderboard) do
        local v15 = v11[val_4.key]
        local v10 = v15 and v15.Username and "@" .. v15.Username or "\226\128\162 \226\128\162 \226\128\162"
        local v16 = string.format("%.1f", val_4.value) .. " points"
        local Key = val_4.key
        local color_2 = Color3.fromRGB(0, 0, 0)
        v12 += 1
        local ConceptorsPlayersFrame = arg2.ConceptorsPlayersFrame
        local v17 = CreditsPlayerSlot:Clone()
        v17.LayoutOrder = v12
        v17.Description.Text = v16
        v17.Username.Text = v10
        v17.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, Key)
        v17.Background.ImageColor3 = color_2
        v17.Parent = ConceptorsPlayersFrame
        v17.LayoutOrder = key_4
        v17.Button.Visible = true
        v17.Button.MouseButton1Click:Connect(function() -- line: 167
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] val_4 (copy)
            --  [3] v10 (copy)

            arg2.PromptSystem:Open("InspectConceptor", tonumber(val_4.key), v10)
        end)
        ButtonEffect_m:Add(v17.Button)
    end
end

function t_21._Setup(arg9) -- line: 175
    -- upvalues:
    --  [1] RewardSlot_m (copy)
    --  [2] ConceptsLibrary_m (copy)

    arg9.TeamEmptyFrame.Visible = true
    arg9.TeamPlayersFrame.Visible = false
    arg9.ContributorsEmptyFrame.Visible = true
    arg9.ContributorsPlayersFrame.Visible = false
    RewardSlot_m.new({ Name = ConceptsLibrary_m.CONCEPT_REWARD_NAME, Weapon = "IsRandom" }):SetParent(
        arg9.ConceptorsRewardFrame
    )
end

function t_21._Init(arg10) -- line: 185
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg10.CloseButton.MouseButton1Click:Connect(function() -- line: 186
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:CloseRequest()
    end)
    arg10.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 190
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end)
    arg10.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 194
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end)
    arg10.ContributorsPlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 198
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end)
    arg10.ConceptorsPlayersLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 202
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end)
    arg10:_Setup()
    arg10:_Update()
    task.defer(arg10._Generate, arg10)
    ButtonEffect_m:Add(arg10.CloseButton)
end

return t_21._new()
