local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local JumpPads = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild(
    "JumpPads"
)
local t = {}
t.Default = { "rbxassetid://85163949920258", 1 }
t.Trampoline = { "rbxassetid://75001064846226", 1 }
t["Bounce House"] = { "rbxassetid://139519788113881", 1 }
t["Shady Chicken Sandwich"] = { "rbxassetid://99488347318534", 1.25 }
t["Spider Web"] = { "rbxassetid://88449856112147", 1.25 }
t["Jolly Man"] = { "rbxassetid://111488886881644", 1.5 }
t["Flamingo Floatie"] = { "rbxassetid://139519788113881", 1 }
local t_8 = {}
t_8.Default = { "rbxassetid://17835965985", 1 }
t_8.Trampoline = { "rbxassetid://79142560912255", 1 }
t_8["Bounce House"] = { "rbxassetid://18963214636", 1 }
t_8["Shady Chicken Sandwich"] = { "rbxassetid://138205332923098", 1.25 }
t_8["Spider Web"] = { "rbxassetid://128812513158754", 1.25 }
t_8["Flamingo Floatie"] = { "rbxassetid://130086876465618", 1 }
local t_15 = {}
t_15.__index = t_15

function t_15._new() -- line: 33
    -- upvalues:
    --  [1] t_15 (copy)

    local t_16 = setmetatable({}, t_15)
    t_16:_Init()

    return t_16
end

function t_15.CreateJumpPadVisual(_, arg2, arg3) -- line: 45
    -- upvalues:
    --  [1] JumpPads (copy)

    local v1 = (JumpPads:FindFirstChild(arg2 or "Default") or JumpPads.Default):Clone()
    v1:ScaleTo(v1:GetScale() * arg3.X / 10)

    for _, descendant in pairs(v1:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.Massless = true
        end
    end

    return v1
end

function t_15._ObjectAdded(arg4, arg5) -- line: 66
    -- upvalues:
    --  [1] t_8 (copy)
    --  [2] t (copy)
    --  [3] Utility_m (copy)
    --  [4] FighterController_m (copy)
    --  [5] WrapController_m (copy)
    --  [6] RunService (copy)

    local _ = function() --[[ get_cframe ]] -- line: 67
        -- upvalues:
        --  [1] arg5 (copy)

        return arg5:GetPivot() * CFrame.new(0, 0, arg5.Size.Z / 2)
    end

    local ViewModelName = arg5:GetAttribute("ViewModelName")
    local ObjectID = arg5:GetAttribute("ObjectID")
    local v4 = t_8[ViewModelName] or t_8.Default
    local v5 = t[ViewModelName] or t.Default
    arg5:SetAttribute("SoundID", v4[1])
    arg5:SetAttribute("SoundVolume", v4[2])
    Utility_m:CreateSound(
        v5[1],
        v5[2],
        1.25,
        arg5,
        true,
        5
    )
    v5 = arg4:CreateJumpPadVisual(ViewModelName, arg5.Size)
    v5.Parent = arg5
    v4 = FighterController_m:GetWrap(ObjectID)

    if v4 then
        WrapController_m:ApplyWrap(WrapController_m:RecordOriginalWrapProperties(v5), v4, true)
    end

    local v9 = v5:GetScale() * 1.25
    local scale_1 = v5:GetScale()
    local cframe = CFrame.Angles(0, 0, 0.17453292519943295 * (math.random() - 0.5))
    local now = tick()

    while true do
        if not (tick() < now + 0.25) then
            break
        end

        local v11 = 1 - (1 - (tick() - now) / 0.25) ^ 3
        v5:ScaleTo(v9 + (scale_1 - v9) * v11)
        v5:PivotTo(
            arg5:GetPivot() * CFrame.new(0, 0, arg5.Size.Z / 2) * cframe:Lerp(CFrame.identity, v11)
        )
        RunService.RenderStepped:Wait()
    end

    v5:ScaleTo(scale_1)
    v5:PivotTo(arg5:GetPivot() * CFrame.new(0, 0, arg5.Size.Z / 2))

    for _, descendant_1 in pairs(v5:GetDescendants()) do
        if descendant_1:IsA("BasePart") then
            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = arg5
            WeldConstraint.Part1 = descendant_1
            WeldConstraint.Parent = descendant_1
            descendant_1.Anchored = false
        end
    end
end

function t_15._Init(arg6) -- line: 120
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("JumpPadHitbox"):Connect(function(arg7) -- line: 121
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_ObjectAdded(arg7)
    end)

    for _, val in pairs(CollectionService:GetTagged("JumpPadHitbox")) do
        task.defer(arg6._ObjectAdded, arg6, val)
    end
end

return t_15._new()
