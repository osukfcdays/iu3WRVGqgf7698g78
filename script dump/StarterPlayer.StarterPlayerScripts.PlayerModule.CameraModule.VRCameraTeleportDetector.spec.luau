local JestGlobals_m = require(game:GetService("CorePackages").Packages.Dev.JestGlobals)
local Describe = JestGlobals_m.describe
local Expect = JestGlobals_m.expect
local It = JestGlobals_m.it
local VRCameraTeleportDetector_m = require(script.Parent.VRCameraTeleportDetector)
local ShouldRecenter = VRCameraTeleportDetector_m.shouldRecenter
local JUMPSTUDS = VRCameraTeleportDetector_m.JUMP_STUDS
local SETTLEDSTUDS = VRCameraTeleportDetector_m.SETTLED_STUDS
local DEBOUNCESECONDS = VRCameraTeleportDetector_m.DEBOUNCE_SECONDS
Describe("VRCameraTeleportDetector.shouldRecenter", function() -- line: 14
    -- upvalues:
    --  [1] It (copy)
    --  [2] Expect (copy)
    --  [3] ShouldRecenter (copy)
    --  [4] JUMPSTUDS (copy)
    --  [5] SETTLEDSTUDS (copy)
    --  [6] DEBOUNCESECONDS (copy)

    It("fires on a discrete jump from rest (no prior step, never recentered)", function() -- line: 15
        -- upvalues:
        --  [1] Expect (ref)
        --  [2] ShouldRecenter (ref)
        --  [3] JUMPSTUDS (ref)

        Expect(ShouldRecenter(nil, JUMPSTUDS + 10, nil, 100)).toBe(true)
    end)
    It("fires on a discrete jump preceded by a near-still frame", function() -- line: 19
        -- upvalues:
        --  [1] Expect (ref)
        --  [2] ShouldRecenter (ref)
        --  [3] SETTLEDSTUDS (ref)
        --  [4] JUMPSTUDS (ref)

        Expect(ShouldRecenter(SETTLEDSTUDS - 0.5, JUMPSTUDS + 10, nil, 100)).toBe(true)
    end)
    It("does not fire for sub-threshold motion", function() -- line: 23
        -- upvalues:
        --  [1] Expect (ref)
        --  [2] ShouldRecenter (ref)
        --  [3] JUMPSTUDS (ref)

        Expect(ShouldRecenter(0, JUMPSTUDS - 0.1, nil, 100)).toBe(false)
        Expect(ShouldRecenter(0, 0, nil, 100)).toBe(false)
    end)
    It("does not fire when the previous frame was already moving (continuous motion)", function() -- line: 28
        -- upvalues:
        --  [1] Expect (ref)
        --  [2] ShouldRecenter (ref)
        --  [3] SETTLEDSTUDS (ref)
        --  [4] JUMPSTUDS (ref)

        Expect(ShouldRecenter(SETTLEDSTUDS + 0.1, JUMPSTUDS + 10, nil, 100)).toBe(false)
    end)
    It("does not fire within the debounce interval", function() -- line: 33
        -- upvalues:
        --  [1] Expect (ref)
        --  [2] ShouldRecenter (ref)
        --  [3] JUMPSTUDS (ref)
        --  [4] DEBOUNCESECONDS (ref)

        Expect(ShouldRecenter(nil, JUMPSTUDS + 10, 100, 100 + DEBOUNCESECONDS - 0.01)).toBe(false)
    end)
    It("fires again once the debounce interval has elapsed", function() -- line: 38
        -- upvalues:
        --  [1] Expect (ref)
        --  [2] ShouldRecenter (ref)
        --  [3] JUMPSTUDS (ref)
        --  [4] DEBOUNCESECONDS (ref)

        Expect(ShouldRecenter(nil, JUMPSTUDS + 10, 100, 100 + DEBOUNCESECONDS + 0.01)).toBe(true)
    end)
    It("does not retrigger every frame under continuous per-frame CFrame writes (oscillation guard)", function() -- line: 43
        -- upvalues:
        --  [1] JUMPSTUDS (ref)
        --  [2] ShouldRecenter (ref)
        --  [3] Expect (ref)

        local v8 = 0
        local v9 = nil
        local v10 = nil
        local v11 = 0
        local v12 = JUMPSTUDS + 10

        for _ = 1, 120 do
            if ShouldRecenter(v9, v12, v10, v8) then
                v11 += 1
                v10 = v8
            end

            v9 = v12
            v8 += 0.016666666666666666
        end

        Expect(v11).toBe(1)
    end)
end)
