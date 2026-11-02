local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local TeammateSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.TeammateSlot)
local EliminationBoardSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EliminationBoardSlot"
)
local EliminationBoardGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EliminationBoardGui"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 14
    -- upvalues:
    --  [1] t (copy)
    --  [2] EliminationBoardGui (copy)

    local t_1 = setmetatable({}, t)
    t_1.Part = arg1
    t_1.SurfaceGui = EliminationBoardGui:Clone()
    t_1._slots = {}
    t_1._layout_order = 0
    t_1:_Init()

    return t_1
end

function t.NewElimination(
    arg2,
    arg3,
    arg4,
    arg5,
    _,
    arg7
) -- line: 32
    -- upvalues:
    --  [1] EliminationBoardSlot (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] TeammateSlot_m (copy)

    arg2._layout_order -= 1
    local v1 = EliminationBoardSlot:Clone()
    local Weapon = v1.Weapon
    Weapon.Image = ItemLibrary_m.Items[arg7] and ItemLibrary_m.Items[arg7].Image or ""
    v1.LayoutOrder = arg2._layout_order
    local v3 = arg3.Character

    if v3 then
        v3 = arg3.Character:FindFirstChild("Humanoid")
    end

    local v4 = TeammateSlot_m.new
    local UserId = arg3.UserId
    local v5 = if v3 then v3.Health / v3.MaxHealth else 0
    v4(UserId, arg4, v5).SlotFrame.Parent = v1.Eliminator
    v4 = arg5.Character

    if v4 then
        v4 = arg5.Character:FindFirstChild("Humanoid")
    end

    local New = TeammateSlot_m.new
    local UserId_1 = arg5.UserId
    local v6 = if v4 then v4.Health / v4.MaxHealth else 0
    New(UserId_1, arg4, v6).SlotFrame.Parent = v1.Victim
    v1.Parent = arg2.SurfaceGui.List.Container
    table.insert(arg2._slots, 1, v1)
    v4 = table.remove(arg2._slots, 31)

    if v4 then
        v4:Destroy()
    end
end

function t._Setup(arg8) -- line: 61
    -- upvalues:
    --  [1] Players (copy)

    arg8.SurfaceGui.Adornee = arg8.Part
    arg8.SurfaceGui.Parent = Players.LocalPlayer.PlayerGui
end

function t._Init(arg9) -- line: 66
    arg9.SurfaceGui.List.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function() -- line: 67
            -- upvalues:
            --  [1] arg9 (copy)

            arg9.SurfaceGui.List.CanvasSize = UDim2.new(
                0,
                0,
                0,
                arg9.SurfaceGui.List.Container.Layout.AbsoluteContentSize.Y
            )
        end
    )
    arg9:_Setup()
end

return t
