local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local TrajectoryVisualNode = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "TrajectoryVisualNode"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._num_segments = arg1 or 100
    t_1._folder = Instance.new("Folder")
    t_1._impact_sphere = Instance.new("Part")
    t_1._segments = {}
    t_1._renderstep_connection = nil
    t_1._last_args = {}
    t_1:_Init()

    return t_1
end

function t.OnStep(arg2, arg3) -- line: 38
    -- upvalues:
    --  [1] RunService (copy)

    if arg2._renderstep_connection then
        arg2._renderstep_connection:Disconnect()
        arg2._renderstep_connection = nil
    end

    arg2._renderstep_connection = RunService.RenderStepped:Connect(arg3)
end

function t.Update(
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10
) -- line: 49
    -- upvalues:
    --  [1] Utility_m (copy)

    if
        arg4._last_args[1] == arg5
        and arg4._last_args[2] == arg6
        and arg4._last_args[3] == arg7
        and arg4._last_args[4] == arg8
        and arg4._last_args[5] == arg9
        and arg4._last_args[6] == arg10
    then
        return
    end

    arg4._last_args = { arg5, arg6, arg7, arg8, arg9, arg10 }
    local v1 = arg7 or 196.2
    local v2 = arg8 or 0.05
    local v3 = arg10 or math.huge
    local v4 = arg5
    local v5 = false

    for key, val in pairs(arg4._segments) do
        if v5 then
            val.CFrame = CFrame.new(v4)
        else
            local minimum = math.min(v3, (key - 1) * v2 + 0)
            local v6 = arg5 + arg6 * minimum - Vector3.new(0, 1, 0) * v1 * minimum ^ 2

            if v4:FuzzyEq(v6) then
                val.CFrame = CFrame.new(v4)
            else
                local raycastResult = Utility_m:Raycast(
                    v4,
                    v6,
                    (v4 - v6).Magnitude,
                    arg9,
                    Enum.RaycastFilterType.Include
                )
                local v7 = v4:FuzzyEq(raycastResult.Position) and CFrame.new(v4) or CFrame.new(
                    v4,
                    raycastResult.Position
                )
                val.CFrame = v7
                v4 = raycastResult.Position

                if raycastResult.Instance or v3 <= minimum then
                    v5 = true
                end
            end
        end
    end

    arg4._impact_sphere.CFrame = CFrame.new(v4)
end

function t.Destroy(arg11) -- line: 91
    if arg11._renderstep_connection then
        arg11._renderstep_connection:Disconnect()
        arg11._renderstep_connection = nil
    end

    arg11._folder:Destroy()
end

function t._Setup(arg12) -- line: 104
    -- upvalues:
    --  [1] TrajectoryVisualNode (copy)

    for index = 1, arg12._num_segments do
        local v8 = TrajectoryVisualNode:Clone()
        v8.Size = Vector3.new(1, 2, 1) * (index * 0.02 + 0.1)
        v8.Parent = arg12._folder
        arg12._segments[index] = v8
        local v9 = arg12._segments[index - 1]

        if v9 then
            v8.Beam.Attachment0 = v9.Attachment
            v8.Beam.Width0 = v9.Size.Y / 4
            v8.Beam.Width1 = v8.Beam.Width0
        end
    end

    arg12._impact_sphere.Shape = "Ball"
    arg12._impact_sphere.Color = Color3.fromRGB(255, 255, 255)
    arg12._impact_sphere.Material = Enum.Material.ForceField
    arg12._impact_sphere.Size = Vector3.new(3, 3, 3)
    arg12._impact_sphere.Anchored = true
    arg12._impact_sphere.CanCollide = false
    arg12._impact_sphere.CanTouch = false
    arg12._impact_sphere.CanQuery = false
    arg12._impact_sphere.CastShadow = false
    arg12._impact_sphere.Parent = arg12._folder
    arg12._folder.Parent = workspace
end

function t._Init(arg13) -- line: 134
    arg13:_Setup()
end

return t
