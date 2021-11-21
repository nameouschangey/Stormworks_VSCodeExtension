-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

------------------------------------------------------------------------------------------------------------------------
-- multiplicative shorthands; e.g. a = 360 * degrees2rads

---@section LBAngles_2PI
LBAngles_2PI = math.pi * 2
---@endsection

---@section LBAngles_degsToRads
LBAngles_degsToRads = math.pi / 180
---@endsection

---@section LBAngles_turnsToRads
LBAngles_turnsToRads = LBAngles_2PI
---@endsection

---@section LBAngles_radsToDegrees
LBAngles_radsToDegrees = 180 / math.pi
---@endsection

---@section LBAngles_radsToTurns
LBAngles_radsToTurns = 1 / LBAngles_2PI
---@endsection

------------------------------------------------------------------------------------------------------------------------
-- function versions, not going to be a good use of space, but may be nicer to use for some people if they've got characters to spare

--- @param degrees number degrees to convert to rads
---@section LBAngles_convertDegreesToRadians
function LBAngles_convertDegreesToRadians(degrees)
    return  degrees * LBAngles_degsToRads
end
---@endsection



--- @param turns number turns (360* = 1 turn) to convert to rads
---@section LBAngles_convertTurnsToRadians
function LBAngles_convertTurnsToRadians(turns)
    return turns * LBAngles_turnsToRads
end
---@endsection



--- @param radians number rads to convert
---@section LBAngles_convertRadiansToTurns
function LBAngles_convertRadiansToTurns(radians)
    return radians * LBAngles_radsToTurns
end
---@endsection



--- @param radians number rads to convert
---@section LBAngles_convertRadiansToDegrees
function LBAngles_convertRadiansToDegrees(radians)
    return radians * LBAngles_radsToDegrees
end
---@endsection