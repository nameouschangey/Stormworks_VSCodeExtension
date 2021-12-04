-- Stats From Heracles421 on the Stormworks discord
-- Stats From Bones       on the Stormworks discord

-- Note:
--   Larger caliber projectiles receive proportionally less force from the wind

---@section LBWeapon_SmallArms
LBWeapon_SmallArms = {
    DragCoefficient   = 0;      -- technically "Unknown"
    MuzzleVelocity    = 800;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 300;    -- ticks
    DespawnsInAir     = true;
    ApproxMaxRange    = 500;    -- meters till despawn
}
---@endsection

---@section LBWeapon_LightAutoCannon
LBWeapon_LightAutoCannon = {
    DragCoefficient   = 0.02;      -- technically "Unknown"
    MuzzleVelocity    = 1000;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 300;    -- ticks
    DespawnsInAir     = true;
    ApproxMaxRange    = 750;    -- meters till despawn
}
---@endsection

---@section LBWeapon_RotaryAutoCannon
LBWeapon_RotaryAutoCannon = {
    DragCoefficient   = 0.01;   -- technically "Unknown"
    MuzzleVelocity    = 1000;   -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 300;    -- ticks
    DespawnsInAir     = true;
    ApproxMaxRange    = 1500;   -- meters till despawn
}
---@endsection

---@section LBWeapon_HeavyAutoCannon
LBWeapon_HeavyAutoCannon = {
    DragCoefficient   = 0.005;      -- technically "Unknown"
    MuzzleVelocity    = 900;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 600;    -- ticks
    DespawnsInAir     = true;
    ApproxMaxRange    = 2500;   -- meters till despawn
}
---@endsection

---@section LBWeapon_BattleCannon
LBWeapon_BattleCannon = {
    DragCoefficient   = 0.002;      -- technically "Unknown"
    MuzzleVelocity    = 800;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 3600;   -- ticks
    DespawnsInAir     = false;
    ApproxMaxRange    = 4500;   -- meters indirect range at 45*
}
---@endsection

---@section LBWeapon_Artillery
LBWeapon_Artillery = {
    DragCoefficient   = 0.001;      -- technically "Unknown"
    MuzzleVelocity    = 700;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 3600;    -- ticks
    DespawnsInAir     = false;
    ApproxMaxRange    = 6500;   -- meters indirect range at 45*
}
---@endsection

---@section LBWeapon_BigBertha
LBWeapon_BigBertha = {
    DragCoefficient   = 0.0005;      -- technically "Unknown"
    MuzzleVelocity    = 600;    -- m/s
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 3600;    -- ticks
    DespawnsInAir     = false;
    ApproxMaxRange    = 7500;   -- meters indirect range at 45*
}
---@endsection

---@section LBWeapon_RocketLauncher
LBWeapon_RocketLauncher = {
    DragCoefficient   = 0.003;  -- technically "Unknown"
    MuzzleVelocity    = 0;      -- non-ballistic weapon, accelerates at an unknown rate
    Gravity           = 30;     -- m/s
    DespawnBelowSpeed = 50;     -- m/s
    DespawnTicks      = 3600;   -- ticks
    DespawnsInAir     = false;
    ApproxMaxRange    = 2500;   -- meters indirect range at 45*
}
---@endsection