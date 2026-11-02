local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighter = arg1
    t_1._quick_attack_down_starts = {}
    t_1._is_quick_attacking = false
    t_1._keep_quick_attack = false
    t_1._quick_attack_hash = 0
    t_1._quick_attack_cooldown = 0
    t_1._quick_attack_original_item = nil
    t_1._quick_attack_target_item = nil
    t_1._quick_attack_inputs = nil
    t_1._quick_attack_keep_window = 0
    t_1._dont_skip_equip_animation_from_quick_attacks = 0
    t_1:_Init()

    return t_1
end

function t.IsEquippingLocked(arg2, arg3) -- line: 41
    local v1 = arg2._quick_attack_target_item

    if v1 then
        v1 = if arg2._quick_attack_target_item:Get("ObjectID") == arg3 then false else true
    end

    return v1
end

function t.GetQuickAttackIndex(arg4, arg5) -- line: 45
    -- upvalues:
    --  [1] ItemLibrary_m (copy)

    return arg4.ClientFighter:Get("OverrideQuickAttacks") and arg4.ClientFighter:Get(
        "OverrideQuickAttacks"
    )[arg5] or ItemLibrary_m.QUICK_ATTACK_ITEM_INDEX_DEFAULTS[arg5]
end

function t.ShouldSkipEquipAnimation(_, arg7) -- line: 49
    return arg7:Get("QuickAttackQueued") or arg7:Get("SkipEquipAnimation")
end

function t.InputDown(arg8, arg9) -- line: 53
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] ItemLibrary_m (copy)

    arg8._quick_attack_down_starts[arg9] = tick()

    if arg8.ClientFighter:AreItemsLocked() or tick() < arg8._quick_attack_cooldown then
        return
    end

    local v4 = arg8:GetQuickAttackIndex(arg9)
    local v5 = arg8.ClientFighter.Items[v4]
    local EquippedItem = arg8.ClientFighter.EquippedItem

    if not EquippedItem or not v5 then
        return
    end

    local v6 = PlayerDataController_m:GetSetting("Easy Quick Attack")

    if v6 then
        v6 = v5:CanEasyQuickAttack()

        if v6 then
            v6 = if v5.Info.QuickAttackInputsEasy == nil then false else true
        end
    end

    local v7

    if v6 then
        v7 = v5.Info.QuickAttackInputsEasy

        if not v7 then
            v7 = v5:CanQuickAttack() and v5.Info.QuickAttackInputs or nil
        end
    else
        v7 = v5:CanQuickAttack() and v5.Info.QuickAttackInputs or nil
    end

    if EquippedItem == v5 or not v7 then
        v5:PlayEquipFailedEffect()

        return
    end

    arg8._is_quick_attacking = true
    arg8._keep_quick_attack = PlayerDataController_m:GetSetting("Keep Quick Attack Enabled")
    arg8._quick_attack_hash += 1
    local now = tick()
    local v8 = if arg8._keep_quick_attack then PlayerDataController_m:GetSetting(
        "Keep Quick Attack Window"
    ) else math.huge
    arg8._quick_attack_keep_window = now + v8
    arg8._quick_attack_cooldown = math.huge
    arg8._quick_attack_original_item = EquippedItem
    arg8._quick_attack_target_item = v5
    arg8._quick_attack_inputs = v7
    ReplicatedStorage.Remotes.Replication.Fighter.RegisterQuickAttack:FireServer(arg9, v6)
    v5:SetReplicate("QuickAttackQueued", true)
    arg8.ClientFighter:EquipItem(table.find(arg8.ClientFighter.Items, v5), true)
    task.defer(function() -- line: 92
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] ItemLibrary_m (ref)

        local QuickAttackHash = arg8._quick_attack_hash
        wait(ItemLibrary_m.QUICK_ATTACK_TIMEOUT)

        if QuickAttackHash == arg8._quick_attack_hash then
            arg8:_Cancel(false)
        end
    end)
end

function t.InputUp(arg10, arg11) -- line: 103
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    if not arg10._quick_attack_down_starts[arg11] then
        return
    end

    local v9 = if PlayerDataController_m:GetSetting("Keep Quick Attack Enabled") then PlayerDataController_m:GetSetting(
        "Keep Quick Attack Window"
    ) else math.huge

    if
        (if not (v9 > tick() - arg10._quick_attack_down_starts[arg11]) then false else true)
        and tick() < arg10._quick_attack_keep_window
    then
        arg10._keep_quick_attack = false
    end
