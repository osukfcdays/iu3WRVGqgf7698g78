local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ContractsLibrary_m = require(ReplicatedStorage.Modules.ContractsLibrary)
local _ = require(ReplicatedStorage.Modules.ItemLibrary)
local ContractSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("BaseContractSlot"):WaitForChild(
        "ContractSlot"
    )
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local ContractDivider = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ContractDivider"
)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 15
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._weapon_name = nil
    t_1._contract_slots = {}
    t_1:_Init()

    return t_1
end

function t.SetWeapon(arg1, arg2) -- line: 35
    arg1._weapon_name = arg2
    arg1:_Update()
end

function t._Update(arg3) -- line: 44
    -- upvalues:
    --  [1] ContractsLibrary_m (copy)
    --  [2] ContractDivider (copy)
    --  [3] ContractSlot_m (copy)

    for _, val in pairs(arg3._contract_slots) do
        val:Destroy()
    end

    arg3._contract_slots = {}

    if not arg3._weapon_name then
        return
    end

    local v5 = 0

    for key_1, val_1 in pairs(ContractsLibrary_m:GetWeaponContracts(arg3._weapon_name)) do
        if key_1 > 1 then
            local v7 = ContractDivider:Clone()
            v7.LayoutOrder = v5
            v7.Parent = arg3.Container
            table.insert(arg3._contract_slots, v7)
            v5 += 1
        end

        local v8 = ContractSlot_m.new("WeaponStatistics", val_1)
        v8.Frame.LayoutOrder = v5
        v8.Frame.Parent = arg3.Container
        table.insert(arg3._contract_slots, v8)
        v5 += 1
    end
end

function t._Init(arg4) -- line: 74
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg4.CloseButton.MouseButton1Click:Connect(function() -- line: 75
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:CloseRequest()
    end)
    arg4.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 79
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.List.CanvasSize = UDim2.new(0, 0, 0, arg4.Layout.AbsoluteContentSize.Y)
    end)
    arg4:_Update()
    ButtonEffect_m:Add(arg4.CloseButton)
end

return t._new()
