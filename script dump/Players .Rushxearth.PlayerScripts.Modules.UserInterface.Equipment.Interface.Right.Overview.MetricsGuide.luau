local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = require(ReplicatedStorage.Modules.AnimationLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)

return {
    { "Equip Cooldown", { "EquipCooldown" }, "Time" },
    {
        "Move Speed",
        { "WalkSpeedMultiplier" },
        "Custom",
        function(_, arg2) -- line: 10
            if arg2 == 1 then
                return "Normal"
            end

            return (if not (arg2 > 1) then "" else "+") .. math.floor((arg2 - 1) * 100 + 0.5) .. "%"
        end
    },
    { "Double Jumps", { "MaxDoubleJumps" } },
    {
        "Damage",
        { "ShootDamage", "BurnDamage", "AttackDamage", "Damage", "DirectHitDamage" },
        "Custom",
        function(arg3, arg4) -- line: 15
            -- upvalues:
            --  [1] ItemLibrary_m (copy)

            if arg4 == 0 then
                return
            end

            local v2 = ItemLibrary_m.Items[arg3]
            local v3 = v2.ShootPellets and v2.ShootPellets > 1 and string.format(
                "%.1f\195\151%s",
                arg4 / v2.ShootPellets,
                v2.ShootPellets
            ) or arg4
            local v4 = if not v2.RaycastDamageDropoffMultiplier then "" else v2.ShootPellets and v2.ShootPellets > 1 and string.format(
                "%.1f\195\151%s",
                arg4 / v2.ShootPellets * v2.RaycastDamageDropoffMultiplier,
                v2.ShootPellets
            ) or string.format("%.1f", arg4 * v2.RaycastDamageDropoffMultiplier) or ""

            return v3 .. (v4 == "" and v4 or " \226\134\146 " .. v4)
        end
    },
    {
        "Damage Dropoff Range",
        { "RaycastDamageDropoffStartDistance" },
        "Custom",
        function(arg5, arg6) -- line: 26
            -- upvalues:
            --  [1] ItemLibrary_m (copy)

            return arg6 .. "<font weight=\"600\" size=\"6\">studs</font> \226\134\146 " .. ItemLibrary_m.Items[arg5].RaycastDamageDropoffEndDistance .. "<font weight=\"600\" size=\"6\">studs</font>"
        end
    },
    {
        "Splash Radius",
        { "ShootExplosionRadius" },
        "Custom",
        function(_, arg8) -- line: 29
            if arg8 > 0 then
                return arg8
            end
        end
    },
    { "Damage Per Second", { "DamagePerSecond" } },
    { "Afterburn Damage", { "AfterburnDamage" } },
    { "Splash Damage", { "SplashDamage" } },
    { "Explosion Damage", { "ExplosionDamage" } },
    { "Critical Damage", { "CriticalExplosionDamage" } },
    { "Explosion Radius", { "ExplosionRadius" } },
    { "Cooldown", { "ShootCooldown", "AttackCooldown", "Cooldown" }, "Time" },
    {
        "Spread",
        { "ShootSpread" },
        "Custom",
        function(_, arg10) -- line: 41
            if arg10 > 0 then
                return string.format("%.1f\194\176", arg10)
            end
        end
    },
    {
        "Aim Spread",
        { "AimSpreadMultiplier" },
        "Custom",
        function(arg11, arg12) -- line: 46
            -- upvalues:
            --  [1] ItemLibrary_m (copy)

            if arg12 > 0 then
                return string.format("%.1f\194\176", ItemLibrary_m.Items[arg11].ShootSpread * arg12)
            end
        end
    },
    {
        "Dynamic Spread",
        { "ShootSpreadPerVelocityUnit" },
        "Custom",
        function(_, arg14) -- line: 51
            if arg14 > 0 then
                return string.format("%0.2f\194\176", arg14) .. "/studs/s"
            end
        end
    },
    {
        "Recoil",
        { "ShootCameraDisplacementRecoil" },
        "Custom",
        function(_, arg16) -- line: 56
            if arg16.Magnitude > 0 then
                return string.format("%.0f%%", arg16.X / 25 * 100)
            end
        end
    },
    {
        "Aim Recoil",
        { "ShootCameraDisplacementRecoilWhileAiming" },
        "Custom",
        function(_, arg18) -- line: 61
            if arg18.Magnitude > 0 then
                return string.format("%.0f%%", arg18.X / 25 * 100)
            end
        end
    },
    {
        "Bounces",
        { "RaycastBounceCount" },
        "Custom",
        function(_, arg20) -- line: 66
            if arg20 > 0 then
                return arg20
            end
        end
    },
    {
        "Burst",
        { "BurstCount" },
        "Custom",
        function(_, arg22) -- line: 71
            if arg22 > 1 then
                return arg22
            end
        end
    },
    {
        "Burst Delay",
        { "BurstCooldown" },
        "Custom",
        function(_, arg24) -- line: 76
            if arg24 > 0 then
                return string.format("%.2f", arg24) .. "s"
            end
        end
    },
    { "Fan Cooldown", { "QuickShotCooldown" }, "Time" },
    {
        "Attack Delay",
        { "AttackDelay" },
        "Custom",
        function(_, arg26) -- line: 94
            if arg26 > 0 then
                return string.format("%.2f", arg26) .. "s"
            end
        end
    },
    { "Reach", { "Reach" } },
    { "Attack Reach", { "AttackReach" } },
    { "Heavy Damage", { "HeavyAttackDamage" } },
    { "Heavy Cooldown", { "HeavyAttackCooldown" }, "Time" },
    { "Heavy Reach", { "HeavyAttackReach" } },
    {
        "Critical Damage",
        { "CriticalDamage" },
        "Custom",
        function(arg27, arg28) -- line: 105
            -- upvalues:
            --  [1] ItemLibrary_m (copy)

            if arg28 == 0 then
                return
            end

            local v6 = ItemLibrary_m.Items[arg27]
            local v7 = v6.ShootPellets and v6.ShootPellets > 1 and string.format(
                "%.1f\195\151%s",
                arg28 / v6.ShootPellets,
                v6.ShootPellets
            ) or arg28
            local v8 = if not v6.RaycastDamageDropoffMultiplier then "" else v6.ShootPellets and v6.ShootPellets > 1 and string.format(
                "%.1f\195\151%s",
                arg28 / v6.ShootPellets * v6.RaycastDamageDropoffMultiplier,
                v6.ShootPellets
            ) or string.format("%.1f", arg28 * v6.RaycastDamageDropoffMultiplier) or ""

            return v7 .. (v8 == "" and v8 or " \226\134\146 " .. v8)
        end
    },
    {
        "Ammo",
        { "MaxAmmo" },
        "Custom",
        function(arg29, arg30) -- line: 117
            -- upvalues:
            --  [1] ItemLibrary_m (copy)

            local v10 = if arg29 == "Chainsaw" then "\226\136\158" else if arg29 ~= "Flamethrower" then (ItemLibrary_m.Items[arg29].MaxAmmoReserve or 0) > 0 and ItemLibrary_m.Items[arg29].MaxAmmoReserve or nil else "\226\136\158"

            return (if not (arg30 >= math.huge) then arg30 else "\226\136\158") .. (if not v10 then "" else " <font weight=\"600\" size=\"9\">" .. v10 .. "</font>")
        end
    },
    { "Reload", { "ReloadActionTimestamp" }, "Time" },
    {
        "Empty Reload",
        { "EmptyReloadActionTimestamp" },
        "Custom",
        function(arg31, arg32) -- line: 125
            -- upvalues:
            --  [1] ItemLibrary_m (copy)

            if math.abs(arg32 - (ItemLibrary_m.Items[arg31].ReloadActionTimestamp or 0)) > 0.001 then
                return string.format("%.2fs", arg32)
            end
        end
    },
    {
        "Reload",
        { "ReloadType" },
        "Custom",
        function(_, arg34) -- line: 130
            if arg34 == "Segmented" then
                return arg34
            end
        end
    },
    {
        "Ability Speed Boost",
        { "HoldSpeedBoostMax" },
        "Custom",
        function(_, arg36) -- line: 136
            return "+" .. math.floor(arg36 * 100 + 0.5) .. "%"
        end
    },
    {
        "Ability Damage Per Second",
        { "HoldDamageMultiplier" },
        "Custom",
        function(arg37, _) -- line: 137
            -- upvalues:
            --  [1] ItemLibrary_m (copy)

            return ItemLibrary_m.Items[arg37].AttackDamage * ItemLibrary_m.Items[arg37].HoldDamageMultiplier
        end
    },
    { "Airblast Cooldown", { "AirblastCooldown" }, "Time" },
    { "Long Heal", { "LongHeal", "Heal" } },
    { "Long Heal Time", { "LongActionTimestamp" }, "Time" },
    { "Quick Heal", { "QuickHeal" } },
    { "Quick Heal Time", { "QuickActionTimestamp" }, "Time" },
    { "Fire Radius", { "FireRadius" } },
    { "Fire Lifetime", { "FireDuration" }, "Time" },
    { "Blind Duration", { "BlindDuration" }, "Time" },
    { "Smoke Radius", { "SmokeRadius" } },
    { "Smoke Lifetime", { "SmokeDuration" }, "Time" },
    { "Deflect Cooldown", { "DeflectCooldown" }, "Time" },
    { "Deflect Duration", { "DeflectDuration" }, "Time" },
    { "Blade Cooldown", { "BladeCooldown" }, "Time" },
    { "Blade Reach", { "BladeReach" } },
    { "Blade Damage", { "BladeDamage" } },
    { "Blade Critical Damage", { "BladeCriticalDamage" } },
    { "Dash Cooldown", { "DashCooldown" }, "Time" },
    { "Build Cooldown", { "BuildCooldown" }, "Time" },
    { "Build Reach", { "BuildReach" } },
    { "Max Bricks", { "MaxBricks" } },
    { "Brick Lifetime", { "BrickLifetime" }, "Time" },
    {
        "Full Charge Time",
        { "ChargeLevelTimestamps" },
        "Custom",
        function(_, arg40) -- line: 168
            return string.format("%.2fs", arg40[#arg40])
        end
    },
    {
        "Full Charge Damage",
        { "ChargeLevelDamageMultipliers" },
        "Custom",
        function(arg41, arg42) -- line: 172
            -- upvalues:
            --  [1] ItemLibrary_m (copy)

            return string.format("%.0f", ItemLibrary_m.Items[arg41].ShootDamage * arg42[#arg42])
        end
    },
    { "Charge Damage", { "ChargeDamage" } },
    { "Charge Knockback", { "ChargeKnockbackForce" } },
    { "Charge Time", { "ChargeIntro" }, "Time" },
    { "Detonate Delay", { "DetonateDelay" }, "Time" },
    { "Splash Radius", { "SplashRadius" } },
    {
        "Speed Boost",
        { "SpeedBoost" },
        "Custom",
        function(_, arg44) -- line: 184
            return "+" .. math.floor(arg44 * 100 + 0.5) .. "%"
        end
    },
    { "Speed Duration", { "SpeedBoostDuration" }, "Time" },
    { "Spin Damage", { "SpinDamage" } },
    { "Spin Radius", { "SpinRadius" } },
    { "Spin Cooldown", { "SpinCooldown" }, "Time" },
    { "Charging Windup Time", { "ChargingWindUpLength" }, "Time" },
    {
        "Charging Move Speed",
        { "ChargingSpeedBoost" },
        "Custom",
        function(_, arg46) -- line: 194
            if arg46 == 0 then
                return "Normal"
            end

            return (if not (arg46 > 0) then "" else "+") .. math.floor(arg46 * 100 + 0.5) .. "%"
        end
    },
    { "Vortex Cooldown", { "VortexCooldown" }, "Time" },
    { "Vortex Radius", { "VortexRadius" } },
    { "Vortex Lifetime", { "VortexLifetime" }, "Time" },
    { "Knockback", { "KnockbackForce" } },
    { "Slam Cooldown", { "SlamCooldown" }, "Time" },
    { "Slam Damage", { "SlamDamage" } },
    { "Slam Radius", { "SlamRadius" } },
    {
        "Minimum Slam Altitude",
        { "SlamFloorDistance" },
        "Custom",
        function(_, arg48) -- line: 206
            return arg48 .. "studs"
        end
    },
    { "Slow Duration", { "SlowDuration" }, "Time" },
    {
        "Slow",
        { "SlowBoost" },
        "Custom",
        function(_, arg50) -- line: 211
            return math.floor(arg50 * 100 + 0.5) .. "%"
        end
    },
    {
        "Max Slow",
        { "MaxSlowBoost" },
        "Custom",
        function(_, arg52) -- line: 214
            return math.floor(arg52 * 100 + 0.5) .. "%"
        end
    },
    { "Max Slow Stacks", { "MaxSlowStacks" } },
    { "Max Freeze Duration", { "MaxFreezeDuration" }, "Time" },
    { "Freeze Duration", { "FreezeDuration" }, "Time" },
    { "Miss Cooldown", { "MissedCooldown" }, "Time" },
    { "Hook Speed", { "HookSpeed" } },
    { "Hook Range", { "HookRange" } },
    { "Pull Speed", { "SelfPullForce" } },
    { "Enemy Pull Speed", { "EnemyPullForce" } },
    { "Throw Cooldown", { "ThrowCooldown" }, "Time" },
    { "Throw Damage", { "ThrowDamage" } },
    { "Throw Radius", { "ThrowRadius" } },
    { "Critical Throw Damage", { "CriticalThrowDamage" } },
    { "Throw Knockback", { "ThrowKnockbackForce" } },
    { "Thrown Spear Length", { "ThrownSpearLength" } },
    { "Thrown Spear Lifetime", { "ThrownSpearLifetime" }, "Time" },
    { "Grenade Cooldown", { "GrenadeCooldown" }, "Time" },
    { "Grenade Explosion Radius", { "GrenadeExplosionRadius" } },
    { "Max Health", { "MaxAbsorption" } },
    {
        "Damage Reduction",
        { "AbsorptionPercent" },
        "Custom",
        function(_, arg54) -- line: 239
            return math.floor(arg54 * 100 + 0.5) .. "%"
        end
    },
    { "Lifetime", { "Lifetime" }, "Time" }
}
