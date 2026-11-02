local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local MatchmakingCountdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "MatchmakingCountdown"
    )
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "MobileInputs"
    )
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "Teleporting"
    )
)
local _ = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "PlayerList"
    )
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local PlayerInteractionGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PlayerInteractionGui"
)
local t = {}
t.__index = t

function t._new() -- line: 24
    -- upvalues:
    --  [1] t (copy)
    --  [2] PlayerInteractionGui (copy)

    local t_1 = setmetatable({}, t)
    t_1.LocalFighter = nil
    t_1._connections = {}
    t_1._changed_connections = {}
    t_1._bbg = PlayerInteractionGui:Clone()
    t_1._highlight = nil
    t_1._next_whitelist = 0
    t_1._whitelist = {}
    t_1._disabled_until = 0
    t_1._hash = 0
    t_1:_Init()

    return t_1
end

function t._SetAdornee(arg1, arg2) -- line: 53
    -- upvalues:
    --  [1] Players (copy)

    arg1._bbg.Adornee = arg2 or nil
    local Bbg = arg1._bbg
    Bbg.Parent = if not arg2 then nil else Players.LocalPlayer.PlayerGui
end

function t._GetWhitelist(arg3) -- line: 58
    -- upvalues:
    --  [1] FighterController_m (copy)

    if tick() > arg3._next_whitelist then
        arg3._next_whitelist = tick() + 3
        arg3._whitelist = FighterController_m:GetFighterModels()
    end

    return arg3._whitelist
end

function t._ClearChangedConnections(arg4) -- line: 67
    for _, val in pairs(arg4._changed_connections) do
        val:Disconnect()
    end

    arg4._changed_connections = {}
end

