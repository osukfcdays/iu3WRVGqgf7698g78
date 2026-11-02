local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.RewardSlot)
local ContractMilestoneSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ContractMilestoneSlot"
)
local ContractSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ContractSlot")
local udim2 = UDim2.new(0.05, 0, 0.75, 0)
local t = {}
t.__index = t

function t.new(_, _) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] ContractSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = ContractSlot:Clone()
    t_1._num_milestones = 0
    t_1._progress = 0
    t_1._scale = 1
    t_1._milestones = {}
    t_1._default_tostring_function = nil
    t_1._requires_previous_milestone_completed = true
    t_1._contract_icon_image = nil
    t_1._contract_icon_size = nil
    t_1:_Init()

    return t_1
end

function t.SetImage(arg3, arg4, arg5) -- line: 39
    arg3.Frame.Container.Title.Left.Image = arg4
    local Left = arg3.Frame.Container.Title.Left
    local v1 = arg5 or arg3.Frame.Container.Title.Left.Size
    Left.Size = v1
end

function t.SetContractImage(arg6, arg7, arg8) -- line: 44
    arg6._contract_icon_image = arg7
    arg6._contract_icon_size = arg8
    arg6:_Update()
end

function t.SetTitle(arg9, arg10) -- line: 50
    arg9.Frame.Container.Title.Text = arg10
end

function t.SetDescription(arg11, arg12, arg13) -- line: 54
    arg11.Frame.Container.Description.Text = arg12
    arg11.Frame.Container.Description.Size = UDim2.new(0.9, 0, 0.025 * (arg13 or 1), 0)
    arg11:_Update()
end

function t.SetScale(arg14, arg15) -- line: 60
    arg14._scale = arg15
    arg14:_Update()
end

function t.SetProgress(arg16, arg17) -- line: 65
    arg16._progress = arg17
    arg16:_Update()
end

function t.SetRequiresPreviousMilestoneCompleted(arg18, arg19) -- line: 70
    arg18._requires_previous_milestone_completed = arg19
    arg18:_Update()
end

function t.AddMilestone(arg20, arg21, arg22, arg23) -- line: 75
    -- upvalues:
    --  [1] ContractMilestoneSlot (copy)
    --  [2] RewardSlot_m (copy)

    arg20._num_milestones += 1
    local v2 = ContractMilestoneSlot:Clone()
    v2.LayoutOrder = arg20._num_milestones
    v2.ZIndex = arg20._num_milestones
    v2.Goal.Visible = v2.Contract.Visible
    v2.Parent = arg20.Frame.Container.Milestones
    local _ = {}
    local v3 = arg23
    local Milestones = arg20._milestones

    if not v3 then
        v3 = arg20._default_tostring_function
    end

    table.insert(Milestones, { v2, arg21, arg22, v3 })

    if arg22 then
        RewardSlot_m.new(arg22).Frame.Parent = v2.Reward
    end

    arg20:_Update()
end

function t.Destroy(arg24) -- line: 93
    arg24.Frame:Destroy()
end

function t._Update(arg25) -- line: 101
    -- upvalues:
    --  [1] udim2 (copy)

    local Milestones_1 = arg25.Frame.Container.Milestones
    local New = UDim2.new
    local v7 = if arg25.Frame.Container.Description.Text == "" then 0 else 0.01 + arg25.Frame.Container.Description.Size.Y.Scale or 0
    Milestones_1.Position = New(0, 0, 0.1 + v7, 0)
    arg25.Frame.Container.Size = UDim2.new(1, 0, 1 * arg25._scale, 0)
    arg25.Frame.Size = UDim2.new(
        1,
        0,
        (arg25.Frame.Container.Milestones.Position.Y.Scale + 0.075 * arg25._num_milestones + 0.025) * arg25._scale,
        0
    )
    local v8 = true

    for _, val in pairs(arg25._milestones) do
        local v9, v10, v11, v12 = table.unpack(val)
        v11 = arg25._requires_previous_milestone_completed

        if v11 then
            v11 = not v8
        end

        local v13 = v10 <= arg25._progress
        v9.Contract.Image = arg25._contract_icon_image or "rbxassetid://17619445009"
        local v14 = arg25._contract_icon_size
        local Contract = v9.Contract

        if not v14 then
            v14 = udim2
        end

        Contract.Size = v14
        v9.Progress.Bar.Visible = not v11
        v9.Locked.Visible = v11
        v9.Completed.Visible = not v11 and v13
        local v15 = not v11 and not v13
        v9.Contract.Visible = v15
        v9.Progress.Bar.Size = UDim2.new(math.clamp(arg25._progress / v10, 0, 1), 0, 1, 2)
        local Bar_1 = v9.Progress.Bar
        local v16 = v13 and Color3.fromRGB(100, 255, 50) or Color3.fromRGB(0, 190, 255)
        Bar_1.BackgroundColor3 = v16
        v16 = not v11 and not v13
        v9.Goal.Visible = v16
        v9.Goal.Text = v12(arg25._progress) .. " / " .. v12(v10)
        v8 = v13
    end
end

function t._Setup(arg26) -- line: 128
    -- upvalues:
    --  [1] Utility_m (copy)

    function arg26._default_tostring_function(...) -- line: 129
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:PrettyNumber(...)
    end
end

function t._Init(arg27) -- line: 134
    arg27:_Setup()
    arg27:SetImage("")
    arg27:SetTitle("")
    arg27:SetDescription("")
    arg27:SetScale(1)
    arg27:SetProgress(0)
    arg27:SetRequiresPreviousMilestoneCompleted(true)
end

return t
