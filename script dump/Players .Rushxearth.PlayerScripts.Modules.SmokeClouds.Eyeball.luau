local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local QuaternionSpring_m = require(ReplicatedStorage.Modules.QuaternionSpring)
local Quaternion_m = require(ReplicatedStorage.Modules.Quaternion)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local SmokeCloud_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("SmokeCloud"))
local t = setmetatable({}, SmokeCloud_m)
t.__index = t

function t.new(...) -- line: 19
    -- upvalues:
    --  [1] SmokeCloud_m (copy)
    --  [2] t (copy)
    --  [3] QuaternionSpring_m (copy)
    --  [4] Quaternion_m (copy)
    --  [5] Spring_m (copy)

    local t_1 = setmetatable(SmokeCloud_m.new(...), t)
    t_1._direction_spring = QuaternionSpring_m.new(
        Quaternion_m.fromCFrame(CFrame.identity),
        0.75,
        10
    )
    t_1._pupil_size_spring = Spring_m.new(0.187, 0.75, 5)
    t_1._next_direction_update = 0
    t_1._direction_update_count = 0
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 36
    -- upvalues:
    --  [1] Quaternion_m (copy)

    if arg1:_UpdateCoreLogic() then
        return
    end

    if tick() > arg1._next_direction_update then
        arg1._direction_update_count += 1
        local cframe_1

        if arg1._direction_update_count % 30 == 0 then
            cframe_1 = CFrame.new(arg1.Part.Position, workspace.CurrentCamera.CFrame.Position)
            arg1._direction_spring.Speed = 10
            arg1._pupil_size_spring.Target = 0.3
            arg1._next_direction_update = tick() + 3
        else
            local v4 = Random.new():NextUnitVector()
            cframe_1 = CFrame.new(Vector3.new(0, 0, 0), (Vector3.new(v4.X, (v4.Y + 1) / 2, v4.Z)))
            arg1._direction_spring.Speed = 10
            arg1._pupil_size_spring.Target = 0.187
            arg1._next_direction_update = tick() + 0.1
        end

        arg1._direction_spring.Target = Quaternion_m.fromCFrame(cframe_1)
    elseif arg1._direction_update_count % 30 == 0 then
        arg1._direction_spring.Target = Quaternion_m.fromCFrame(
            CFrame.new(arg1.Part.Position, workspace.CurrentCamera.CFrame.Position)
        )
    end

    arg1.Model.Pupil.Size = Vector3.new(
        arg1._pupil_size_spring.Value,
        arg1._pupil_size_spring.Value,
        0.009
    ) * arg1.Model:GetScale()
    arg1.Model:PivotTo(
        CFrame.new(arg1.Part.Position) * arg1._direction_spring.Position:ToCFrame().Rotation
    )
end

function t._Setup(arg3) -- line: 73
    arg3.Model.Iris.Color = Color3.fromHSV(math.random(), 1, 1)
end

function t._Init(arg4) -- line: 77
    arg4:_Setup()
end

return t
