--[[
Stats From Heracles421 on the Stormworks discord
Stats From Bones       on the Stormworks discord

Note:
- Larger caliber projectiles receive proportionally less force from the wind
]]

LBWeapon_SmallArms = {
    DragCoefficient   = 0;      -- technically "Unknown"
    MuzzleVelocity    = 800;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 300;    -- ticks
    DespawnsInAir     = true;
    ApproxMaxRange    = 500;    -- meters till despawn
}

LBWeapon_LightAutoCannon = {
    DragCoefficient   = 0.02;      -- technically "Unknown"
    MuzzleVelocity    = 1000;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 300;    -- ticks
    DespawnsInAir     = true;
    ApproxMaxRange    = 750;    -- meters till despawn
}

LBWeapon_RotaryAutoCannon = {
    DragCoefficient   = 0.01;   -- technically "Unknown"
    MuzzleVelocity    = 1000;   -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 300;    -- ticks
    DespawnsInAir     = true;
    ApproxMaxRange    = 1500;   -- meters till despawn
}

LBWeapon_HeavyAutoCannon = {
    DragCoefficient   = 0.005;      -- technically "Unknown"
    MuzzleVelocity    = 900;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 600;    -- ticks
    DespawnsInAir     = true;
    ApproxMaxRange    = 2500;   -- meters till despawn
}

LBWeapon_BattleCannon = {
    --[[

    Battle Cannon
    Muzzle velocity (m/s): 800m
    Drag Coefficient: 0.002
    Gravity: 30 m/s^2, 0.5m/s/t
    Despawn Timer (ticks): 3600
    Despawn Speed (m/s): N/A (50m/s underwater)  
    ]]
    DragCoefficient   = 0.002;      -- technically "Unknown"
    MuzzleVelocity    = 800;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 3600;   -- ticks
    DespawnsInAir     = false;
    ApproxMaxRange    = 4500;   -- meters indirect range at 45*
}

LBWeapon_Artillery = {
    --[[
        Artillery Cannon
    Muzzle velocity (m/s): 700
    Drag Coefficient: 0.001
    Gravity: 30 m/s^2, 0.5m/s/t
    Despawn Timer (ticks): 3600
    Despawn Speed (m/s): N/A (50m/s underwater)
    ]]
    DragCoefficient   = 0.001;      -- technically "Unknown"
    MuzzleVelocity    = 700;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 3600;    -- ticks
    DespawnsInAir     = false;
    ApproxMaxRange    = 6500;   -- meters indirect range at 45*
}

LBWeapon_BigBertha = {
    --[[
    Big Bertha Cannon
    Muzzle velocity (m/s): 600
    Drag Coefficient: 0.0005
    Gravity: 30 m/s^2, 0.5m/s/t
    Despawn Timer (ticks): 3600
    Despawn Speed (m/s): N/A (50m/s underwater)
    ]]
    DragCoefficient   = 0.0005;      -- technically "Unknown"
    MuzzleVelocity    = 600;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 3600;    -- ticks
    DespawnsInAir     = false;
    ApproxMaxRange    = 7500;   -- meters indirect range at 45*
}

LBWeapon_RocketLauncher = {
    --[[
        Rocket Launcher
        Muzzle velocity (m/s): ? (This guy accelerates for a certain amount of time)
        Drag Coefficient: 0.003
        Gravity: 30 m/s^2, 0.5m/s/t
        Despawn Timer (ticks): 3600
        Despawn Speed (m/s): N/A (50m/s underwater)
    ]]
    DragCoefficient   = 0.003;  -- technically "Unknown"
    MuzzleVelocity    = 0;      -- non-ballistic weapon, accelerates at an unknown rate
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 3600;   -- ticks
    DespawnsInAir     = false;
    ApproxMaxRange    = 2500;   -- meters indirect range at 45*
}