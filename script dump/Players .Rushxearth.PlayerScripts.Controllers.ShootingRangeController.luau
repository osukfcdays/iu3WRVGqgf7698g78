local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local ShootingRangeDisplay_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ShootingRangeDisplay")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local t = {}
t.__index = t

function t._new() -- line: 16
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._enter_cooldown = 0
    t_1._exit_cooldown = 0
    t_1._shooting_range_displays = {}
    t_1:_Init()

    return t_1
end

function t.Enter(_, ...) -- line: 32
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] ReplicatedStorage (copy)

    Pages_m.PageSystem:CloseCurrentPage()
    ReplicatedStorage.Remotes.Misc.ShootingRangeEnter:FireServer(...)
end

function t.Leave(_, arg3) -- line: 37
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Misc.ShootingRangeLeave:FireServer(arg3)
end

function t._TrashPromptAdded(_, arg5) -- line: 45
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] tweenInfo (copy)
    --  [3] Players (copy)
    --  [4] ReplicatedStorage (copy)

    local ProximityPrompt = arg5:WaitForChild("Primary"):WaitForChild("ProximityPrompt")
    local Close = arg5:WaitForChild("MeshPart"):WaitForChild("Close")
    local Open = arg5:WaitForChild("MeshPart"):WaitForChild("Open")
    local Lid = arg5:WaitForChild("Lid")
    local v4 = nil

    local function move_lid(arg6) -- line: 52
        -- upvalues:
        --  [1] v4 (ref)
        --  [2] TweenService (ref)
        --  [3] Lid (copy)
        --  [4] tweenInfo (ref)

        if v4 then
            v4:Pause()
            v4:Destroy()
        end

        v4 = TweenService:Create(Lid, tweenInfo, { CFrame = arg6 })
        v4:Play()
    end

    ProximityPrompt.PromptShown:Connect(function() -- line: 62
        -- upvalues:
        --  [1] move_lid (copy)
        --  [2] Open (copy)

        move_lid(Open.WorldCFrame)
    end)
    ProximityPrompt.PromptHidden:Connect(function() -- line: 66
        -- upvalues:
        --  [1] move_lid (copy)
        --  [2] Close (copy)

        move_lid(Close.WorldCFrame)
    end)
    ProximityPrompt.Triggered:Connect(function(playerWhoTriggered: Player) -- line: 70
        -- upvalues:
        --  [1] Players (ref)
        --  [2] ReplicatedStorage (ref)

        if playerWhoTriggered == Players.LocalPlayer then
            ReplicatedStorage.Remotes.Misc.ShootingRangeTrashItems:FireServer()
        end
    end)
end

function t._EntranceAdded(arg8, arg9) -- line: 77
    -- upvalues:
    --  [1] Players (copy)
    --  [2] ShootingRangeDisplay_m (copy)

    arg9.Touched:Connect(function(otherPart: BasePart) -- line: 78
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] Players (ref)

        if
            tick() > arg8._enter_cooldown
            and otherPart
            and otherPart.AssemblyRootPart
            and otherPart.AssemblyRootPart.Parent
            and Players:GetPlayerFromCharacter(otherPart.AssemblyRootPart.Parent) == Players.LocalPlayer
        then
            arg8._enter_cooldown = tick() + 1
            arg8:Enter()
        end
    end)
    arg8._shooting_range_displays[arg9] = ShootingRangeDisplay_m.new(arg9)
end

function t._ExitAdded(arg11, arg12) -- line: 88
    -- upvalues:
    --  [1] Players (copy)

    arg12.Touched:Connect(function(otherPart_1: BasePart) -- line: 89
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] Players (ref)

        if
            tick() > arg11._exit_cooldown
            and otherPart_1
            and otherPart_1.AssemblyRootPart
            and otherPart_1.AssemblyRootPart.Parent
            and Players:GetPlayerFromCharacter(otherPart_1.AssemblyRootPart.Parent) == Players.LocalPlayer
        then
            arg11._exit_cooldown = tick() + 1
            arg11:Leave()
        end
    end)
end

function t._HookLocalFighter(arg14) -- line: 97
    -- upvalues:
    --  [1] FighterController_m (copy)

    local v7 = FighterController_m:WaitForLocalFighter()

    local function update_displays() -- line: 100
        -- upvalues:
        --  [1] v7 (copy)
        --  [2] arg14 (copy)

        local v8 = not v7:Get("IsInDuel")

        if v8 then
            v8 = not v7:Get("IsInShootingRange")
        end

        for _, val in pairs(arg14._shooting_range_displays) do
            val:SetEnabled(v8)
        end
    end

    v7:GetDataChangedSignal("IsInShootingRange"):Connect(update_displays)
    v7:GetDataChangedSignal("IsInDuel"):Connect(update_displays)
    update_displays()
end

function t._ShootingRangeVisuals(_) -- line: 113
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] CollectionService (copy)

    local function object_added(arg16) -- line: 114
        -- upvalues:
        --  [1] CONSTANTS_m (ref)

        local Doors = arg16:WaitForChild("Doors")
        local Sign = arg16:WaitForChild("Sign")

        if CONSTANTS_m.SHOOTING_RANGE_ACTIVE then
            task.defer(Doors.Destroy, Doors)

            return
        end

        task.defer(Sign.Destroy, Sign)
        Doors:PivotTo(Doors:GetPivot() + Vector3.new(0, 100, 0))
    end

    CollectionService:GetInstanceAddedSignal("LobbyShootingRangeVisuals"):Connect(object_added)

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyShootingRangeVisuals")) do
        task.defer(object_added, val_1)
    end
end

function t._Init(arg17) -- line: 133
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] CollectionService (copy)

    task.defer(arg17._ShootingRangeVisuals, arg17)

    if not CONSTANTS_m.SHOOTING_RANGE_ACTIVE then
        return
    end

    CollectionService:GetInstanceAddedSignal("ShootingRangeEntrance"):Connect(function(arg18) -- line: 140
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_EntranceAdded(arg18)
    end)
    CollectionService:GetInstanceAddedSignal("ShootingRangeTrashPrompt"):Connect(function(arg19) -- line: 144
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_TrashPromptAdded(arg19)
    end)
    CollectionService:GetInstanceAddedSignal("ShootingRangeExit"):Connect(function(arg20) -- line: 148
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_ExitAdded(arg20)
    end)

    for _, val_2 in pairs(CollectionService:GetTagged("ShootingRangeEntrance")) do
        task.defer(arg17._EntranceAdded, arg17, val_2)
    end

    for _, val_3 in pairs(CollectionService:GetTagged("ShootingRangeTrashCan")) do
        task.defer(arg17._TrashPromptAdded, arg17, val_3)
    end

    for _, val_4 in pairs(CollectionService:GetTagged("ShootingRangeExit")) do
        task.defer(arg17._ExitAdded, arg17, val_4)
    end

    task.spawn(arg17._HookLocalFighter, arg17)
end

return t._new()
