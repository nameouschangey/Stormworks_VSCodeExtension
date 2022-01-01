-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

------------------------------------------------------------------------------------------------------------------------
-- multiplicative shorthands; e.g. a = 360 * degrees2rads

LifeBoatAPI.LBMaths = {
    ---@section lbmaths_2pi
    lbmaths_2pi = math.pi * 2;
    ---@endsection

    ---@section lbmaths_degsToRads
    lbmaths_degsToRads = math.pi / 180;
    ---@endsection

    ---@section lbmaths_turnsToRads
    ---alias for 2pi
    lbmaths_turnsToRads = math.pi * 2;
    ---@endsection

    ---@section lbmaths_radsToDegrees
    lbmaths_radsToDegrees = 180 / math.pi;
    ---@endsection

    ---@section lbmaths_radsToTurns
    lbmaths_radsToTurns = 1 / math.pi * 2;
    ---@endsection

    --- Finds the difference between two angles, wrapped across the boundary
    --- Defaults to [0 -> 2pi], but range can be specified
    ---@overload fun(a:number, b:number):number
    ---@param a number
    ---@param b number
    ---@param minRange number (optional) minimum range value or 0
    ---@param maxRange number (optional) maximum range value or 2pi
    ---@return number difference
    lbmaths_angularSubtract = function(a, b, minRange, maxRange, _rangeDiff, _half)
        minRange = minRange or 0
        maxRange = maxRange or math.pi * 2
        _rangeDiff = maxRange - minRange
        _half = _rangeDiff / 2
        return ((a-minRange - b+minRange + _half) % _rangeDiff - _half)
    end;
}

