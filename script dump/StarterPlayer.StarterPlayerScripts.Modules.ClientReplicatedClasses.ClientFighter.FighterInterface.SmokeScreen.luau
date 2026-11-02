local _ = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)
    --  [2] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1._smoke_cloud_spring = Spring_m.new(0, 1, 20)
    t_1._smoke_cloud_cover = Instance.new("Part")
    t_1._smoke_cloud_dof = Instance.new("DepthOfFieldEffect")
    t_1._smoke_cloud_cc = Instance.new("ColorCorrectionEffect")
    t_1._smoke_clouds_entered = {}
    t_1:_Init()

    return t_1
end

function t.Hide(arg2) -- line: 31
    arg2._smoke_cloud_cover.Parent = nil
    arg2._smoke_cloud_dof.Parent = nil
    arg2._smoke_cloud_cc.Parent = nil
end

function t.Update(arg3, _, _) -- line: 37
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] ReplicatedStorage (copy)

    local v1 = arg3:_GetSmokeCloud()
    arg3._smoke_cloud_spring.Target = if v1 then 1 else 0
    arg3._smoke_cloud_spring.Speed = if not v1 then 20 else 100
    arg3._smoke_cloud_cover.Transparency = 1 + -0.989 * arg3._smoke_cloud_spring.Value
    arg3._smoke_cloud_cover.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -0.25)
    arg3._smoke_cloud_cover.Parent = workspace
    arg3._smoke_cloud_dof.FarIntensity = arg3._smoke_cloud_spring.Value
    local SmokeCloudDof = arg3._smoke_cloud_dof
    SmokeCloudDof.Parent = arg3._smoke_cloud_spring.Value > 0.001 and Lighting or nil
    arg3._smoke_cloud_cc.Contrast = 0 + -1 * arg3._smoke_cloud_spring.Value
    arg3._smoke_cloud_cc.TintColor = Color3.fromRGB(255, 255, 255):Lerp(
        Color3.fromRGB(99, 99, 99),
        arg3._smoke_cloud_spring.Value
    )
    arg3._smoke_cloud_cc.Parent = Lighting

    if v1 and not arg3._smoke_clouds_entered[v1] then
        arg3._smoke_clouds_entered[v1] = true
        ReplicatedStorage.Remotes.Replication.Fighter.WasSmoked:FireServer(
            v1:GetAttribute("ObjectID")
        )
    end
end

function t.Clear(arg6) -- line: 60
    arg6._smoke_clouds_entered = {}
end

function t.Destroy(arg7) -- line: 64
    arg7._smoke_cloud_cover:Destroy()
    arg7._smoke_cloud_dof:Destroy()
    arg7._smoke_cloud_cc:Destroy()
    arg7:Clear()
end

function t._GetSmokeCloud(arg8) -- line: 76
    -- upvalues:
    --  [1] GameplayUtility_m (copy)

    local Position = workspace.CurrentCamera.CFrame.Position
    local v5 = arg8.FighterInterface.ClientFighter.Entity and arg8.FighterInterface.ClientFighter.Entity.RootPart.Position or nil

    for _, val in pairs({ Position, v5 }) do
        local v6 = GameplayUtility_m:GetSmokeCloudsInSphere(val)[1]

        if v6 then
            return v6
        end
    end
end

function t._Setup(arg9) -- line: 88
    arg9._smoke_cloud_cover.Color = Color3.fromRGB(72, 75, 79)
    arg9._smoke_cloud_cover.Anchored = true
    arg9._smoke_cloud_cover.CanCollide = false
    arg9._smoke_cloud_cover.CastShadow = false
    arg9._smoke_cloud_cover.CanQuery = false
    arg9._smoke_cloud_cover.CanTouch = false
    arg9._smoke_cloud_cover.Size = Vector3.new(10, 10, 0)
    arg9._smoke_cloud_cover.Material = Enum.Material.Neon
    arg9._smoke_cloud_cover.Transparency = 1
    arg9._smoke_cloud_dof.FarIntensity = 0
    arg9._smoke_cloud_dof.FocusDistance = 0
    arg9._smoke_cloud_dof.InFocusRadius = 1.75
    arg9._smoke_cloud_dof.NearIntensity = 0
end

function t._Init(arg10) -- line: 105
    arg10:_Setup()
end

return t
