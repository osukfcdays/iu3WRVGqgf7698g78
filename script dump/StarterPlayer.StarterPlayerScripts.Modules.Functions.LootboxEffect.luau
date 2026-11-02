local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local Attachment = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild(
    "LootboxCollectParticles"
):WaitForChild("Attachment")
local UnboxEffect = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild(
    "UnboxEffect"
)
local Lootboxes = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Lootboxes")
local t = {}
t.Common = { "rbxassetid://18182950485", 0.5 }
t.Rare = { "rbxassetid://18182950836", 0.375 }
t.Legendary = { "rbxassetid://18182950182", 0.375 }
t.Mythical = { "rbxassetid://115151712865765", 0.5 }
t.Standard = { "rbxassetid://18182950485", 0.5 }
t.Prime = { "rbxassetid://18182950182", 0.375 }
local v1 = 0

return function(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    _,
    arg8
) -- line: 28
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] v1 (ref)
    --  [3] Lootboxes (copy)
    --  [4] BetterDebris_m (copy)
    --  [5] Utility_m (copy)
    --  [6] CONSTANTS_m (copy)
    --  [7] UnboxEffect (copy)
    --  [8] Players (copy)
    --  [9] RewardSlot_m (copy)
    --  [10] ItemLibrary_m (copy)
    --  [11] t (copy)
    --  [12] TweenService (copy)
    --  [13] Attachment (copy)

    local v2 = arg3[1] and CosmeticLibrary_m.Cosmetics[arg3[1].RewardData.Name]
    local v3 = arg3[1] and CosmeticLibrary_m.Rewards[arg3[1].RewardData.Name]
    local v4 = CosmeticLibrary_m.Rewards[arg2]

    if arg4 and arg4 > 0 then
        wait(arg4)
    end

    v1 += 1
    local v7 = v1 * 3.141592653589793 * 2 / 8 + math.floor((v1 - 1) / 8) * 3.141592653589793 / 8 + math.rad(
        math.floor(v1 - 1) * 5
    )
    local v8 = math.floor((v1 % 64 - 1) / 8) * 1
    local v9 = Lootboxes[arg2]:Clone()
    local v10 = v9:FindFirstChild("HumanoidRootPart") or v9:FindFirstChild("RootPart")

    for _, descendant in pairs(v9:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.Anchored = false
        end
    end

    if v4.SoundProfile == "PrizeWheel" then
        if not v2 or v2.Type ~= "Skin" then
            v9.wheel.Slices:PivotTo(
                v9.wheel.Slices:GetPivot() * CFrame.Angles(
                    0,
                    0,
                    1.0471975511965976 * Random.new(arg8):NextInteger(1, 5)
                )
            )
        end

        for _, val in pairs(v9.wheel.Slices:GetChildren()) do
            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = val
            WeldConstraint.Part1 = v9.wheel
            WeldConstraint.Parent = val
        end
    end

    v10.Anchored = true
    v9.Parent = workspace
    BetterDebris_m:AddItem(v9, 15)
    Utility_m:CreateSound(
        "rbxassetid://18183233381",
        0.5,
        1 + 0.25 * math.random(),
        v10,
        true
    )
    v10 = CFrame.new(arg1) * CFrame.Angles(0, v7, 0)
    local v17 = CFrame.new(arg1) * CFrame.Angles(0, v7, 0) * CFrame.new(0, -3, v8 + 7)
    Utility_m:RenderstepForLoop(0, 100, 2, function(arg9) -- line: 76
        -- upvalues:
        --  [1] v10 (copy)
        --  [2] v17 (copy)
        --  [3] v9 (copy)

        local v18 = arg9 / 100
        local v19 = 1 - (1 - v18) ^ 5
        local cosine = math.cos(9.42477796076938 * (v18 + 0.25))
        local absoluteValue = math.abs(cosine * (v18 - 1) / 0.707)
        local v21 = v10:Lerp(v17, v19)
        v9:PivotTo(CFrame.new(v21.X, v17.Y + (v10.Y - v17.Y) * absoluteValue, v21.Z) * v21.Rotation)
    end)
    BetterDebris_m:AddItem(v9, v9.Animation:GetAttribute("Duration"))
    task.spawn(CONSTANTS_m.IS_STUDIO and task.defer or pcall, function() -- line: 88
        -- upvalues:
        --  [1] v9 (copy)
        --  [2] v4 (copy)

        v9.AnimationController:LoadAnimation(v9.Animation):Play()
        require(script[v4.SoundProfile])(v9)
    end)
    wait(v9.Animation:GetAttribute("RevealDelay"))
    local v26 = UnboxEffect:Clone()
    v26.CFrame = v17 + Vector3.new(0, 8, 0)
    v26.Parent = workspace
    BetterDebris_m:AddItem(v26, 15)
    local BillboardGui = v26.BillboardGui
    BillboardGui.Adornee = v26
    BillboardGui.Parent = Players.LocalPlayer.PlayerGui
    BetterDebris_m:AddItem(BillboardGui, 15)

    for _, val_1 in pairs(arg3) do
        local v27 = RewardSlot_m.new(val_1.RewardData, true)
        v27:SetInteractable(false)
        v27:SetParent(BillboardGui.Container)
    end

    BillboardGui.Container.Size = UDim2.new(0.25, 0, 0.25, 0)
    BillboardGui.Container.Position = UDim2.new(0.5, 0, 0.75, 0)
    BillboardGui.Container:TweenSizeAndPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        0.5,
        true
    )
    local v28 = nil
    local Color = nil

    if v2 then
        v28 = v2.Rarity
        Color = CosmeticLibrary_m.Rarities[v2.Rarity].Color
    elseif v3 then
        local v30 = ItemLibrary_m.Items[v3.Name]
        local v31 = v30 and v30.Status or "Standard"
        v28 = v31
        Color = ItemLibrary_m.Statuses[v31].Color
    end

    if v28 and Color then
        v26.Trail.Color = ColorSequence.new(Color)
        v3 = t[v28]

        if v3 then
            local v32 = Utility_m
            local v33 = v3[1]
            v32:CreateSound(
                v33,
                v3[2] * (if arg6 ~= Players.LocalPlayer then 0.5 else 1),
                1,
                v26,
                true
            )
        end
    end

    v28 = BillboardGui.Container
    wait(4)

    if v28:IsDescendantOf(workspace) then
        v28:TweenSize(
            UDim2.new(0, 0, 0, 0),
            "In",
            "Back",
            1,
            true
        )
    end

    if not arg5 then
        return
    end

    local v37 = v26.CFrame
    Utility_m:RenderstepForLoop(0, 100, 1.9, function(arg10) -- line: 153
        -- upvalues:
        --  [1] TweenService (ref)
        --  [2] v26 (copy)
        --  [3] v37 (copy)
        --  [4] arg5 (copy)

        local v40 = TweenService:GetValue(
            arg10 / 100,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In
        )
        v26.CFrame = v37:Lerp(arg5.CFrame, v40)
    end)
    v2 = Attachment:Clone()
    v2.Parent = arg5

    for _, val_2 in pairs(v2:GetChildren()) do
        val_2:SetAttribute("IgnoreVisibilityCheck", true)
        local v43 = Color and ColorSequence.new(Color) or val_2.Color
        val_2.Color = v43
    end

    Utility_m:PlayParticles(v2)
    Utility_m:CreateSound(
        "rbxassetid://109954155299965",
        0.75,
        1 + 0.25 * math.random(),
        arg5,
        true
    )
    v26:Destroy()
    BillboardGui:Destroy()
end