function t._Verify(arg5) -- line: 75
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] SpectateController_m (copy)
    --  [3] MobileInputs_m (copy)
    --  [4] Teleporting_m (copy)
    --  [5] MatchmakingCountdown_m (copy)
    --  [6] GuiService (copy)
    --  [7] Players (copy)
    --  [8] UILibrary_m (copy)
    --  [9] Utility_m (copy)
    --  [10] UserInputService (copy)

    for _, val_1 in pairs(arg5._connections) do
        val_1:Disconnect()
    end

    arg5._connections = {}

    if arg5._highlight then
        arg5._highlight:Destroy()
        arg5._highlight = nil
    end

    arg5:_SetAdornee(nil)
    arg5:_ClearChangedConnections()
    arg5._hash += 1
    local Hash = arg5._hash

    if
        not arg5.LocalFighter
        or arg5.LocalFighter:Get("IsInDuel")
        or arg5.LocalFighter:Get("IsInShootingRange")
        or (if not arg5.LocalFighter.Entity then tick() < arg5._disabled_until else arg5.LocalFighter.Entity:Get(
            "IsGrabbingSnowball"
        ) or tick() < arg5._disabled_until)
        or Pages_m.PageSystem.CurrentPage
        or SpectateController_m.CurrentDuelSubject
        or MobileInputs_m.EditorEnabled
        or Teleporting_m.Enabled
        or MatchmakingCountdown_m:IsVisible()
        or GuiService.MenuIsOpen
    then
        return
    end

    arg5._highlight = Instance.new("Highlight")
    arg5._highlight.Name = "PlayerInteraction"
    arg5._highlight.FillColor = Color3.fromRGB(255, 255, 255)
    arg5._highlight.Parent = Players.LocalPlayer.PlayerGui

    local function get_hovered_player_object() -- line: 106
        -- upvalues:
        --  [1] UILibrary_m (ref)
        --  [2] Utility_m (ref)
        --  [3] arg5 (copy)
        --  [4] Players (ref)

        local mouseLocation = UILibrary_m:GetMouseLocation()
        local ray = workspace.CurrentCamera:ScreenPointToRay(mouseLocation.X, mouseLocation.Y, 0)
        local v8 = ray.Origin + ray.Direction * 100
        local v9 = Utility_m
        local Origin = ray.Origin
        local v10 = arg5:_GetWhitelist()
        local v11 = Utility_m:GetCharacterModel(
            v9:Raycast(
                Origin,
                v8,
                100,
                v10,
                Enum.RaycastFilterType.Include
            ).Instance
        )
        local v12 = v11

        if v12 then
            v12 = Players:GetPlayerFromCharacter(v11)
        end

        if
            v11
            and v11:FindFirstChild("HumanoidRootPart")
            and (workspace.CurrentCamera.CFrame.Position - v11.HumanoidRootPart.Position).Magnitude < 5
        then
            return
        end

        return v12, v11
    end

    local v13 = nil
    local v14 = 0

    local _ = function() --[[ update_visuals ]] -- line: 123
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] Hash (copy)
        --  [3] v14 (ref)

        if arg5._hash ~= Hash then
            return
        end

        local v15 = tick() - v14 < 0.25 and true
        arg5._highlight.FillTransparency = if not v15 then 0.75 else 0.5
        arg5._highlight.OutlineTransparency = if not v15 then 0.5 else 0
        arg5._bbg.Container.Title.Text = if not v15 then "Double tap to view profile" else "Tap again to view profile"
    end

    local v17

    if arg5._hash == Hash then
        v17 = tick() - v14 < 0.25 and true
        arg5._highlight.FillTransparency = if not v17 then 0.75 else 0.5
        arg5._highlight.OutlineTransparency = if not v17 then 0.5 else 0
        arg5._bbg.Container.Title.Text = if not v17 then "Double tap to view profile" else "Tap again to view profile"
    end

    function v17(arg6) --[[ set_start_click ]] -- line: 142
        -- upvalues:
        --  [1] v14 (ref)
        --  [2] arg5 (copy)
        --  [3] Hash (copy)

        v14 = arg6

        if arg5._hash == Hash then
            local v19 = tick() - v14 < 0.25 and true
            arg5._highlight.FillTransparency = if not v19 then 0.75 else 0.5
            arg5._highlight.OutlineTransparency = if not v19 then 0.5 else 0
            arg5._bbg.Container.Title.Text = if not v19 then "Double tap to view profile" else "Tap again to view profile"
        end

        task.delay(0.25, function() -- line: 146
            -- upvalues:
            --  [1] arg5 (ref)
            --  [2] Hash (ref)
            --  [3] v14 (ref)

            if arg5._hash ~= Hash then
                return
            end

            local v21 = tick() - v14 < 0.25 and true
            arg5._highlight.FillTransparency = if not v21 then 0.75 else 0.5
            arg5._highlight.OutlineTransparency = if not v21 then 0.5 else 0
            arg5._bbg.Container.Title.Text = if not v21 then "Double tap to view profile" else "Tap again to view profile"
        end)
    end

    table.insert(arg5._connections, UserInputService.InputBegan:Connect(function(input: InputObject) -- line: 151
        -- upvalues:
        --  [1] v14 (ref)
        --  [2] v13 (ref)
        --  [3] arg5 (copy)
        --  [4] Hash (copy)
        --  [5] get_hovered_player_object (copy)

        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
            or input.KeyCode == Enum.KeyCode.ButtonX
        then
            if tick() - v14 > 0.25 then
                v13 = nil
            end

            v14 = tick()

            if arg5._hash == Hash then
                local v23 = tick() - v14 < 0.25 and true
                arg5._highlight.FillTransparency = if not v23 then 0.75 else 0.5
                arg5._highlight.OutlineTransparency = if not v23 then 0.5 else 0
                arg5._bbg.Container.Title.Text = if not v23 then "Double tap to view profile" else "Tap again to view profile"
            end

            task.delay(0.25, function() -- line: 146
                -- upvalues:
                --  [1] arg5 (ref)
                --  [2] Hash (ref)
                --  [3] v14 (ref)

                if arg5._hash ~= Hash then
                    return
                end

                local v25 = tick() - v14 < 0.25 and true
                arg5._highlight.FillTransparency = if not v25 then 0.75 else 0.5
                arg5._highlight.OutlineTransparency = if not v25 then 0.5 else 0
                arg5._bbg.Container.Title.Text = if not v25 then "Double tap to view profile" else "Tap again to view profile"
            end)

            if input.UserInputType == Enum.UserInputType.Touch then
                arg5:_ClearChangedConnections()
                table.insert(arg5._changed_connections, input:GetPropertyChangedSignal("Position"):Connect(
                    function() -- line: 162
                        -- upvalues:
                        --  [1] get_hovered_player_object (ref)
                        --  [2] arg5 (ref)

                        local _, v28 = get_hovered_player_object()
                        arg5._highlight.Adornee = v28
                        local v29 = v28
                        local v30 = arg5

                        if v29 then
                            v29 = v28:FindFirstChild("HumanoidRootPart")
                        end

                        v30:_SetAdornee(v29)
                    end
                ))
                table.insert(arg5._changed_connections, input:GetPropertyChangedSignal(
                    "UserInputState"
                ):Connect(function() -- line: 169
                    -- upvalues:
                    --  [1] input (copy)
                    --  [2] arg5 (ref)

                    if input.UserInputState == Enum.UserInputState.End then
                        arg5:_ClearChangedConnections()
                    end
                end))
            end
        end
    end))
    table.insert(arg5._connections, UserInputService.InputEnded:Connect(function(
        input_1: InputObject
    ) -- line: 178
        -- upvalues:
        --  [1] v14 (ref)
        --  [2] get_hovered_player_object (copy)
        --  [3] v13 (ref)
        --  [4] Pages_m (ref)

        if
            input_1.UserInputType == Enum.UserInputType.MouseButton1
            or input_1.UserInputType == Enum.UserInputType.Touch
            or input_1.KeyCode == Enum.KeyCode.ButtonX
        then
            if tick() - v14 > 0.25 then
                return
            end

            local v31 = get_hovered_player_object()

            if not v31 then
                return
            end

            if v13 == v31 then
                Pages_m.PageSystem:OpenPage("ViewProfile")
                Pages_m.PageSystem:WaitForPage("ViewProfile"):Fetch(v31)

                return
            end

            v13 = v31
        end
    end))

    local function mouse_moved() -- line: 199
        -- upvalues:
        --  [1] get_hovered_player_object (copy)
        --  [2] arg5 (copy)

        local _, v33 = get_hovered_player_object()
        arg5._highlight.Adornee = v33
        local v34 = v33
        local v35 = arg5

        if v34 then
            v34 = v33:FindFirstChild("HumanoidRootPart")
        end

        v35:_SetAdornee(v34)
    end

    table.insert(
        arg5._connections,
        workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(mouse_moved)
    )
    table.insert(arg5._connections, UserInputService.InputChanged:Connect(function(
        input_2: InputObject
    ) -- line: 208
        -- upvalues:
        --  [1] get_hovered_player_object (copy)
        --  [2] arg5 (copy)

        if input_2.UserInputType == Enum.UserInputType.MouseMovement then
            local _, v37 = get_hovered_player_object()
            arg5._highlight.Adornee = v37
            local v38 = v37
            local v39 = arg5

            if v38 then
                v38 = v37:FindFirstChild("HumanoidRootPart")
            end

            v39:_SetAdornee(v38)
        end
    end))
