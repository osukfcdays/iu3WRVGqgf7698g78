local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PermissionsLibrary_m = require(ReplicatedStorage.Modules.PermissionsLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(_, _) -- line: 12
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.List = t_1.PromptFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._description_template = t_1.Container:WaitForChild("Description")
    t_1._title_template = t_1.Container:WaitForChild("Title")
    t_1:_Init()

    return t_1
end

function t._Update(arg3) -- line: 38
    arg3.List.CanvasSize = UDim2.new(0, 0, 0, arg3.Layout.AbsoluteContentSize.Y)
end

function t._Setup(arg4) -- line: 42
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)
    --  [2] Utility_m (copy)

    arg4._description_template.Parent = nil
    arg4._title_template.Parent = nil
    local t_2 = {}

    for key, _ in pairs(PermissionsLibrary_m.Roles) do
        table.insert(t_2, key)
    end

    table.sort(t_2, function(arg5, arg6) -- line: 52
        -- upvalues:
        --  [1] PermissionsLibrary_m (ref)
        --  [2] Utility_m (ref)

        local TeamValue = PermissionsLibrary_m.Teams[PermissionsLibrary_m.Roles[arg5].TeamName].TeamValue
        local TeamValue_1 = PermissionsLibrary_m.Teams[PermissionsLibrary_m.Roles[arg6].TeamName].TeamValue

        if TeamValue ~= TeamValue_1 then
            return TeamValue > TeamValue_1
        end

        local RoleValue = PermissionsLibrary_m.Roles[arg5].RoleValue
        local RoleValue_1 = PermissionsLibrary_m.Roles[arg6].RoleValue

        if RoleValue ~= RoleValue_1 then
            return RoleValue_1 < RoleValue
        end

        return Utility_m:StringLessThan(
            PermissionsLibrary_m.Roles[arg5].DisplayName,
            PermissionsLibrary_m.Roles[arg6].DisplayName
        )
    end)
    local v6 = tick() + 3
    local v7 = 0

    for _, val_1 in pairs(t_2) do
        v7 += 1
        local v8 = PermissionsLibrary_m.Roles[val_1]
        local v9 = arg4._title_template:Clone()
        v9.Text = v8.DisplayName
        v9.TextColor3 = v8.Color
        v9.LayoutOrder = v7
        v9.Parent = arg4.Container

        for _, val_2 in pairs(v8.PermissionNames) do
            v7 += 1
            local v10 = PermissionsLibrary_m.Permissions[val_2]
            local v11 = arg4._description_template:Clone()
            v11.Container.Guide.Text = " \226\128\162 " .. v10.DisplayName .. " \226\128\148 " .. v10.Description
            v11.Description.Text = v11.Container.Guide.Text
            v11.LayoutOrder = v7
            v11.Parent = arg4.Container

            local function update() -- line: 93
                -- upvalues:
                --  [1] v11 (copy)
                --  [2] v6 (copy)

                local v12 = math.ceil(
                    v11.Container.Guide.TextBounds.X / v11.Description.AbsoluteSize.X
                )

                if v12 > 5 and tick() < v6 then
                    v12 = 1
                end

                v11.Size = UDim2.new(0.975, 0, v12 * 0.04, 0)
            end

            v11.Container.Guide:GetPropertyChangedSignal("TextBounds"):Connect(update)
            v11.Description:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
            update()
        end
    end
end

function t._Init(arg7) -- line: 110
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg7.CloseButton.MouseButton1Click:Connect(function() -- line: 111
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:CloseRequest()
    end)
    arg7.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 115
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end)
    arg7:_Setup()
    arg7:_Update()
    ButtonEffect_m:Add(arg7.CloseButton)
end

return t
