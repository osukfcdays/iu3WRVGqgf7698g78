local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local PreloadController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 20
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1._teleport_cooldown = 0
    t_1:_Init()

    return t_1
end

function t._ObjectAdded(arg1, arg2) -- line: 40
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Players (copy)
    --  [3] FighterController_m (copy)
    --  [4] SpectateController_m (copy)
    --  [5] Utility_m (copy)
    --  [6] BetterDebris_m (copy)
    --  [7] PreloadController_m (copy)
    --  [8] RunService (copy)
    --  [9] CameraController_m (copy)

    if CONSTANTS_m.IS_ARCADE_SERVER then
        return
    end

    local Camera = arg2:WaitForChild("Camera")
    local Entrance = arg2:WaitForChild("Entrance")
    local Exit = arg2:WaitForChild("Exit")
    Entrance.Touched:Connect(function(otherPart: BasePart) -- line: 49
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] Players (ref)
        --  [3] FighterController_m (ref)
        --  [4] SpectateController_m (ref)
        --  [5] Utility_m (ref)
        --  [6] Entrance (copy)
        --  [7] Exit (copy)
        --  [8] BetterDebris_m (ref)
        --  [9] PreloadController_m (ref)
        --  [10] RunService (ref)
        --  [11] CameraController_m (ref)
        --  [12] Camera (copy)

        if
            tick() < arg1._teleport_cooldown
            or otherPart.Parent ~= Players.LocalPlayer.Character
            or not FighterController_m.LocalFighter
            or not FighterController_m.LocalFighter:IsAlive()
            or SpectateController_m.CurrentDuelSubject
            or SpectateController_m.CurrentSubject ~= FighterController_m.LocalFighter
        then
            return
        end

        arg1._teleport_cooldown = tick() + 5.3 + 1
        Utility_m:CreateSound(
            "rbxassetid://86785771664692",
            0.5,
            1 + 0.1 * math.random(),
            Entrance,
            true,
            10
        )
        Utility_m:CreateSound(
            "rbxassetid://81610952487049",
            1,
            1 + 0.1 * math.random(),
            Exit,
            true,
            10
        )
        local Humanoid = FighterController_m.LocalFighter.Entity.Humanoid
        local UpperTorso = FighterController_m.LocalFighter.Entity.Model:FindFirstChild(
            "UpperTorso"
        )
        local RootPart = FighterController_m.LocalFighter.Entity.RootPart
        local RootRigAttachment = RootPart:FindFirstChild("RootRigAttachment")
        local AlignPosition = Instance.new("AlignPosition")
        AlignPosition.Position = Exit.Position
        AlignPosition.Attachment0 = RootRigAttachment
        AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
        AlignPosition.MaxAxesForce = Vector3.new(1, 0, 1) * math.huge
        AlignPosition.Responsiveness = 20
        AlignPosition.ForceRelativeTo = Enum.ActuatorRelativeTo.World
        AlignPosition.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        AlignPosition.Parent = RootPart
        BetterDebris_m:AddItem(AlignPosition, 5.3)
        local AlignOrientation = Instance.new("AlignOrientation")
        AlignOrientation.Attachment0 = RootRigAttachment
        AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        AlignOrientation.CFrame = Exit.CFrame.Rotation
        AlignOrientation.RigidityEnabled = true
        AlignOrientation.Parent = RootPart
        BetterDebris_m:AddItem(AlignOrientation, 5.3)
        RootPart.CFrame = Exit.CFrame + Vector3.new(math.random() - 0.5, 0, math.random() - 0.5) * Exit.Size
        Humanoid:LoadAnimation(PreloadController_m:GetPreloadedAnimation("LobbyPortalFalling")):Play(
            0
        )
        RunService:BindToRenderStep("LobbyPortalFalling", CameraController_m:GetRenderstepPriority() + 1, function(
            _
        ) -- line: 98
            -- upvalues:
            --  [1] Camera (ref)
            --  [2] UpperTorso (copy)
            --  [3] RootPart (copy)

            workspace.CurrentCamera.FieldOfView = 30
            local CurrentCamera = workspace.CurrentCamera
            local New = CFrame.new
            local Position = Camera.Position
            local v11 = UpperTorso or RootPart
            CurrentCamera.CFrame = New(Position, v11.Position)
        end)
        wait(5.3)
        RunService:UnbindFromRenderStep("LobbyPortalFalling")
    end)
end

function t._Init(arg5) -- line: 109
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyPortal"):Connect(function(arg6) -- line: 110
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_ObjectAdded(arg6)
    end)

    for _, val in pairs(CollectionService:GetTagged("LobbyPortal")) do
        task.defer(arg5._ObjectAdded, arg5, val)
    end
end

return t._new()