end

function t._HookLocalFighter(arg10) -- line: 215
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg10.LocalFighter = FighterController_m:WaitForLocalFighter()
    arg10.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 218
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Verify()
    end)
    arg10.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 222
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Verify()
    end)

    local function entity_added(arg11) -- line: 226
        -- upvalues:
        --  [1] arg10 (copy)

        arg11:GetDataChangedSignal("IsGrabbingSnowball"):Connect(function() -- line: 227
            -- upvalues:
            --  [1] arg10 (ref)

            arg10._disabled_until = tick() + 2
            task.delay(2, arg10._Verify, arg10)
            arg10:_Verify()
        end)
        arg10:_Verify()
    end

    arg10.LocalFighter.EntityAdded:Connect(entity_added)

    if arg10.LocalFighter.Entity then
        task.defer(entity_added, arg10.LocalFighter.Entity)
    end

    arg10:_Verify()
end

function t._Setup(arg12) -- line: 245
    -- upvalues:
    --  [1] Players (copy)

    arg12._bbg.Name = "PlayerInteraction"
    arg12._bbg.Parent = Players.LocalPlayer.PlayerGui
end

function t._Init(arg13) -- line: 250
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] SpectateController_m (copy)
    --  [3] Teleporting_m (copy)
    --  [4] MobileInputs_m (copy)
    --  [5] MatchmakingCountdown_m (copy)
    --  [6] GuiService (copy)

    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 251
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Verify()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 255
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Verify()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 259
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Verify()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 263
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Verify()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 267
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Verify()
    end)
    MatchmakingCountdown_m.VisibilityChanged:Connect(function() -- line: 271
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Verify()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 275
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_Verify()
    end)
    arg13:_Setup()
    task.defer(arg13._Verify, arg13)
    task.spawn(arg13._HookLocalFighter, arg13)
end

return t._new()
