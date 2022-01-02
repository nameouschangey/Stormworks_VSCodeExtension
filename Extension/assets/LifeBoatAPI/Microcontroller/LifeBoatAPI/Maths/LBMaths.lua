-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Utils.LBCopy")

---@class LBMaths
---@section LBMaths 1 LBMATHSCLASS
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

    ---@section lbmaths_ticksToSeconds
    lbmaths_ticksToSeconds = 1 / 60;
    ---@endsection

    ---@section lbmaths_secondsToTicks
    lbmaths_secondsToTicks = 60;
    ---@endsection

    --- Finds the difference between two angles, wrapped across the boundary
    --- Defaults to [0 -> 2pi], but range can be specified
    ---@overload fun(a:number, b:number):number
    ---@param a number
    ---@param b number
    ---@param minRange number (optional) minimum range value or 0
    ---@param maxRange number (optional) maximum range value or 2pi
    ---@return number difference
    ---@section lbmaths_angularSubtract
    lbmaths_angularSubtract = function(a, b, minRange, maxRange, _rangeDiff, _half)
        minRange = minRange or 0
        maxRange = maxRange or math.pi * 2
        _rangeDiff = maxRange - minRange
        _half = _rangeDiff / 2
        return ((a-minRange - b+minRange + _half) % _rangeDiff - _half)
    end;
    ---@endsection

    ---Converts a compass value into the range [0 North => 2pi radians, clockwise]
    ---@param compass number compass value from the sensor
    ---@section lbmaths_compassToAzimuth
    lbmaths_compassToAzimuth = function(compass)
        return -compass % 1 * math.pi * 2
    end;
    ---@endsection

    ---Converts a tilt sensor value into the range [-pi/2 radians vertically down => 0 horizontal => +pi/2 radians vertically up ]
    ---@param tiltSensor number tilt value from the tilt sensor
    ---@return number elevation tilt as an angle in radians
    ---@section lbmaths_tiltSensorToElevation
    lbmaths_tiltSensorToElevation = function (tiltSensor)
        return tiltSensor * math.pi * 2
    end;
    ---@endsection

    ---Tests whether a point is in the given rectangle or not
    ---@param x number x position to test
    ---@param y number y position to test
    ---@param rectX number topLeft corner of the rectangle
    ---@param rectY number topLeft corner of the rectangle
    ---@param rectWidth number width of the rectangle
    ---@param rectHeight number height of the rectangle
    ---@return boolean isInRectangle true if the point is within the given rectangle
    ---@section lbmaths_isPointInRectangle
    lbmaths_isPointInRectangle = function(x, y, rectX, rectY, rectWidth, rectHeight)
        return x > rectX and x < rectX+rectWidth and y > rectY and y < rectY+rectHeight; 
    end;
    ---@endsection

    ---@param startValue number number to lerp from
    ---@param endValue number number to lerp to
    ---@param t number lerp parameter, between 0->1
    ---@section lbmaths_isPointInRectangle
    lbmaths_lerp = function(startValue, endValue, t)
        return (1-t) * startValue + t * endValue
    end;
    ---@endsection

    ---Updated an existing average
    ---See LBRollingAverage for a "last x values" average
    ---Can be useful when you do not know the number of values you are averaging
    ---Example: myAverage, numValuesAveraged = LBMaths.lbmaths_updateAverage(123, myAverage, numValuesAveraged)
    ---@param currentAverage number last calculated average value
    ---@param newValue number value to add into the average
    ---@param numberOfValues number number of times this average has been run up till now. First run should be 0
    ---@return number,number newAverage newAverage, numberOfValues updated average and next numberOfValues to pass in 
    ---@section lbmaths_updateAverage
    lbmaths_updateAverage = function (newValue, currentAverage, numberOfValues)
        currentAverage = currentAverage or 0
        numberOfValues = numberOfValues or 0
        return (currentAverage * numberOfValues + newValue) / (numberOfValues + 1), numberOfValues + 1
    end;
    ---@endsection
}
---@endsection LBMATHSCLASS