end

function t.OnReEquip(arg12) -- line: 116
    for _, val in pairs(arg12.ClientFighter.Items) do
        val:SetReplicate("SkipEquipAnimation", nil)
    end

    arg12._dont_skip_equip_animation_from_quick_attacks = tick() + 1
end

function t.Clear(arg13) -- line: 124
    arg13._is_quick_attacking = false
    arg13._keep_quick_attack = false
    arg13._quick_attack_hash += 1
    arg13._quick_attack_cooldown = tick() + 0
    arg13._quick_attack_original_item = nil
    arg13._quick_attack_target_item = nil
    arg13._quick_attack_inputs = nil
end

function t.Destroy(_) -- line: 134
end

function t._Cancel(arg15, arg16) -- line: 142
    local v11 = if arg16 == nil then arg15._keep_quick_attack else arg16

    if not arg15._quick_attack_original_item then
        return
    end

    if arg15._quick_attack_target_item then
        arg15._quick_attack_target_item:SetReplicate("QuickAttackQueued", nil)
    end

    if not v11 then
        if tick() > arg15._dont_skip_equip_animation_from_quick_attacks then
            arg15._quick_attack_original_item:SetReplicate("SkipEquipAnimation", true)
        end

        arg15.ClientFighter:EquipItem(
            table.find(arg15.ClientFighter.Items, arg15._quick_attack_original_item),
            true
        )
    end

    arg15:Clear()
end

function t._TryQuickAttackInputs(arg17, arg18) -- line: 164
    if not arg17._quick_attack_inputs then
        return false
    end

    for _, val_1 in pairs(arg17._quick_attack_inputs) do
        if not arg18:Input(val_1) then
            return false
        end

        wait(0.05)
    end

    return true
end

function t._OnEquip(arg19, arg20) -- line: 180
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] RunService (copy)

    if not arg20 then
        return
    end

    if arg20:Get("SkipEquipAnimation") then
        arg20:SetReplicate("SkipEquipAnimation", nil)
    end

    if not arg20:Get("QuickAttackQueued") or not arg19.ClientFighter.IsLocalPlayer then
        return
    end

    task.defer(function() -- line: 193
        -- upvalues:
        --  [1] arg19 (copy)
        --  [2] BetterDebris_m (ref)
        --  [3] ItemLibrary_m (ref)
        --  [4] arg20 (copy)
        --  [5] RunService (ref)

        local QuickAttackHash_1 = arg19._quick_attack_hash
        local v12 = false
        local BindableEvent = Instance.new("BindableEvent")
        BetterDebris_m:AddItem(BindableEvent, ItemLibrary_m.QUICK_ATTACK_TIMEOUT)
        task.spawn(function() -- line: 199
            -- upvalues:
            --  [1] arg19 (ref)
            --  [2] arg20 (ref)
            --  [3] QuickAttackHash_1 (copy)
            --  [4] v12 (ref)
            --  [5] BindableEvent (copy)

            local v13 = arg19._quick_attack_inputs

            if v13 then
                v13 = arg19._quick_attack_inputs[#arg19._quick_attack_inputs]
            end

            if v13 then
                repeat
                    local v14 = arg20.ServerInputWorkDone:Wait()

                    if arg19._quick_attack_hash ~= QuickAttackHash_1 then
                        return
                    end
                until v14 == v13
            end

            v12 = true
            BindableEvent:Fire()
            task.defer(BindableEvent.Destroy, BindableEvent)
        end)
        local v15 = arg19:_TryQuickAttackInputs(arg20)

        if arg19._quick_attack_hash ~= QuickAttackHash_1 then
            return
        end

        if not v15 then
            arg19:_Cancel(false)
        else
            if not v12 then
                BindableEvent.Event:Wait()
            end

            while true do
                if not arg19._keep_quick_attack then
                    break
                end

                if not (tick() < arg19._quick_attack_keep_window) then
                    break
                end

                RunService.Heartbeat:Wait()

                if arg19._quick_attack_hash == QuickAttackHash_1 then
                    continue
                end

                return
            end

            arg19:_Cancel(nil)
        end
    end)
end

function t._Init(arg21) -- line: 250
    arg21.ClientFighter.EquippedItemChanged:Connect(function(arg22) -- line: 251
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_OnEquip(arg22)
    end)
end

return t
