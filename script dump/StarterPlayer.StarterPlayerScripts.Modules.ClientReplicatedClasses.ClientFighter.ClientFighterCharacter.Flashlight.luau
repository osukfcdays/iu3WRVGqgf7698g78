local t = {}
t.__index = t

function t.new(arg1) -- line: 4
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighterCharacter = arg1
    t_1._destroyed = false
    t_1._part = nil
    t_1:_Init()

    return t_1
end

function t.Update(arg2, _, arg4) -- line: 21
    if not arg2._part then
        return
    end

    local Part = arg2._part
    Part.CFrame = if not arg4.IsActuallyFirstPerson then if not arg2.ClientFighterCharacter.Head then if not arg2.ClientFighterCharacter.RootPart then arg2._part.CFrame else arg2.ClientFighterCharacter.RootPart.CFrame else arg2.ClientFighterCharacter.Head.CFrame else workspace.CurrentCamera.CFrame
end

function t.Destroy(arg5) -- line: 32
    arg5._destroyed = true

    if arg5._part then
        arg5._part:Destroy()
    end
end

function t._Verify(arg6) -- line: 44
    if arg6._destroyed or not arg6.ClientFighterCharacter:IsInWorld() then
        return
    end

    local v2 = arg6.ClientFighterCharacter:Get("CameraFlashlightEnabled")

    if v2 and not arg6._part then
        arg6._part = Instance.new("Part")
        arg6._part.Size = Vector3.new(0, 0, 0)
        arg6._part.Transparency = 1
        arg6._part.CanCollide = false
        arg6._part.CanTouch = false
        arg6._part.CanQuery = false
        arg6._part.Anchored = true
        arg6._part.Name = "CameraFlashlight"
        arg6._part.Parent = workspace
        local SpotLight = Instance.new("SpotLight")
        SpotLight.Range = 48
        SpotLight.Brightness = 3
        SpotLight.Shadows = true
        SpotLight.Parent = arg6._part

        return
    end

    if not v2 and arg6._part then
        arg6._part:Destroy()
        arg6._part = nil
    end
end

function t._Init(arg7) -- line: 73
    arg7.ClientFighterCharacter:GetDataChangedSignal("CameraFlashlightEnabled"):Connect(function() -- line: 74
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Verify()
    end)
    arg7.ClientFighterCharacter.EnteredWorld:Connect(function() -- line: 78
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Verify()
    end)
    arg7:_Verify()
end

return t
